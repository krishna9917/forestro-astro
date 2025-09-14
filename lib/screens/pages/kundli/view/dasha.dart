import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/data/model/kundali/dasha/anterdasha_model.dart';
import 'package:fore_astro_2/core/data/model/kundali/dasha/paryantardasha_model.dart';
import 'package:fore_astro_2/core/data/model/kundali/dasha/pranadasha_model.dart';
import 'package:fore_astro_2/core/data/model/kundali/dasha/shookshamadasha_model.dart';
import 'package:fore_astro_2/core/data/model/kundali/dasha/vimshotri_model.dart';
import 'package:fore_astro_2/core/data/repository/VedicAstroAPIRepo.dart';
import 'package:google_fonts/google_fonts.dart';

class DashaScreen extends StatefulWidget {
  final Vimsotridasa_Model mahadshamodel;
  final String dob;
  final String tob;
  final double lat;
  final double lng;
  final String lang;

  const DashaScreen({
    super.key,
    required this.mahadshamodel,
    required this.dob,
    required this.tob,
    required this.lat,
    required this.lng,
    required this.lang,
  });

  @override
  _DashaScreenState createState() => _DashaScreenState();
}

class _DashaScreenState extends State<DashaScreen> {
  late Antardasha_Model antardashaList;
  late Paryantardasha_Model paryantardashaList;
  late Shookshamadasha_Model shookshamadashaList;
  late Pranadasha_Model pranadashaList;

  bool isLoading = false;
  bool isAntardashaShown = false;
  bool isParyantardashaShown = false;
  bool isShookshamadashaShown = false;
  bool isPranadashaShown = false;

  // List to maintain the Dasha hierarchy
  List<String> selectedDashas = [];

  String _getFullDashaName() {
    return selectedDashas.join(' - ');
  }

  @override
  Widget build(BuildContext context) {
    String _capitalizeEachWord(String input) {
      return input.split(' ').map((word) {
        if (word.isNotEmpty) {
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        }
        return word;
      }).join(' ');
    }

    List<dynamic> dataList = isPranadashaShown
        ? (pranadashaList.response?.toJson()['pranadasha'] ?? [])
        : isShookshamadashaShown
            ? (shookshamadashaList.response?.toJson()['shookshamadasha'] ?? [])
            : isParyantardashaShown
                ? (paryantardashaList.response?.toJson()['paryantardasha'] ??
                    [])
                : isAntardashaShown
                    ? (antardashaList.response?.toJson()['antardasha'] ?? [])
                    : (widget.mahadshamodel.response?.toJson()['mahadasha'] ??
                        []);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(isPranadashaShown
                ? 'Pranadasha Details'
                : isShookshamadashaShown
                    ? 'Shookshamadasha Details'
                    : isParyantardashaShown
                        ? 'Paryantardasha Details'
                        : isAntardashaShown
                            ? 'Antardasha Details'
                            : 'Mahadasha Details'),
            Text(_getFullDashaName()),
          ],
        ),
        leading: (isAntardashaShown ||
                isParyantardashaShown ||
                isShookshamadashaShown ||
                isPranadashaShown)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    if (selectedDashas.isNotEmpty) {
                      selectedDashas.removeLast();
                    }
                    if (isPranadashaShown) {
                      isPranadashaShown = false;
                    } else if (isShookshamadashaShown) {
                      isShookshamadashaShown = false;
                    } else if (isParyantardashaShown) {
                      isParyantardashaShown = false;
                    } else {
                      isAntardashaShown = false;
                    }
                  });
                },
              )
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable(
                border: TableBorder.all(
                  color: Colors.grey,
                  width: 1,
                  borderRadius: BorderRadius.circular(8),
                ),
                columnSpacing: 12,
                columns: const [
                  DataColumn(label: Text('Dasha')),
                  DataColumn(label: Text('Start Date')),
                  DataColumn(label: Text('End Date')),
                  DataColumn(label: Text('')),
                ],
                rows: dataList.map((data) {
                  return DataRow(
                    cells: [
                      DataCell(Text(
                        data['name']?.substring(0, 2).toUpperCase() ?? 'N/A',
                      )),
                      DataCell(Text(
                        data['start'] != null
                            ? (data['start'].length > 16
                                ? data['start'].substring(0, 16)
                                : data['start'])
                            : 'N/A',
                        style: GoogleFonts.inter(fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(
                        data['end'] != null
                            ? (data['end'].length > 16
                                ? data['end'].substring(0, 16)
                                : data['end'])
                            : 'N/A',
                        style: GoogleFonts.inter(fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(IconButton(
                        onPressed: () async {
                          String dashaName = data['name'] ?? '';
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            var response = await VedicAstroAPIRepo.vimsotridasa(
                              widget.dob,
                              widget.tob,
                              widget.lat,
                              widget.lng,
                              widget.lang,
                              mahadashaName: dashaName,
                              ad: isAntardashaShown ? dashaName : null,
                              pd: isParyantardashaShown ? dashaName : null,
                              sd: isShookshamadashaShown ? dashaName : null,
                            );

                            setState(() {
                              // Add the selected Dasha name to the hierarchy
                              selectedDashas.add(dashaName);
                              if (isShookshamadashaShown) {
                                pranadashaList =
                                    Pranadasha_Model.fromJson(response);
                                isPranadashaShown = true;
                              } else if (isParyantardashaShown) {
                                shookshamadashaList =
                                    Shookshamadasha_Model.fromJson(response);
                                isShookshamadashaShown = true;
                              } else if (isAntardashaShown) {
                                paryantardashaList =
                                    Paryantardasha_Model.fromJson(response);
                                isParyantardashaShown = true;
                              } else {
                                antardashaList =
                                    Antardasha_Model.fromJson(response);
                                isAntardashaShown = true;
                              }
                              isLoading = false;
                            });
                          } catch (e) {
                            print("Error: $e");
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                        icon: const Icon(Icons.keyboard_arrow_right),
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
            if (isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fore_astro_2/core/data/repository/VedicAstroAPIRepo.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';

class DashaChartPage extends StatefulWidget {
  final String dob;
  final String tob;
  final double lat;
  final double lng;
  final String lang;
  const DashaChartPage({
    super.key,
    required this.dob,
    required this.tob,
    required this.lat,
    required this.lng,
    required this.lang,
  });

  @override
  State<DashaChartPage> createState() => _DashaChartPageState();
}

class _DashaChartPageState extends State<DashaChartPage>
    with SingleTickerProviderStateMixin {
  final List<String> tabNames = ["D9", "D10"];
  final List<String> tabLabels = ["D9 (Navamsa)", "D10 (Dasamsa)"];
  late TabController _tabController;

  String? ab;
  String? bc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabNames.length, vsync: this);
    _fetchChartData(tabNames[0]);
    _tabController.addListener(() async {
      if (_tabController.indexIsChanging) {
        await _fetchChartData(tabNames[_tabController.index]);
      }
    });
  }

  Future<void> _fetchChartData(String tab) async {
    try {
      var abData = await VedicAstroAPIRepo.divisionalChartData(
        dob: widget.dob,
        tob: widget.tob,
        lat: widget.lat,
        lon: widget.lng,
        div: tab,
      );
      var bcData = await VedicAstroAPIRepo.divisionalChartDatas(
        dob: widget.dob,
        tob: widget.tob,
        lat: widget.lat,
        lon: widget.lng,
        div: tab,
      );

      setState(() {
        ab = abData ?? '';
        bc = bcData ?? '';
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabNames.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: tabLabels.map((label) => Tab(text: label)).toList(),
              indicatorColor: AppColor.primary,
              labelColor: AppColor.primary,
              unselectedLabelColor: Colors.grey,
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: tabNames.map((tab) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text("North",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1.5,
                        color: const Color.fromARGB(255, 234, 234, 234),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ab != null && ab!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.string(ab!),
                          )
                        : Container(), // Handle null or empty ab
                  ),
                ),
                const SizedBox(height: 16),
                const Text("South",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1.5,
                        color: const Color.fromARGB(255, 234, 234, 234),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: bc != null && bc!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.string(bc!),
                          )
                        : Container(), // Handle null or empty bc
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

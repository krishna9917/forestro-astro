import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fore_astro_2/Components/Inputs/CompleteProfileInputBox.dart';
import 'package:fore_astro_2/core/data/model/UserModel.dart';
import 'package:fore_astro_2/core/data/model/kundali/Binnashtakvarga_Model.dart';
import 'package:fore_astro_2/core/data/model/kundali/Personal_Characteristics_Model.dart';
import 'package:fore_astro_2/core/data/model/kundali/assedent_model.dart';
import 'package:fore_astro_2/core/data/model/kundali/dasha/vimshotri_model.dart';
import 'package:fore_astro_2/core/data/model/kundali/kp_housemodel.dart';
import 'package:fore_astro_2/core/data/model/kundali/plannet_model.dart';
import 'package:fore_astro_2/core/data/repository/VedicAstroAPIRepo.dart';
import 'package:fore_astro_2/core/data/repository/profileRepo.dart';
import 'package:fore_astro_2/core/extensions/window.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:fore_astro_2/core/helper/helper.dart';
import 'package:fore_astro_2/screens/pages/kundli/CombinedDetailsView.dart';
import 'package:fore_astro_2/screens/pages/kundli/SearchLocation.dart';
import 'package:intl/intl.dart';

final Map<String, String> languageMap = {
  "English": "en",
  "Hindi": "hi",
};

class KundliForm extends StatefulWidget {
  String? name;
  int id;
  KundliForm({super.key, this.name = "User", required this.id});

  @override
  State<KundliForm> createState() => _KundliFormState();
}

class _KundliFormState extends State<KundliForm> {
  TextEditingController _adress = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _dot = TextEditingController();
  String _lang = "en";
  UserModel? user;
  ExpectAddressLatLog? locationData;
  bool userLoading = false;
  bool loading = false;
  loadUserData() async {
    try {
      setState(() {
        userLoading = true;
      });
      dio.Response userData = await ProfileRepo.getUser(widget.id.toString());
      user = UserModel.fromJson(userData.data['data']);
      var latlong = await fetchCoordinates(
          "${user!.city},${user!.state},${user!.country}");

      setState(() {
        userLoading = false;
        _adress.text = "${user!.city},${user!.state},${user!.country}";
        locationData = ExpectAddressLatLog(
          address: "${user!.city},${user!.state},${user!.country}",
          let: latlong['lat'],
          lng: latlong['lng'],
        );
        _dob.text = user!.dateOfBirth.toString().replaceAll("-", "/");
        _dot.text = user!.birthTime.toString();
      });
    } catch (e) {
      setState(() {
        userLoading = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    loadUserData();
    super.initState();
  }

  fetchUserKhundli() async {
    try {
      setState(() {
        loading = true;
      });
      var planetDetails = await VedicAstroAPIRepo.getDetails(
          "horoscope/planet-details",
          lang: _lang,
          dob: _dob.text,
          tob: _dot.text,
          lat: locationData!.let!,
          lon: locationData!.lng!);
      PlanetModel planetModel = PlanetModel.fromJson(planetDetails);

      var ascendantReport = await VedicAstroAPIRepo.getDetails(
          "horoscope/ascendant-report",
          lang: _lang,
          dob: _dob.text,
          tob: _dot.text,
          lat: locationData!.let!,
          lon: locationData!.lng!);

      AsedentReportModel ascendantReportModel =
          AsedentReportModel.fromJson(ascendantReport);

      // var planetReport = await VedicAstroAPIRepo.getDetails("planet-report",
      //     lang: _lang,
      //     dob: _dob.text,
      //     tob: _dot.text,
      //     lat: locationData!.let!,
      //     lon: locationData!.lng!);

      var personalCharacteristics = await VedicAstroAPIRepo.getDetails(
          "horoscope/personal-characteristics",
          lang: _lang,
          dob: _dob.text,
          tob: _dot.text,
          lat: locationData!.let!,
          lon: locationData!.lng!);

      Personal_Characteristics_Model personalCharacteristicsModel =
          Personal_Characteristics_Model.fromJson(personalCharacteristics);

      var kphouses = await VedicAstroAPIRepo.getDetails(
          "extended-horoscope/kp-houses",
          lang: _lang,
          dob: _dob.text,
          tob: _dot.text,
          lat: locationData!.let!,
          lon: locationData!.lng!);

      KpHouseModel kpHouseModel = KpHouseModel.fromJson(kphouses);

      var binnashtakvarga = await VedicAstroAPIRepo.getDetails(
          "horoscope/binnashtakvarga",
          lang: _lang,
          dob: _dob.text,
          tob: _dot.text,
          lat: locationData!.let!,
          lon: locationData!.lng!);
      print(binnashtakvarga);
      Binnashtakvarga_Model binnashtakvarga_model =
          Binnashtakvarga_Model.fromJson(binnashtakvarga);

      var chartImage = await VedicAstroAPIRepo.getChartImage(
          lang: _lang,
          dob: _dob.text,
          tob: _dot.text,
          lat: locationData!.let!,
          lon: locationData!.lng!);

      //  var d9Image = await VedicAstroAPIRepo.divisionalChartData(

      // dob: _dob.text,
      // tob: _dot.text,
      // lat: locationData!.let!,
      // lon: locationData!.lng!, div: '');

      Vimsotridasa_Model? mahadshamodel;
      try {
        var vimsotridasa = await VedicAstroAPIRepo.vimsotridasa(
          _dob.text,
          _dot.text,
          locationData!.let!,
          locationData!.lng!,
          _lang,
        );
        mahadshamodel = Vimsotridasa_Model.fromJson(vimsotridasa);
      } catch (e) {
        print("Error fetching Vimsotridasa data: $e");
      }

      var kundaliImage = await VedicAstroAPIRepo.getkundaliImage(
          lang: _lang,
          dob: _dob.text,
          tob: _dot.text,
          lat: locationData!.let!,
          lon: locationData!.lng!);
      var kundaliImages = await VedicAstroAPIRepo.getkundaliImages(
          lang: _lang,
          dob: _dob.text,
          tob: _dot.text,
          lat: locationData!.let!,
          lon: locationData!.lng!);

      setState(() {
        loading = false;
      });

      navigateme.push(routeMe(
        ViewKnuldliData(
          planetModel: planetModel,
          asedentReportModel: ascendantReportModel,
          personal_characteristics_model: personalCharacteristicsModel,
          kpHouseModel: kpHouseModel,
          binnashtakvarga_model: binnashtakvarga_model,
          chart: chartImage,
          kundaliimge: kundaliImage,
          kundaliimges: kundaliImages,
          user: user!,
          expectAddressLatLog: locationData!,
          // vimsotridasa: vimsotridasa,
          dob: _dob.text,
          tob: _dot.text,
          lat: locationData!.let!,
          lng: locationData!.lng!,
          lang: _lang,
          mahadshamodel: mahadshamodel!,
        ),
      ));
    } catch (e) {
      setState(() {
        loading = false;
      });
      print(e);
      showToast("Error To Generate! Please Verify all data is valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(user?.name);
    return Scaffold(
      appBar: AppBar(
        title: Text("View ${widget.name} Kundli"),
      ),
      body: Builder(builder: (context) {
        if (userLoading) {
          return const Center(
            child: CircularProgressIndicator(
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.white,
            ),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CompleteProfileInputBox(
                  title: "Enter Birth Place",
                  textEditingController: _adress,
                  readOnly: true,
                  prefixIcon: const Icon(Icons.location_on_rounded),
                  onTap: () {
                    navigateme.push(routeMe(GoogleMapSearchPlacesApi(
                      onSelect: (e) {
                        setState(() {
                          _adress.text = e.address;
                          locationData = e;
                        });
                      },
                    )));
                  },
                ),
                const SizedBox(height: 10),
                CompleteProfileInputBox(
                  readOnly: true,
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (selectedDate != null) {
                      String formattedDate =
                          DateFormat('MM/dd/yyyy').format(selectedDate);
                      _dob.text = formattedDate;
                    }
                  },
                  title: "Date of Birth",
                  textEditingController: _dob,
                  prefixIcon: IconButton(
                    onPressed: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (selectedDate != null) {
                        // Format the date as MM/dd/yyyy
                        String formattedDate =
                            DateFormat('MM/dd/yyyy').format(selectedDate);
                        _dob.text = formattedDate;
                      }
                    },
                    icon: const Icon(Icons.calendar_month_rounded),
                  ),
                ),
                const SizedBox(height: 20),
                CompleteProfileInputBox(
                  readOnly: true, 
                  onTap: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (selectedTime != null) {
                      String formattedTime = selectedTime.format(context);
                      _dot.text = formattedTime;
                    }
                  },
                  title: "Time of Birth",
                  textEditingController: _dot,
                  prefixIcon: IconButton(
                    onPressed: () async {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (selectedTime != null) {
                        String formattedTime = selectedTime.format(context);
                        _dot.text = formattedTime;
                      }
                    },
                    icon: const Icon(Icons.av_timer_rounded),
                  ),
                ),
                const SizedBox(height: 20),
                CompleteProfileSelectBox(
                  list: languageMap.keys.toList(),
                  onChanged: (e) {
                    setState(() {
                      _lang = languageMap[e]!;
                    });
                  },
                  title: "Language",
                ),
                const SizedBox(height: 30),
                SizedBox(
                    width: context.windowWidth,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: loading
                            ? null
                            : () {
                                fetchUserKhundli();
                              },
                        child: Builder(builder: (context) {
                          if (loading) {
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            );
                          }
                          return const Text("View Kundli");
                        }))),
                const SizedBox(height: 20),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      }),
    );
  }
}

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fore_astro_2/Components/Inputs/CompleteProfileInputBox.dart';
import 'package:fore_astro_2/core/helper/Navigate.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

Future<Map<String, double>> fetchCoordinates(String address) async {
  const apiKey = 'AIzaSyBXwHH1AuqJEY9yoxCPD_e04t9hEiYM9SQ';
  final url = Uri.parse(
    'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey',
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final location = data['results'][0]['geometry']['location'];
    return {
      'lat': location['lat'],
      'lng': location['lng'],
    };
  } else {
    throw Exception('Failed to fetch coordinates');
  }
}

class ExpectAddressLatLog {
  String address;
  double? let;
  double? lng;
  ExpectAddressLatLog(
      {required this.address, required this.let, required this.lng});
}

class GoogleMapSearchPlacesApi extends StatefulWidget {
  final Function(ExpectAddressLatLog e) onSelect;
  const GoogleMapSearchPlacesApi({Key? key, required this.onSelect})
      : super(key: key);

  @override
  _GoogleMapSearchPlacesApiState createState() =>
      _GoogleMapSearchPlacesApiState();
}

class _GoogleMapSearchPlacesApiState extends State<GoogleMapSearchPlacesApi> {
  final _controller = TextEditingController();
  var uuid = const Uuid();
  String _sessionToken = '1234567890';
  List<dynamic> _placeList = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    const String placesApiKey = "AIzaSyBXwHH1AuqJEY9yoxCPD_e04t9hEiYM9SQ";

    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?input=$input&key=$placesApiKey&sessiontoken=$_sessionToken';
      var response = await http.get(Uri.parse(request));
      var data = json.decode(response.body);
      if (kDebugMode) {
        print('mydata');
        print(data);
      }
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Search Your places',
        ),
      ),
      body: Builder(builder: (context) {
        if (loading) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: CompleteProfileInputBox(
                    title: "",
                    autofocus: true,
                    textEditingController: _controller,
                  )),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _placeList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      // Navigator.pop(context, _placeList[index]["description"]);
                      FocusScope.of(context).unfocus();

                      try {
                        setState(() {
                          loading = true;
                        });
                        Map<String, double> data = await fetchCoordinates(
                            _placeList[index]["description"]);
                        widget.onSelect(ExpectAddressLatLog(
                          address: _placeList[index]["description"],
                          let: data['lat'],
                          lng: data['lng'],
                        ));

                        navigateme.pop();
                      } catch (e) {
                        setState(() {
                          loading = false;
                        });
                      }
                      // setState(
                      //   () {
                      //     _controller.text = _placeList[index]["description"];
                      //     _placeList = [];
                      //   },
                      // );
                    },
                    child: ListTile(
                      title: Text(_placeList[index]["description"]),
                    ),
                  );
                },
              ),
            )
          ],
        );
      }),
    );
  }
}

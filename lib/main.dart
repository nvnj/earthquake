import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map quakes;
List features;

void main() async {
  quakes = await getQuakes();
  features = quakes['features'];
  //print(quakes);
  runApp(MaterialApp(
    home: Quakes(),
  ));
}

class Quakes extends StatefulWidget {
  @override
  _QuakesState createState() => _QuakesState();
}

class _QuakesState extends State<Quakes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("EarthQuake"),
          centerTitle: true,
        ),
        body: Center(
          child: ListView.builder(
            itemCount: features.length,
            //padding: EdgeInsets.all(1.0),
            itemBuilder: (BuildContext context, int position) {
              if (position.isOdd) return Divider();
              final index = position ~/ 2;
              var format = DateFormat.yMMMd("en_US").add_jm();
              var date = format.format(DateTime.fromMicrosecondsSinceEpoch(
                  features[index]['properties']['time'] * 1000,
                  isUtc: true));
              return ListTile(
                //dense: true,
                  leading: CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      "${features[index]['properties']['mag']}",
                      style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  title: Row(
                    children: <Widget>[
                      Icon(Icons.location_on),
                      Text(
                        "${features[index]['properties']['place']}",
                        style: TextStyle(fontWeight: FontWeight.w700),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    "       $date",
                    style: TextStyle(
                        color: Colors.black26,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    showAlertDialogue(
                        context, "${features[index]['properties']['title']}");
                  }
              );
            },
          ),
        ));
  }

  void showAlertDialogue(BuildContext context, String message) {
    var alert = AlertDialog(
      title: Text("Quakes"),
      content: Text(message),
      actions: <Widget>[
        FlatButton(onPressed: () {
          Navigator.pop(context);
        }, child: Text("OK"))
      ],
    );
    showDialog(context: context,child: alert);
  }
}


Future<Map> getQuakes() async {
  String apiUrl =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(apiUrl);
  return jsonDecode(response.body);
}

import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final _sizeTextBlack = const TextStyle(fontSize: 20.0, color: Colors.black);
final _sizeTextWhite = const TextStyle(fontSize: 20.0, color: Colors.white);

void main() => runApp(MaterialApp(
      home: HomeScreenWigget(),
    ));

class HomeScreenWigget extends StatefulWidget {
  @override
  _HomeScreenWiggetState createState() => _HomeScreenWiggetState();
}

class _HomeScreenWiggetState extends State<HomeScreenWigget> {
  final inputController = TextEditingController();
  var widgetText = "";

  void sendRequest() async {
    print('Send Request: ' +
        jsonEncode(<String, String>{
          'data': inputController.text,
        }));

    Dio dio = new Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    Response response = await dio.post("https://10.0.2.2:3000/hash",
        data: jsonEncode(<String, String>{
          'data': inputController.text,
        }));

    Map<String, dynamic> jsonResp = jsonDecode(response.toString());
    print('Get response from server: ${jsonResp['hash']}!');

    setState(() {
      widgetText = jsonResp['hash'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new Center(
            child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(25.0),
              child: new Container(
                child: new TextField(
                  decoration: new InputDecoration(
                      labelText: "Enter Base64 value to get SHA-256"),
                  keyboardType: TextInputType.text,
                  style: _sizeTextBlack,
                  controller: inputController,
                ),
                width: 400.0,
              ),
            ),
            new Container(
              child: Center(
                child: Text(widgetText),
              ),
              width: 400.0,
              padding: new EdgeInsets.only(top: 10.0, left: 5, right: 5),
            ),
            new Padding(
              padding: new EdgeInsets.only(top: 25.0),
              child: new MaterialButton(
                color: Theme.of(context).accentColor,
                height: 50.0,
                minWidth: 150.0,
                onPressed: sendRequest,
                child: new Text(
                  "Hash",
                  style: _sizeTextWhite,
                ),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.only(top: 95.0),
              child: new MaterialButton(
                color: Theme.of(context).accentColor,
                height: 50.0,
                minWidth: 150.0,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondRoute()),
                  );
                },
                child: new Text(
                  "Second Task",
                  style: _sizeTextWhite,
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}

class SecondRoute extends StatefulWidget {
  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  final inputData = TextEditingController();
  final inputHash = TextEditingController();

  var widgetText = "";

  void vHash() async {
    print('Send Request: ' +
        jsonEncode(
            <String, String>{'data': inputData.text, 'hash': inputHash.text}));

    Dio dio = new Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    Response response = await dio.post("https://10.0.2.2:3000/vhash",
        data: jsonEncode(<String, String>{
          'data': inputData.text,
          'hash': inputHash.text,
        }));

    Map<String, dynamic> jsonResp = jsonDecode(response.toString());
    print('Get response from server: ${jsonResp['hash']}!');

    setState(() {
      widgetText = jsonResp['status'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.all(25.0),
            child: new Container(
              child: new TextField(
                decoration:
                    new InputDecoration(labelText: "Enter Base64 value"),
                keyboardType: TextInputType.text,
                style: _sizeTextBlack,
                controller: inputData,
              ),
              width: 400.0,
            ),
          ),
          new Padding(
            padding: new EdgeInsets.only(left: 25, right: 25, top: 5),
            child: new Container(
              child: new TextField(
                decoration:
                    new InputDecoration(labelText: "Enter hash of value"),
                keyboardType: TextInputType.text,
                style: _sizeTextBlack,
                controller: inputHash,
              ),
              width: 400.0,
            ),
          ),
          new Container(
            child: Center(
              child: Text(widgetText),
            ),
            width: 400.0,
            padding: new EdgeInsets.only(top: 10.0, left: 5, right: 5),
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 25.0),
            child: new MaterialButton(
              color: Theme.of(context).accentColor,
              height: 50.0,
              minWidth: 150.0,
              onPressed: () => {vHash()},
              child: new Text(
                "VHash",
                style: _sizeTextWhite,
              ),
            ),
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 55.0),
            child: new MaterialButton(
              color: Theme.of(context).accentColor,
              height: 50.0,
              minWidth: 150.0,
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Text(
                "Go back",
                style: _sizeTextWhite,
              ),
            ),
          ),
        ],
      )),
    );
  }
}

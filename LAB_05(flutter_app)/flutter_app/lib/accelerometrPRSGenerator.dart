import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sensors/sensors.dart';


class AccelerometrPRSGenerator extends StatefulWidget {
  @override
  _AccelerometrPRSGeneratorState createState() => _AccelerometrPRSGeneratorState();
}

class _AccelerometrPRSGeneratorState extends State<AccelerometrPRSGenerator> {
  double x = 0, y = 0, z = 0;

  AccelerometerEvent event;
  AccelerometerEvent prevEvent;

  Timer timer;
  StreamSubscription accel;

  double progressLoader = 0.0;

  var listOf8BitsNumbers = [];

  String resultRandom256bit = '';

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        x = event.x;
        y = event.y;
        z = event.z;
      });
    });
  }


  startTimer() {
    if (timer == null) {
      timer = Timer.periodic(Duration(milliseconds: 200), (_) {
        if (accel == null || accel.isPaused) {
          accel = accelerometerEvents.listen((AccelerometerEvent eve) {
            setState(() {
              event = eve;
            });
          });
        } else {
            if(listOf8BitsNumbers.length == 32) {
              timer.cancel();
             }
          accel.resume();
          _compareEvents(event);
        }
      });
    }
  }

  void _compareEvents(AccelerometerEvent event) {
    if(prevEvent != null) {
      double sumOfCords = event.x + event.y + event.z;
      double prevSumOfCords = prevEvent.x + prevEvent.y + prevEvent.z;

      if(listOf8BitsNumbers.length == 32) {
        accel.pause();
        progressLoader = 100;

        listOf8BitsNumbers.forEach((element) {
          resultRandom256bit+=element;
        });

        print('resultRandom256bit: ' + resultRandom256bit);
        print('listOf8BitsNumbers.length ' + listOf8BitsNumbers.length.toString());
        _showMaterialDialog(resultRandom256bit, entropyFrBinString(resultRandom256bit));
        return;
      }

      if(sumOfCords.abs() > prevSumOfCords.abs() + prevSumOfCords.abs() * 0.5) {
        var factorialPartOfCords = sumOfCords.toString().split('.')[1];

        print(
            "--------------------------------------------------------${'\n'}"
            "sumOfCords X Y Z: ${sumOfCords.abs()} ${'\n'}"
            "factorialPart: ${factorialPartOfCords}  ${'\n'}"
            "dec2bin factorialPart: ${dec2bin(int.parse(factorialPartOfCords))} ${'\n'}"
            "get8LastBits ${get8LastBits(dec2bin(int.parse(factorialPartOfCords)))} ${'\n'}"
            "--------------------------------------------------------"
        );

        listOf8BitsNumbers.add(get8LastBits(dec2bin(int.parse(factorialPartOfCords))));
        progressLoader+=3;
      }
    }

    prevEvent = event;
  }


  String dec2bin(int decimal) {
    String bin = '';
    while (decimal > 0) {
      bin = bin + (decimal % 2).toString();
      decimal = (decimal / 2).floor();
    }
    return bin;
  }

  String get8LastBits(String value) {
    if(value.length < 8) {
      for (int i = 0; value.length < 8; i++) {
        value += '0';
      }
    }
    return value.substring(value.length - 8);
  }

  _showMaterialDialog(String resultRandom256bit, double entropy) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("Material Dialog"),
          content: new Text("resultRandom256bit: " + resultRandom256bit + "\n\n" + "Entropy: " + entropy.toString()),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: Text('Close me!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  double entropyFrBinString (String binaryString) {
    double prob0 = '0'.allMatches(binaryString).length / binaryString.length.toDouble();
    double prob1 = '1'.allMatches(binaryString).length / binaryString.length.toDouble();
    double entropy = -(prob0 * (log(prob0) / log(2)) + prob1 * (log(prob1) / log(2)));
    return entropy;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter Sensor"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder.all(
                      width: 2.0,
                      color: Colors.blueAccent,
                      style: BorderStyle.solid),
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "X Asis : ",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(x.toString(),
                              style: TextStyle(fontSize: 20.0)),
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Y Asis : ",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(y.toString(),
                              style: TextStyle(fontSize: 20.0)),
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Z Asis : ",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(z.toString(),
                              style: TextStyle(fontSize: 20.0)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: startTimer,
                  child: Text('Generate Random 256bit'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 15.0,
                  animation: false,
                  percent: progressLoader/100,
                  center: Text(progressLoader.toString() + "%",style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  footer: Text("Генератор ПСП", style:TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17.0),
                  ), //footer text
                  backgroundColor: Colors.lightGreen[300],
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.redAccent,
                ),
              )
            ],
          ),
        ));
  }
}

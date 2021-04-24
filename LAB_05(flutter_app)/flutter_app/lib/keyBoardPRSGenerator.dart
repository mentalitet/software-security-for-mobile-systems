import 'package:flutter/material.dart';
import 'dart:math';

class KeyBoardPRSGenerator extends StatefulWidget {
  KeyBoardPRSGenerator({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _KeyBoardPRSGeneratorState createState() => _KeyBoardPRSGeneratorState();
}

class _KeyBoardPRSGeneratorState extends State<KeyBoardPRSGenerator> {
  int _counter = 0;
  Stopwatch watchTimer = Stopwatch();
  var millisecondsTimeStamp = [];
  String resultRandom256bit = '';

  final entropyTextEditController = TextEditingController();

  void initState() {
    super.initState();
    entropyTextEditController.addListener(_onChangeEventListener);
  }

  _onChangeEventListener() {
    if(_counter == 0) {
      watchTimer.start();
      debugPrint('watchTimer start');
      _counter++;
      return;
    }

    print('----------------------------------');
    millisecondsTimeStamp.add(watchTimer.elapsedMicroseconds);
    print('value added to collection');
    print('collection: ' + millisecondsTimeStamp.toString());
    print('length:' + millisecondsTimeStamp.length.toString());
    watchTimer.reset();
    print('watchTimer reseated');
    print('----------------------------------');

    if(millisecondsTimeStamp.length == 32) {
      _counter = 0;

      millisecondsTimeStamp.forEach((element) {
        //print('Last 8 bits: ' + get8LastBits(dec2bin(element)));
        resultRandom256bit+=get8LastBits(dec2bin(element));
      });

      _showMaterialDialog(resultRandom256bit, entropyFromBinaryString(resultRandom256bit));
      print('Random256bit:' + resultRandom256bit);
      print ('Entropy:' + entropyFromBinaryString(resultRandom256bit).toString());

      //reset
      entropyTextEditController.clear();
      resultRandom256bit = '';
      millisecondsTimeStamp.clear();
      return;
    }
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

  double entropyFromBinaryString (String binaryString) {
    double zero = '0'.allMatches(binaryString).length / binaryString.length.toDouble();
    double one = '1'.allMatches(binaryString).length / binaryString.length.toDouble();
    double entropy = -(zero * (log(zero) / log(2)) + one * (log(one) / log(2)));
    return entropy;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Введите 33 символа'),
              TextField(
                controller: entropyTextEditController,
                keyboardType: TextInputType.number,
                obscureText: true,
                obscuringCharacter: "*",
                maxLength: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
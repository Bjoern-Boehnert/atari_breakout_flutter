import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

String _text = 'not changed';
bool _pressed = true;
const double _margin = 100;

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        margin: const EdgeInsets.all(_margin),
        child: ElevatedButton(
          onPressed: _buttonPressed,
          child: Center(
            child: Text(_text),
          ),
        ),
      ),
    );
  }

  void _buttonPressed() {
    setState(() {
      if (_pressed) {
        _text = 'changed';
      } else {
        _text = 'not changed';
      }
      _pressed = !_pressed;
    });
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MainMenu(),
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    // Column als Widget für die vertikale Anordnung der Container
    // Container, um die Größe zu berechnen
    // Fitted-Box um den Text auf die Größe des Containers zu erhöhen
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: FittedBox(child: Text('Atari Breakout')),
        ),
        Expanded(
            child: Container(
          child: FittedBox(
              child: ElevatedButton(
                  onPressed: () => _startGame(context, Game()),
                  child: Text('Play Game'))),
        ))
      ],
    );
  }
}

class Game extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: FittedBox(child: Text('Atari Breakout')),
        ),
        Expanded(
            child: Container(
          child: FittedBox(
              child: ElevatedButton(
                  onPressed: () => _startGame(context, MainMenu()),
                  child: Text('Go back'))),
        ))
      ],
    );
  }
}
void _startGame(BuildContext context, StatelessWidget app) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => Scaffold(body: app)));
}
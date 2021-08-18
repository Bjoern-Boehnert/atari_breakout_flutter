import 'package:flutter/material.dart';

import 'game.dart';

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

  void _startGame(BuildContext context, Widget app) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Scaffold(body: app)));
  }
}
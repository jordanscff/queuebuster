import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../rollercoaster_game.dart';
import 'control_panel.dart';

class MyApp extends StatelessWidget {
  final RollercoasterGame game;

  MyApp({required this.game});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            GameWidget(game: game),
            Positioned(
              bottom: 20,
              left: 20,
              child: ControlPanel(game: game),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'rollercoaster_game.dart';
import 'widgets/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setPortrait();

  final game = RollercoasterGame();
  runApp(MyApp(game: game));
}
import 'package:flutter/material.dart';
import '../rollercoaster_game.dart';

enum ButtonType { startStop, load }

class TramControlButton extends StatelessWidget {
  final RollercoasterGame game;
  final ButtonType type;
  final VoidCallback onPressed;

  TramControlButton({required this.game, required this.type, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Color buttonColor;
    IconData iconData;
    String label;

    switch (type) {
      case ButtonType.startStop:
        buttonColor = Colors.orange;
        iconData = Icons.bus_alert_sharp;
        label = 'Start/Stop';
        break;
      case ButtonType.load:
        buttonColor = Colors.blue;
        iconData = Icons.people;
        label = 'Load';
        break;
    }

    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.width * 0.15,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              padding: EdgeInsets.zero,
            ),
            onPressed: () {
              if (type == ButtonType.startStop) {
                onPressed();
              } else if (type == ButtonType.load) {
                if (game.canLoadMorePeeps()) {
                  onPressed();
                }
              }
            },
            child: Icon(iconData, size: MediaQuery.of(context).size.width * 0.08),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
      ],
    );
  }
}
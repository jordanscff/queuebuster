// widgets/control_panel.dart
import 'package:flutter/material.dart';
import '../rollercoaster_game.dart';
import 'tram_control_button.dart';

class ControlPanel extends StatefulWidget {
  final RollercoasterGame game;

  ControlPanel({required this.game});

  @override
  _ControlPanelState createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  @override
  void initState() {
    super.initState();
    widget.game.onGameStateChanged = () {
      if (mounted) {
        setState(() {});
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CONTROL PANEL',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TramControlButton(
                game: widget.game,
                type: ButtonType.startStop,
                onPressed: () {
                  widget.game.toggleTramMovement();
                  setState(() {});
                },
              ),
              TramControlButton(
                game: widget.game,
                type: ButtonType.load,
                onPressed: () {
                  widget.game.loadPeeps();
                  setState(() {});
                },
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            'Next group: ${widget.game.nextGroupSize}',
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
          Text(
            'Peeps on Tram: ${widget.game.peepsOnTram.length}/${RollercoasterGame.maxPeepsPerTram}',
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
          Text(
            'Available seats: ${widget.game.getAvailableSeats()}',
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class RollercoasterGame extends FlameGame {
  late SpriteComponent background;
  late SpriteComponent tram;
  List<SpriteComponent> peeps = [];
  List<SpriteComponent> peepsOnTram = [];
  bool isMoving = true;
  static const int numberOfPeeps = 40;
  static const int maxPeepsPerTram = 12;
  final Random _random = Random();

  double tramSpeed = 60.0;
  double maxSpeed = 75.0;
  double acceleration = 30.0;
  double deceleration = 50.0;
  bool isAccelerating = false;
  bool isDecelerating = false;

  int nextGroupSize = 2;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the background image
    final backgroundSprite = await Sprite.load('road.png');
    background = SpriteComponent()
      ..sprite = backgroundSprite
      ..size = size
      ..position = Vector2.zero();

    add(background);

    // Load the tram sprite
    final tramSprite = await Sprite.load('tram.png');
    tram = SpriteComponent()
      ..sprite = tramSprite
      ..size = Vector2(size.x * 0.18, size.y * 0.4)
      ..position = Vector2(size.x / 2 + size.x * 0.25, size.y - size.y * 0.2);

    add(tram);

    // Load person sprites
    final person1Sprite = await Sprite.load('person1.png');
    final person2Sprite = await Sprite.load('person2.png');
    final person3Sprite = await Sprite.load('person3.png');
    final personSprites = [person1Sprite, person2Sprite, person3Sprite];

    // Add peeps to the queue
    for (int i = 0; i < numberOfPeeps; i++) {
      final randomSprite = personSprites[_random.nextInt(personSprites.length)];
      final peep = SpriteComponent(
        sprite: randomSprite,
        size: Vector2(size.x * 0.10, size.y * 0.1),
        position: _getPeepPosition(i),
        anchor: Anchor.center,
      );
      peep.angle = pi;
      peeps.add(peep);
      add(peep);
    }

  }

  Vector2 _getPeepPosition(int index) {
    final queueStartX = size.x * 0.58;
    final queueStartY = size.y - size.y * 0.57;
    const double spacingX = 15;
    const double spacingY = 50;
    const int peepsPerRow = 1;

    final row = index ~/ peepsPerRow;
    final column = index % peepsPerRow;

    return Vector2(
        queueStartX + column * spacingX,
        queueStartY - row * spacingY
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isMoving) {
      if (isAccelerating) {
        tramSpeed = min(maxSpeed, tramSpeed + acceleration * dt);
        if (tramSpeed == maxSpeed) {
          isAccelerating = false;
        }
      } else if (isDecelerating) {
        tramSpeed = max(0, tramSpeed - deceleration * dt);
        if (tramSpeed == 0) {
          isMoving = false;
          isDecelerating = false;
        }
      }
      // Move the tram using the current speed
      tram.position.y -= tramSpeed * dt;
      if (tram.position.y + tram.size.y < 0) {
        resetTram();
      }
    }
  }

  Function()? onGameStateChanged;

  void resetTram() {
    tram.position.y = size.y;
    // Clear peeps from the tram
    for (var peep in peepsOnTram) {
      if (peep.parent != null) {
        peep.removeFromParent();
      }
    }
    peepsOnTram.clear();
    onGameStateChanged?.call();
  }

  void toggleTramMovement() {
    if (isMoving) {
      isDecelerating = true;
      isAccelerating = false;
    } else {
      isMoving = true;
      isAccelerating = true;
      isDecelerating = false;
    }
  }

  void generateNextGroupSize() {
    int remainingPeeps = peeps.length;
    if (remainingPeeps == 0) {
      nextGroupSize = 0;
      return;
    }

    final roll = _random.nextDouble();
    if (roll < 0.7) {
      // 70% chance for group size 1-5
      nextGroupSize = _random.nextInt(5) + 1;
    } else {
      // 30% chance for group size 6-12
      nextGroupSize = _random.nextInt(7) + 6;
    }

    // Ensure the next group size doesn't exceed the remaining peeps
    nextGroupSize = min(nextGroupSize, remainingPeeps);
  }

  bool canLoadMorePeeps() {
    return getAvailableSeats() > 0 && peeps.isNotEmpty && nextGroupSize <= getAvailableSeats();
  }

  int getAvailableSeats() {
    return maxPeepsPerTram - peepsOnTram.length;
  }

  void loadPeeps() {
    if (isMoving || !canLoadMorePeeps()) return;

    int availableSeats = getAvailableSeats();
    int peepsToLoad = min(nextGroupSize, availableSeats);
    peepsToLoad = min(peepsToLoad, peeps.length);

    for (int i = 0; i < peepsToLoad; i++) {
      if (peeps.isNotEmpty) {
        SpriteComponent peep = peeps.removeAt(0);
        peepsOnTram.add(peep);
        remove(peep);
      }
    }

    animateQueueMovement();
    generateNextGroupSize();

    onGameStateChanged?.call();
  }

  void animateQueueMovement() {
    for (int i = 0; i < peeps.length; i++) {
      Vector2 newPosition = _getPeepPosition(i);
      peeps[i].add(
        MoveEffect.to(
          newPosition,
          EffectController(duration: 0.5),
        ),
      );
    }
  }
}
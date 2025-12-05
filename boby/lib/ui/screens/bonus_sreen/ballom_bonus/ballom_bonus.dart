import 'package:boby/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'wigdets/ballon_painter.dart';

class Balloon {
  final double size;
  final int colorIndex;
  final String id; // ID único para cada globo
  double x;
  double y;
  double speed;
  bool isPopped;
  double rotation;
  double xSpeed;

  Balloon({
    required this.size,
    required this.colorIndex,
    required this.id,
    required this.x,
    required this.y,
    required this.speed,
    this.isPopped = false,
  }) : rotation = 0,
       xSpeed = (math.Random().nextDouble() - 0.5) * 0.5;

  void update() {
    if (!isPopped) {
      // Movimiento hacia arriba (y aumenta)
      y += speed; // Movimiento hacia arriba
      x += xSpeed;

      // Mantener dentro de los límites de la pantalla (considerando el tamaño del globo)
      if (x < 0.15) x = 0.15; // Margen izquierdo para que no se corte
      if (x > 0.85) x = 0.85; // Margen derecho para que no se corte

      // Movimiento horizontal más suave
      xSpeed = xSpeed * 0.99 + (math.Random().nextDouble() - 0.5) * 0.0005;

      // Limitar la velocidad horizontal
      if (xSpeed > 0.0005) xSpeed = 0.0005;
      if (xSpeed < -0.0005) xSpeed = -0.0005;

      // Si el globo sale por arriba, lo reiniciamos abajo
      if (y > 1.2) {
        y =
            -0.3 -
            math.Random().nextDouble() *
                0.1; // Aparece completamente fuera de la pantalla por abajo
        x =
            0.15 +
            math.Random().nextDouble() *
                0.7; // Distribución entre 0.15 y 0.85 (con márgenes más amplios)
      }
    }
  }
}

class BallomScreenBonus extends StatefulWidget {
  const BallomScreenBonus({super.key});

  @override
  State<BallomScreenBonus> createState() => _BallomScreenBonusState();
}

class _BallomScreenBonusState extends State<BallomScreenBonus>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Balloon> _balloons = [];
  final int _maxBalloons = 6;
  final math.Random _random = math.Random();
  int _balloonIdCounter = 0; // Contador para IDs únicos

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 16),
          )
          ..addListener(() {
            // Check and maintain 6 balloons
            if (_balloons.length < _maxBalloons) {
              _addBalloon();
            }
            // No need for setState here - AnimatedBuilder handles rebuilds
          })
          ..repeat();

    // Add initial balloons
    for (int i = 0; i < _maxBalloons; i++) {
      _addBalloon();
    }
  }

  void _addBalloon() {
    if (_balloons.length < _maxBalloons) {
      // Add a small delay between balloon creation
      Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1500)), () {
        if (mounted && _balloons.length < _maxBalloons) {
          _balloons.add(
            Balloon(
              size: 50.0 + _random.nextDouble() * 50.0,
              colorIndex: _random.nextInt(4), // 4 colores disponibles
              id: 'balloon_${_balloonIdCounter++}', // ID único
              x:
                  0.15 +
                  _random.nextDouble() *
                      0.7, // Distribución entre 0.15 y 0.85 (con márgenes más amplios)
              y:
                  -0.3 -
                  _random.nextDouble() *
                      0.1, // Comenzar completamente fuera de la pantalla por abajo
              speed:
                  0.001 +
                  _random.nextDouble() *
                      0.002, // Velocidad reducida para flotación suave
            ),
          );
          // AnimatedBuilder will handle the rebuild automatically
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _popBalloon(int index) {
    if (index < 0 || index >= _balloons.length) return;

    final balloon = _balloons[index];
    if (balloon.isPopped) return;

    // Reproducir sonido de explosión
    final appController = Get.find<AppController>();
    appController.playMenuSound("assets/sounds/ballon_pop.wav");

    // Marcar como reventado
    balloon.isPopped = true;

    // Remover el globo inmediatamente y agregar uno nuevo
    _balloons.removeAt(index);

    // Agregar un nuevo globo con un pequeño delay
    if (_balloons.length < _maxBalloons) {
      _addBalloon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Update balloon positions
        for (var balloon in _balloons) {
          balloon.update();
        }

        return Stack(
          children: _balloons.asMap().entries.map((entry) {
            final index = entry.key;
            final balloon = entry.value;

            return Positioned(
              key: ValueKey(balloon.id), // Key única para cada globo
              left:
                  MediaQuery.of(context).size.width * balloon.x -
                  balloon.size / 2,
              bottom: MediaQuery.of(context).size.height * balloon.y,
              child: GestureDetector(
                onTap: () => _popBalloon(index),
                child: BalloonWidget(colorIndex: balloon.colorIndex),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

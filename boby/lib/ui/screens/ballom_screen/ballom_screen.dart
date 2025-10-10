import 'package:flutter/material.dart';
import 'dart:math' as math;
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
      if (x < 0.1) x = 0.1; // Margen izquierdo para que no se corte
      if (x > 0.9) x = 0.9; // Margen derecho para que no se corte

      // Movimiento horizontal más suave
      xSpeed = xSpeed * 0.99 + (math.Random().nextDouble() - 0.5) * 0.0005;

      // Limitar la velocidad horizontal
      if (xSpeed > 0.0005) xSpeed = 0.0005;
      if (xSpeed < -0.0005) xSpeed = -0.0005;

      // Si el globo sale por arriba, lo reiniciamos abajo
      if (y > 1.2) {
        y = -0.3 - math.Random().nextDouble() * 0.1; // Aparece completamente fuera de la pantalla por abajo
        x = 0.1 + math.Random().nextDouble() * 0.8; // Distribución entre 0.1 y 0.9 (con márgenes)
      }
    }
  }
}

class BallomScreen extends StatefulWidget {
  const BallomScreen({super.key});

  @override
  State<BallomScreen> createState() => _BallomScreenState();
}

class _BallomScreenState extends State<BallomScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Balloon> _balloons = [];
  final int _maxBalloons = 4;
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
            // Check and maintain 4 balloons
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
              x: 0.1 + _random.nextDouble() * 0.8, // Distribución entre 0.1 y 0.9 (con márgenes)
              y: -0.3 - _random.nextDouble() * 0.1, // Comenzar completamente fuera de la pantalla por abajo
              speed: 0.001 + _random.nextDouble() * 0.002, // Velocidad reducida para flotación suave
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
    
    // Marcar como reventado (esto hará que se oculte en el siguiente frame del AnimatedBuilder)
    balloon.isPopped = true;
    
    // Remover el globo de la lista y agregar uno nuevo después de un breve delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        final balloonIndex = _balloons.indexWhere((b) => b == balloon);
        if (balloonIndex != -1) {
          // Remover el globo explotado
          _balloons.removeAt(balloonIndex);
        }
        // Agregar un nuevo globo si no hay suficientes
        if (_balloons.length < _maxBalloons) {
          _addBalloon();
        }
      }
    });
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
          children: _balloons.map((balloon) {
            if (balloon.isPopped) return const SizedBox.shrink();

            return Positioned(
              key: ValueKey(balloon.id), // Key única para cada globo
              left:
                  MediaQuery.of(context).size.width * balloon.x -
                  balloon.size / 2,
              bottom: MediaQuery.of(context).size.height * balloon.y,
              child: GestureDetector(
                onTap: () => _popBalloon(_balloons.indexOf(balloon)),
                child: BalloonWidget(
                  colorIndex: balloon.colorIndex,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

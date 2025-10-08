import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'wigdets/ballon_painter.dart';

class Balloon {
  final Color color;
  final double size;
  double x;
  double y;
  double speed;
  bool isPopped;
  double rotation;
  double xSpeed;

  Balloon({
    required this.color,
    required this.size,
    required this.x,
    required this.y,
    required this.speed,
    this.isPopped = false,
  }) : rotation = 0,
       xSpeed = (math.Random().nextDouble() - 0.5) * 0.5;

  void update() {
    if (!isPopped) {
      // Movimiento hacia arriba (y disminuye)
      y -= speed; // Movimiento hacia arriba
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
      if (y < -0.2) {
        y = 1.0 + math.Random().nextDouble() * 0.2; // Aparece en la parte inferior con variación
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
            setState(() {}); // Trigger rebuild for animation
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
          setState(() {
            _balloons.add(
              Balloon(
                color:
                    Colors.primaries[_random.nextInt(Colors.primaries.length)],
                size: 50.0 + _random.nextDouble() * 50.0,
                x: 0.1 + _random.nextDouble() * 0.8, // Distribución entre 0.1 y 0.9 (con márgenes)
                y: 1.0 + _random.nextDouble() * 0.2, // Comenzar desde abajo con variación
                speed: 0.001 + _random.nextDouble() * 0.002, // Velocidad reducida para flotación suave
              ),
            );
          });
        }
      });
    }
  }

  // Mapa para rastrear los controladores de animación
  final Map<int, AnimationController> _animationControllers = {};
  int _animationCounter = 0;

  @override
  void dispose() {
    _controller.dispose();
    // Eliminar todos los controladores de animación
    for (var controller in _animationControllers.values) {
      controller.dispose();
    }
    _animationControllers.clear();
    super.dispose();
  }

  void _popBalloon(int index) {
    if (index < 0 || index >= _balloons.length) return;
    
    final balloon = _balloons[index];
    if (balloon.isPopped) return;
    
    // Marcar como reventado sin reconstruir toda la interfaz
    balloon.isPopped = true;
    
    // Crear un ID único para esta animación
    final animationId = _animationCounter++;
    
    // Iniciar animación de desvanecimiento
    final animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (mounted) {
            setState(() {
              final index = _balloons.indexWhere((b) => b == balloon);
              if (index != -1) {
                _balloons.removeAt(index);
                _addBalloon();
              }
              // Eliminar el controlador cuando ya no se necesite
              _animationControllers.remove(animationId)?.dispose();
            });
          } else {
            _animationControllers.remove(animationId)?.dispose();
          }
        }
      });
    
    // Guardar el controlador
    _animationControllers[animationId] = animationController;
    
    // Iniciar la animación
    animationController.forward();
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
          children: List.generate(_balloons.length, (index) {
            final balloon = _balloons[index];
            if (balloon.isPopped) return const SizedBox.shrink();

            return Positioned(
              left:
                  MediaQuery.of(context).size.width * balloon.x -
                  balloon.size / 2,
              bottom: MediaQuery.of(context).size.height * balloon.y,
              child: GestureDetector(
                onTap: () => _popBalloon(index),
                child: balloon.isPopped 
                  ? const SizedBox.shrink()
                  : BalloonWidget(
                      color: balloon.color,
                      sizePx: balloon.size,
                    ),
              ),
            );
          }),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:math';
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
  })  : rotation = 0,
        xSpeed = (math.Random().nextDouble() - 0.5) * 0.5;

  void update() {
    if (!isPopped) {
      // Movimiento hacia arriba (y disminuye)
      y -= speed / 3; // Reducir la velocidad a 1/3
      x += xSpeed;
      
      // Mantener dentro de los límites de la pantalla
      if (x < 0.1) x = 0.1;
      if (x > 0.9) x = 0.9;
      
      // Movimiento horizontal más suave
      xSpeed = xSpeed * 0.99 + (math.Random().nextDouble() - 0.5) * 0.0005;
      
      // Limitar la velocidad horizontal
      if (xSpeed > 0.0005) xSpeed = 0.0005;
      if (xSpeed < -0.0005) xSpeed = -0.0005;
    }
  }
}

class BallomScreen extends StatefulWidget {
  const BallomScreen({super.key});

  @override
  State<BallomScreen> createState() => _BallomScreenState();
}

class _BallomScreenState extends State<BallomScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Balloon> _balloons = [];
  final int _maxBalloons = 4;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(() {
      // Check and maintain 4 balloons
      if (_balloons.length < _maxBalloons) {
        _addBalloon();
      }
      setState(() {}); // Trigger rebuild for animation
    })..repeat();

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
            _balloons.add(Balloon(
              color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
              size: 50.0 + _random.nextDouble() * 50.0,
              x: 0.1 + _random.nextDouble() * 0.8, // Random x position (10% to 90% of screen width)
              y: -0.2 - _random.nextDouble() * 0.2, // Comenzar desde arriba con variación
              speed: 0.002 + _random.nextDouble() * 0.003, // Velocidad reducida a 1/3
            ));
          });
        }
      });
    }
  }

  void _popBalloon(int index) {
    setState(() {
      _balloons[index].isPopped = true;
    });
    
    // Remove the balloon after animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _balloons.removeAt(index);
          _addBalloon();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF87CEEB), Color(0xFF1E90FF)],
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Update balloon positions
            for (var balloon in _balloons) {
              balloon.update();
              
              // Si el globo sale por arriba, lo reiniciamos abajo
              if (balloon.y < -0.2) {
                balloon.y = 1.0 + _random.nextDouble() * 0.2;
                balloon.x = 0.1 + _random.nextDouble() * 0.8;
              }
            }
            
            return Stack(
              children: List.generate(_balloons.length, (index) {
                final balloon = _balloons[index];
                if (balloon.isPopped) return const SizedBox.shrink();
                
                return Positioned(
                  left: MediaQuery.of(context).size.width * balloon.x - balloon.size / 2,
                  bottom: MediaQuery.of(context).size.height * balloon.y,
                  child: GestureDetector(
                    onTap: () => _popBalloon(index),
                    child: BalloonWidget(
                      color: balloon.color,
                      sizePx: balloon.size,
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
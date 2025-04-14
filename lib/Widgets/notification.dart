import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class notifications extends StatefulWidget {
  const notifications({super.key});

  @override
  State<notifications> createState() => _notificationsState();
}

class _NotificationsState extends State<notifications> {
  double _rotationX = 0.0; // Minimal state for rotation
  double _rotationY = 0.0; // Minimal state for rotation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.red.withOpacity(0.8),
            boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
          ),
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                _rotationY += details.delta.dx * 0.01; 
                _rotationX -= details.delta.dy * 0.01;
              });
            },
            child: Cube(
              onSceneCreated: (Scene scene) {
                try {
                  final object = Object(
                    fileName: 'lib/assets/Earth/NOVELO_EARTH.obj',
                    lighting: false,
                  );
                  scene.world.add(object);
                  scene.camera.zoom = 40; 
                  object.rotation.x = _rotationX; 
                  object.rotation.y = _rotationY;
                } catch (e) {
                  debugPrint('Error loading OBJ: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to load 3D model: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
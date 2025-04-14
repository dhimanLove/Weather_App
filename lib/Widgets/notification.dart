import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
    _rotateModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Cube(
        onSceneCreated: (Scene scene) {
          try {
            final object = Object(
              fileName: 'lib/assets/Earth/NOVELO_EARTH.obj',
              lighting: false,
              backfaceCulling: true,
              isAsset: true,
              scale: Vector3(1.0, 1.0, 1.0),
            );
            scene.world.add(object);
            scene.camera.zoom = 10;
            final camera = Camera(
              position: Vector3(0.0, 0.0, 10.0),
            );
          } catch (e) {
            debugPrint('Error loading OBJ: $e');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to load 3D model'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _rotateModel() {
    Future.doWhile(() async {
      if (!mounted) return false;
      setState(() {
        if (scene != null && object != null) {
          object!.rotation.y += 0.1;
          scene!.update();
        }
      });
      await Future.delayed(const Duration(milliseconds: 50));
      return true;
    });
  }

  Scene? scene;
  Object? object;

  @override
  void dispose() {
    scene = null;
    object = null;
    super.dispose();
  }
}
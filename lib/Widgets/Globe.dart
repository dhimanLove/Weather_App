import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;
import 'package:flutter/services.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> with SingleTickerProviderStateMixin {
  Scene? scene;
  Object? globeObject;
  double rotationSpeed = 1.0;
  bool isRotating = true;
  double _sensitivity = 0.03;
  bool _isLoading = true;
  bool _isError = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final double _zoomSensitivity = 200.0;
  double _previousScale = 1.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startRotation();
    });
    _animationController.forward();
  }

  void startRotation() {
    debugPrint('Starting rotation: isRotating=$isRotating, speed=$rotationSpeed');
    if (isRotating && mounted) {
      WidgetsBinding.instance.addPersistentFrameCallback((_) {
        if (!mounted || !isRotating || scene == null || globeObject == null) return;
        setState(() {
          globeObject!.rotation.y += rotationSpeed * 0.1;
          globeObject!.rotation.y %= 360.0;
          scene!.update();
        });
      });
    }
  }

  void toggleRotation() {
    HapticFeedback.lightImpact();
    setState(() {
      isRotating = !isRotating;
      debugPrint('Toggled rotation: isRotating=$isRotating');
      if (isRotating) {
        startRotation();
      }
    });
  }

  void updateRotationSpeed(double value) {
    HapticFeedback.selectionClick();
    setState(() {
      rotationSpeed = value.clamp(0.0, 3.0);
      debugPrint('Updated rotation speed: $rotationSpeed');
    });
  }

  void updateSensitivity(double value) {
    HapticFeedback.selectionClick();
    setState(() {
      _sensitivity = value.clamp(0.01, 0.1);
      debugPrint('Updated sensitivity: $_sensitivity');
    });
  }

  void resetView() {
    HapticFeedback.mediumImpact();
    if (scene != null && globeObject != null) {
      setState(() {
        globeObject!.rotation.setFrom(vmath.Vector3(0, 0, 0));
        scene!.camera.zoom = 10;
        scene!.camera.position.setFrom(vmath.Vector3(0, 0, 10));
        scene!.camera.target.setFrom(vmath.Vector3(0, 0, 0));
        scene!.update();
        debugPrint('View reset');
      });
    }
  }

  void zoomIn() {
    HapticFeedback.lightImpact();
    if (scene != null) {
      setState(() {
        scene!.camera.zoom = (scene!.camera.zoom + 0.5).clamp(5.0, 15.0);
        scene!.update();
        debugPrint('Zoom in: ${scene!.camera.zoom}');
      });
    }
  }

  void zoomOut() {
    HapticFeedback.lightImpact();
    if (scene != null) {
      setState(() {
        scene!.camera.zoom = (scene!.camera.zoom - 0.5).clamp(5.0, 15.0);
        scene!.update();
        debugPrint('Zoom out: ${scene!.camera.zoom}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFF2A3B5A), Color(0xFF0A101F)],
                center: Alignment.center,
                radius: 1.5,
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              child: GestureDetector(
                onDoubleTap: resetView,
                onScaleStart: (details) {
                  _previousScale = 1.0;
                },
                onScaleUpdate: (ScaleUpdateDetails details) {
                  if (scene != null && globeObject != null) {
                    setState(() {
                      final dx = details.focalPointDelta.dx.clamp(-20.0, 20.0);
                      final dy = details.focalPointDelta.dy.clamp(-20.0, 20.0);
                      globeObject!.rotation.y += dx * _sensitivity;
                      globeObject!.rotation.x += dy * _sensitivity;
                      globeObject!.rotation.y %= 360.0;
                      globeObject!.rotation.x %= 360.0;


                      final scaleChange = details.scale - _previousScale;
                      scene!.camera.zoom =
                          (scene!.camera.zoom + scaleChange * _zoomSensitivity).clamp(5.0, 15.0);
                      scene!.update();

                      _previousScale = details.scale; // store
                      debugPrint('Gesture: dx=$dx, dy=$dy, zoom=${scene!.camera.zoom}, sensitivity=$_sensitivity, scale=${details.scale}');
                    });
                  }
                },
                child: Stack(
                  children: [
                    Cube(
                      onSceneCreated: (Scene createdScene) async {
                        setState(() {
                          _isLoading = true;
                          _isError = false;
                        });
                        try {
                          scene = createdScene;

                          try {
                            globeObject = Object(
                              fileName: 'lib/assets/Low Poly Pokeball/model.obj',
                              backfaceCulling: true,
                              isAsset: true,
                              scale: vmath.Vector3(1.5, 1.5, 1.5),
                            );
                          } catch (e) {
                            debugPrint('Pokeball failed to load: $e');
                            globeObject = Object(
                              name: 'cube',
                              scale: vmath.Vector3(2.0, 2.0, 2.0),
                            );
                          }
                          scene!.world.add(globeObject!);
                          scene!.camera.zoom = 10;
                          scene!.camera.position.setFrom(vmath.Vector3(0, 0, 10));
                          scene!.camera.target.setFrom(vmath.Vector3(0, 0, 0));
                          scene!.light.position.setFrom(vmath.Vector3(5, 5, 5));
                          scene!.update();
                          setState(() {
                            _isLoading = false;
                          });
                          debugPrint('Scene created successfully: ${globeObject!.name}');
                        } catch (e) {
                          debugPrint('Error initializing scene: $e');
                          setState(() {
                            _isLoading = false;
                            _isError = true;
                          });
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Failed to load 3D model'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                                action: SnackBarAction(
                                  label: 'Retry',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    setState(() {});
                                  },
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(color: Colors.blueAccent),
                      ),
                    if (_isError && !_isLoading)
                      const Center(
                        child: Text(
                          'Error loading model',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pokeball Explorer',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                          semanticsLabel: 'Pokeball Explorer Title',
                        ),
                        Tooltip(
                          message: 'About this app',
                          child: IconButton(
                            icon: const Icon(Icons.info_outline, color: Colors.white70),
                            onPressed: () {
                              showAboutDialog(
                                context: context,
                                applicationName: 'Pokeball Explorer',
                                applicationVersion: '1.0.0',
                                applicationIcon: const Icon(Icons.public, color: Colors.blueAccent),
                                children: const [
                                  Text(
                                    'Interact with a 3D Pokeball model. Control rotation, zoom, speed, and sensitivity with intuitive gestures and sliders.',
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Controls',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          semanticsLabel: 'Controls Section',
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Auto Rotate',
                              style: TextStyle(fontSize: 16, color: Colors.white70),
                            ),
                            Tooltip(
                              message: 'Toggle automatic rotation',
                              child: Switch(
                                value: isRotating,
                                onChanged: (value) => toggleRotation(),
                                activeColor: Colors.blueAccent,
                                activeTrackColor: Colors.blueAccent.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Rotation Speed',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        Slider(
                          value: rotationSpeed,
                          min: 0.0,
                          max: 3.0,
                          divisions: 30,
                          label: rotationSpeed.toStringAsFixed(1),
                          onChanged: (value) => updateRotationSpeed(value),
                          activeColor: Colors.blueAccent,
                          inactiveColor: Colors.white.withOpacity(0.3),
                          semanticFormatterCallback: (double value) => 'Rotation speed: ${value.toStringAsFixed(1)}',
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Touch Sensitivity',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                        Slider(
                          value: _sensitivity,
                          min: 0.01,
                          max: 0.1,
                          divisions: 90,
                          label: _sensitivity.toStringAsFixed(2),
                          onChanged: (value) => updateSensitivity(value),
                          activeColor: Colors.blueAccent,
                          inactiveColor: Colors.white.withOpacity(0.3),
                          semanticFormatterCallback: (double value) => 'Sensitivity: ${value.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: resetView,
                            icon: const Icon(Icons.refresh, size: 20),
                            label: const Text('Reset View'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              elevation: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.35,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.zoom_in, color: Colors.white70),
                    tooltip: 'Zoom In',
                    onPressed: zoomIn,
                  ),
                  Container(
                    width: 2,
                    height: 20,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  IconButton(
                    icon: const Icon(Icons.zoom_out, color: Colors.white70),
                    tooltip: 'Zoom Out',
                    onPressed: zoomOut,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    scene = null;
    globeObject = null;
    super.dispose();
  }
}

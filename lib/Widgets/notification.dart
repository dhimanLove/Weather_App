import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
import 'dart:async';
import 'dart:math';

class GlobeExplorer extends StatefulWidget {
  const GlobeExplorer({super.key});

  @override
  State<GlobeExplorer> createState() => _GlobeExplorerState();
}

class _GlobeExplorerState extends State<GlobeExplorer> with TickerProviderStateMixin {
  Scene? scene;
  Object? globeObject;
  double rotationSpeed = 0.1;
  bool isAutoRotating = true;
  double touchSensitivity = 0.005;
  List<double>? gyroscopeValues;
  bool isGyroscopeEnabled = false;
  bool isModelInfoVisible = false;
  bool isLoading = true;
  double lightAngle = pi / 4;
  StreamSubscription<GyroscopeEvent>? gyroscopeSubscription;
  late AnimationController zoomAnimationController;
  late Animation<double> zoomAnimation;
  Timer? autoRotationTimer;

  @override
  void initState() {
    super.initState();
    zoomAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    zoomAnimation = Tween<double>(begin: 10.0, end: 10.0).animate(
      CurvedAnimation(parent: zoomAnimationController, curve: Curves.easeInOut),
    );
    startAutoRotation();
    checkAndStartGyroscope();
  }

  @override
  void dispose() {
    stopGyroscopeListening();
    autoRotationTimer?.cancel();
    zoomAnimationController.dispose();
    scene = null;
    globeObject = null;
    super.dispose();
  }

  void startAutoRotation() {
    autoRotationTimer?.cancel();
    if (isAutoRotating && !isGyroscopeEnabled && mounted) {
      autoRotationTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
        if (!mounted || !isAutoRotating || isGyroscopeEnabled || scene == null || globeObject == null) {
          timer.cancel();
          return;
        }
        setState(() {
          globeObject!.rotation.y += rotationSpeed * 0.016;
          scene!.update();
        });
      });
    }
  }

  void toggleAutoRotation(bool value) {
    setState(() {
      isAutoRotating = value;
      if (isAutoRotating) {
        startAutoRotation();
      } else {
        autoRotationTimer?.cancel();
      }
    });
    triggerHapticFeedback();
    debugPrint('Auto Rotate: $isAutoRotating');
  }

  void toggleGyroscope(bool value) {
    setState(() {
      isGyroscopeEnabled = value;
      if (isGyroscopeEnabled) {
        isAutoRotating = false;
        autoRotationTimer?.cancel();
        startGyroscopeListening();
      } else {
        stopGyroscopeListening();
        isAutoRotating = true;
        startAutoRotation();
      }
    });
    triggerHapticFeedback();
    debugPrint('Gyroscope Enabled: $isGyroscopeEnabled');
  }

  void toggleModelInfo(bool value) {
    setState(() {
      isModelInfoVisible = value;
    });
    triggerHapticFeedback();
    debugPrint('Model Info Visible: $isModelInfoVisible');
  }

  Future<void> checkAndStartGyroscope() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      startGyroscopeListening();
      return;
    }
    final status = await Permission.sensors.status;
    if (status.isGranted) {
      startGyroscopeListening();
    } else if (status.isDenied) {
      final newStatus = await Permission.sensors.request();
      if (newStatus.isGranted) {
        startGyroscopeListening();
      } else {
        showPermissionSnackBar('Gyroscope permission denied.');
      }
    } else if (status.isPermanentlyDenied) {
      showPermissionSnackBar(
        'Gyroscope permission permanently denied. Please enable it in app settings.',
        actionLabel: 'Settings',
        action: () async => await openAppSettings(),
      );
      setState(() => isGyroscopeEnabled = false);
    }
  }

  void startGyroscopeListening() {
    gyroscopeSubscription?.cancel();
    gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      if (isGyroscopeEnabled && mounted && scene != null && globeObject != null) {
        setState(() {
          gyroscopeValues = [event.x, event.y, event.z];
          globeObject!.rotation.y += event.y * touchSensitivity * 0.016;
          globeObject!.rotation.x += event.x * touchSensitivity * 0.016;
          scene!.update();
        });
        debugPrint('Gyroscope Values: $gyroscopeValues');
      }
    }, onError: (error) {
      showPermissionSnackBar('Gyroscope error: $error');
    });
  }

  void stopGyroscopeListening() {
    gyroscopeSubscription?.cancel();
    gyroscopeSubscription = null;
    setState(() {
      gyroscopeValues = null;
    });
  }

  void updateRotationSpeed(double value) {
    setState(() {
      rotationSpeed = value.clamp(0.0, 0.5);
    });
    debugPrint('Rotation Speed: $rotationSpeed');
  }

  void updateTouchSensitivity(double value) {
    setState(() {
      touchSensitivity = value.clamp(0.001, 0.01);
    });
    debugPrint('Touch Sensitivity: $touchSensitivity');
  }

  void updateLightAngle(double value) {
    setState(() {
      lightAngle = value;
      if (scene != null) {
        scene!.light.position.setFrom(vmath.Vector3(
          5 * cos(lightAngle),
          5 * sin(lightAngle),
          5,
        ));
        scene!.update();
      }
    });
    debugPrint('Light Angle: $lightAngle');
  }

  void resetView() {
    if (scene != null && globeObject != null) {
      setState(() {
        globeObject!.rotation.setFrom(vmath.Vector3(0, 0, 0));
        zoomAnimationController.reset();
        zoomAnimation = Tween<double>(begin: scene!.camera.zoom, end: 10.0).animate(
          CurvedAnimation(parent: zoomAnimationController, curve: Curves.easeInOut),
        );
        zoomAnimationController.forward();
        scene!.camera.zoom = 10;
        scene!.camera.position.setFrom(vmath.Vector3(0, 0, 10));
        scene!.camera.target.setFrom(vmath.Vector3(0, 0, 0));
        scene!.light.position.setFrom(vmath.Vector3(5, 5, 5));
        lightAngle = pi / 4;
        scene!.update();
      });
      triggerHapticFeedback();
      debugPrint('View Reset');
    }
  }

  void zoomIn() {
    if (scene != null) {
      setState(() {
        final newZoom = (scene!.camera.zoom + 1).clamp(5.0, 15.0);
        zoomAnimation = Tween<double>(begin: scene!.camera.zoom, end: newZoom).animate(
          CurvedAnimation(parent: zoomAnimationController, curve: Curves.easeInOut),
        );
        zoomAnimationController.reset();
        zoomAnimationController.forward();
        scene!.camera.zoom = newZoom;
        scene!.update();
      });
      triggerHapticFeedback();
      debugPrint('Zoom In: ${scene!.camera.zoom}');
    }
  }

  void zoomOut() {
    if (scene != null) {
      setState(() {
        final newZoom = (scene!.camera.zoom - 1).clamp(5.0, 15.0);
        zoomAnimation = Tween<double>(begin: scene!.camera.zoom, end: newZoom).animate(
          CurvedAnimation(parent: zoomAnimationController, curve: Curves.easeInOut),
        );
        zoomAnimationController.reset();
        zoomAnimationController.forward();
        scene!.camera.zoom = newZoom;
        scene!.update();
      });
      triggerHapticFeedback();
      debugPrint('Zoom Out: ${scene!.camera.zoom}');
    }
  }

  void triggerHapticFeedback() {
    if (Platform.isAndroid || Platform.isIOS) {
      HapticFeedback.lightImpact();
    }
  }

  void showPermissionSnackBar(String message, {String? actionLabel, VoidCallback? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: actionLabel != null && action != null
            ? SnackBarAction(label: actionLabel, onPressed: action)
            : null,
      ),
    );
  }

  String get gyroscopeReading {
    if (gyroscopeValues == null) return 'No Reading';
    return gyroscopeValues!.map((v) => v.toStringAsFixed(3)).join(', ');
  }

  String get modelInfo {
    if (globeObject == null || scene == null) return 'Loading...';
    return 'Rotation: (${globeObject!.rotation.x.toStringAsFixed(2)}, '
        '${globeObject!.rotation.y.toStringAsFixed(2)}, '
        '${globeObject!.rotation.z.toStringAsFixed(2)})\n'
        'Zoom: ${scene!.camera.zoom.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background with starry effect
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFF0F1626), Color(0xFF000000)],
                center: Alignment.center,
                radius: 1.5,
              ),
            ),
            child: Stack(
              children: List.generate(50, (index) => Positioned(
                left: (index * 37 % MediaQuery.of(context).size.width),
                top: (index * 53 % MediaQuery.of(context).size.height),
                child: Container(
                  width: 2,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              )),
            ),
          ),
          // 3D Globe
          Align(
            alignment: Alignment.center,
            child: AnimatedBuilder(
              animation: zoomAnimationController,
              builder: (context, child) {
                if (scene != null) {
                  scene!.camera.zoom = zoomAnimation.value;
                  scene!.update();
                }
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.width * 0.8,
                  child: GestureDetector(
                    onScaleStart: (details) {
                      if (isAutoRotating) {
                        toggleAutoRotation(false);
                      }
                    },
                    onScaleUpdate: (details) {
                      if (scene != null && globeObject != null && !isGyroscopeEnabled) {
                        setState(() {
                          globeObject!.rotation.y += details.focalPointDelta.dx * touchSensitivity;
                          globeObject!.rotation.x += details.focalPointDelta.dy * touchSensitivity;
                          final newZoom = (scene!.camera.zoom * details.scale).clamp(5.0, 15.0);
                          zoomAnimation = Tween<double>(
                            begin: scene!.camera.zoom,
                            end: newZoom,
                          ).animate(CurvedAnimation(
                            parent: zoomAnimationController,
                            curve: Curves.easeInOut,
                          ));
                          zoomAnimationController.reset();
                          zoomAnimationController.forward();
                          scene!.camera.zoom = newZoom;
                          scene!.update();
                        });
                        debugPrint('Gesture - Rotation: (${globeObject!.rotation.x}, ${globeObject!.rotation.y}), Zoom: ${scene!.camera.zoom}');
                      }
                    },
                    onTap: () => toggleModelInfo(true),
                    child: Stack(
                      children: [
                        Cube(
                          key: UniqueKey(),
                          onSceneCreated: (createdScene) {
                            setState(() {
                              scene = createdScene;
                              globeObject = Object(
                                fileName: 'assets/Earth/NOVELO_EARTH.obj',
                                backfaceCulling: true,
                                isAsset: true,
                                scale: vmath.Vector3(1.6, 1.6, 1.6),
                              );
                              try {
                                scene!.world.add(globeObject!);
                                scene!.camera.zoom = 10;
                                scene!.camera.position.setFrom(vmath.Vector3(0, 0, 10));
                                scene!.camera.target.setFrom(vmath.Vector3(0, 0, 0));
                                scene!.light.position.setFrom(vmath.Vector3(5, 5, 5));
                                scene!.update();
                                isLoading = false;
                              } catch (e) {
                                showPermissionSnackBar('Failed to load 3D model: $e');
                                isLoading = false;
                              }
                            });
                          },
                        ),
                        if (isLoading)
                          const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Title and Info Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Globe Explorer',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  Tooltip(
                    message: 'About Globe Explorer',
                    child: IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.white),
                      onPressed: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Globe Explorer',
                          applicationVersion: '1.0.0',
                          children: const [
                            Text(
                              'Explore a 3D Earth model with interactive controls, gyroscope support, '
                                  'and dynamic lighting.',
                            ),
                          ],
                        );
                        triggerHapticFeedback();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Model Info Overlay
          if (isModelInfoVisible)
            GestureDetector(
              onTap: () => toggleModelInfo(false),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      modelInfo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          // Control Panel
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.2,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Center(
                      child: Icon(Icons.drag_handle, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Controls',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Auto Rotate Switch
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Auto Rotate',
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                          Tooltip(
                            message: 'Enable/disable automatic rotation',
                            child: Switch(
                              value: isAutoRotating,
                              onChanged: toggleAutoRotation,
                              activeColor: Colors.blueAccent,
                              inactiveThumbColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Gyroscope Switch
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Gyroscope',
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                          Tooltip(
                            message: 'Use device gyroscope for control',
                            child: Switch(
                              value: isGyroscopeEnabled,
                              onChanged: toggleGyroscope,
                              activeColor: Colors.blueAccent,
                              inactiveThumbColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Rotation Speed Slider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rotation Speed',
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                          Tooltip(
                            message: 'Adjust auto-rotation speed',
                            child: Slider(
                              value: rotationSpeed,
                              min: 0.0,
                              max: 0.5,
                              divisions: 50,
                              label: rotationSpeed.toStringAsFixed(3),
                              onChanged: updateRotationSpeed,
                              activeColor: Colors.blueAccent,
                              inactiveColor: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Touch Sensitivity Slider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Touch Sensitivity',
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                          Tooltip(
                            message: 'Adjust touch/gesture sensitivity',
                            child: Slider(
                              value: touchSensitivity,
                              min: 0.001,
                              max: 0.01,
                              divisions: 20,
                              label: touchSensitivity.toStringAsFixed(3),
                              onChanged: updateTouchSensitivity,
                              activeColor: Colors.blueAccent,
                              inactiveColor: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Light Angle Slider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Light Angle',
                            style: TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                          Tooltip(
                            message: 'Adjust light position',
                            child: Slider(
                              value: lightAngle,
                              min: 0.0,
                              max: 2 * pi,
                              divisions: 100,
                              label: lightAngle.toStringAsFixed(2),
                              onChanged: updateLightAngle,
                              activeColor: Colors.blueAccent,
                              inactiveColor: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: resetView,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Reset View',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Gyroscope: $gyroscopeReading',
                      style: TextStyle(
                        fontSize: 14,
                        color: gyroscopeValues != null ? Colors.greenAccent : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            },
          ),
          // Zoom Buttons
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                Tooltip(
                  message: 'Zoom In',
                  child: FloatingActionButton(
                    heroTag: 'zoom_in_btn',
                    mini: true,
                    backgroundColor: Colors.blueAccent,
                    onPressed: zoomIn,
                    child: const Icon(Icons.zoom_in),
                  ),
                ),
                const SizedBox(height: 16),
                Tooltip(
                  message: 'Zoom Out',
                  child: FloatingActionButton(
                    heroTag: 'zoom_out_btn',
                    mini: true,
                    backgroundColor: Colors.blueAccent,
                    onPressed: zoomOut,
                    child: const Icon(Icons.zoom_out),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

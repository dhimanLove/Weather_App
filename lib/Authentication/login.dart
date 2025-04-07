import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weatherapp/Pages/Homepage.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Add this import
import 'package:weatherapp/firebase_options.dart'; // Make sure you have this file

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  FirebaseAuth auth = FirebaseAuth.instance;
bool isValidEmail(String email) {
  // Regular expression for basic email validation
  final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  return emailRegExp.hasMatch(email);
}

  // Updated Firebase initialization
  void initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  final usernameController = TextEditingController();
  final  passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool isLoading = false;
  late AnimationController animationController;
  late Animation<double> floatAnimation;

  @override
  void initState() {
    super.initState();

    initFirebase();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    animationController.dispose();
    super.dispose();
  }


  void handleLogin() async {
    if (formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true);

      try {

        await auth.signInWithEmailAndPassword(
          email: usernameController.text.trim(),
          password: passwordController.text,
        );

        setState(() => isLoading = false);

        Get.snackbar(
          "Success",
          "Login Successful! 🎉",
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 20,
          duration: const Duration(seconds: 3),
        );


        Get.offAll(() => const Homepage());
      } on FirebaseAuthException catch (e) {
        setState(() => isLoading = false);

        String errorMessage = "";
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Please enter a valid email address.';
        } else if (e.code == 'user-disabled') {
          errorMessage = 'This account has been disabled.';
        } else {
          errorMessage = 'An error occurred. Please try again.';
        }

        Get.snackbar(
          "Error",
          errorMessage,
          backgroundColor: Colors.red[700],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 20,
        );
      } catch (e) {
        setState(() => isLoading = false);

        Get.snackbar(
          "Error",
          "An unexpected error occurred. Please try again.",
          backgroundColor: Colors.red[700],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 20,
        );
      }
    }
  }

  // Google Sign In
  Future<void> signInWithGoogle() async {
    setState(() => isLoading = true);

    try {
      // Initialize GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // If user canceled the sign-in flow
      if (googleUser == null) {
        setState(() => isLoading = false);
        return;
      }


      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;


      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,

      );

      // Sign in with credential
      await auth.signInWithCredential(credential);
      setState(() => isLoading = false);

      Get.snackbar(
        "Success",
        "Google Sign-In Successful! 🎉",

        backgroundColor: Colors.black87,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 20,
        duration: const Duration(seconds: 3),

      );

      Get.offAll(() => const Homepage());
    } catch (e) {
      setState(() => isLoading = false);

      Get.snackbar(
        "Error",
        "$e",
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 20,
      );
    }
  }

  // Apple Sign In
  Future<void> signInWithApple() async {
    setState(() => isLoading = true);

    try {

      final AppleAuthProvider appleProvider = AppleAuthProvider();


      await auth.signInWithProvider(appleProvider);

      setState(() => isLoading = false);

      Get.snackbar(
        "Success",
        "Apple Sign-In Successful! 🎉",
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 20,
        duration: const Duration(seconds: 3),
      );

      Get.offAll(() => const Homepage());
    } catch (e) {
      setState(() => isLoading = false);

      Get.snackbar(
        "Error",
        "Apple Sign-In failed. Please try again.",
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 20,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Animated Gradient Background (Matching SignupScreen)
          AnimatedContainer(
            duration: const Duration(seconds: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E2A44).withOpacity(0.9),
                  const Color(0xFF0F1626).withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 1.0],
              ),
            ),
          ),


          Positioned(
            top: 50,
            left: 30,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, floatAnimation.value),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF4682B4).withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4682B4)
                              .withOpacity(0.2),
                          blurRadius: 10, 
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 100,
            right: 50,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, floatAnimation.value),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF87CEEB).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF87CEEB)
                              .withOpacity(0.1), 
                          blurRadius: 10, 
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 200,
            right: 100,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, floatAnimation.value),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF4682B4).withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4682B4)
                              .withOpacity(0.2), // Reduced opacity
                          blurRadius: 10, // Reduced from 20
                          spreadRadius: 2, // Reduced from 5
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Shimmering Title (Matching SignupScreen Colors)
                      Hero(
                        tag: "logo",
                        child: Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor:
                              const Color(0xFF87CEEB), // Matching SignupScreen
                          period: const Duration(seconds: 2),
                          child: Text(
                            'Login ✨',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  color: const Color(0xFF4682B4)
                                      .withOpacity(0.4), // Reduced opacity
                                  blurRadius: 10, // Reduced from 15
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),

                      // Email Field (Modified from Username) - Using email for Firebase Auth
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // Reduced opacity
                              blurRadius: 8, // Reduced from 10
                              offset: const Offset(0, 3), // Reduced spread
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: usernameController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email_outlined,
                                color: Colors.white70),
                            hintText: "Email",
                            hintStyle: const TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password Field (Glassmorphic, Matching Colors)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // Reduced opacity
                              blurRadius: 8, // Reduced from 10
                              offset: const Offset(0, 3), // Reduced spread
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: Colors.white70),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: () => setState(
                                  () => obscurePassword = !obscurePassword),
                            ),
                            hintText: "Password",
                            hintStyle: const TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Forgot Password option
                     Align(
  alignment: Alignment.centerRight,
  child: TextButton(
    onPressed: () {
      // Add password reset functionality
      String email = usernameController.text.trim();
      if (isValidEmail(email)) {
        auth.sendPasswordResetEmail(email: email).then((_) {
          Get.snackbar(
            "Password Reset",
            "We've sent a password reset link to your email",
            backgroundColor: Colors.green[700],
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            borderRadius: 20,
          );
        }).catchError((error) {
          Get.snackbar(
            "Error",
            "Couldn't send reset email. Please check your email address.",
            backgroundColor: Colors.red[700],
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            borderRadius: 20,
          );
        });
      } else {
        Get.snackbar(
          "Error",
          "Please enter a valid email address first",
          backgroundColor: Colors.red[700],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 20,
        );
      }
    },
    child: const Text(
      "Forgot Password?",
      style: TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
),
const SizedBox(height: 20),

                      // Animated Login Button (Matching SignupScreen Colors)
                      isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xFF4682B4)) // Matching SignupScreen
                          : GestureDetector(
                              onTap: handleLogin,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 18),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4682B4),
                                      Color(0xFF87CEEB)
                                    ], // Matching SignupScreen
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF4682B4)
                                          .withOpacity(0.3), // Reduced opacity
                                      blurRadius: 10, // Reduced from 20
                                      spreadRadius: 2, // Reduced from 5
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  'Login 🚀',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 30),

                      // Social Login Buttons (Matching SignupScreen Colors)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: signInWithGoogle,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white
                                        .withOpacity(0.2), // Reduced opacity
                                    blurRadius: 8, // Reduced from 10
                                    spreadRadius: 1, // Reduced from 2
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.g_mobiledata,
                                      color: Colors.black, size: 28),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Google',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: signInWithApple,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.2), // Reduced opacity
                                    blurRadius: 8, // Reduced from 10
                                    spreadRadius: 1, // Reduced from 2
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.apple,
                                      color: Colors.white, size: 28),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Apple',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weatherapp/Pages/Homepage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:weatherapp/Widgets/Bottomnavbar.dart';
import 'package:weatherapp/Modal/model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Weather? weatherkaithal;
  bool obscurePassword = true;
  bool isLoading = false;
  late AnimationController animationController;
  late Animation<double> floatAnimation;

  bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegExp.hasMatch(email);
  }


  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat(reverse: true);
    floatAnimation = Tween<double>(begin: -10, end: 10).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
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
            password: passwordController.text);
        setState(() => isLoading = false);
        Get.snackbar("Success", "Login Successful! 🎉",
            backgroundColor: Colors.black87,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            borderRadius: 20,
            duration: const Duration(seconds: 3));
        Get.offAll(() => const HomePage());
      } on FirebaseAuthException catch (e) {
        setState(() => isLoading = false);
        String errorMessage = e.code == 'user-not-found'
            ? 'No user found with this email.'
            : e.code == 'wrong-password'
                ? 'Wrong password provided.'
                : e.code == 'invalid-email'
                    ? 'Please enter a valid email address.'
                    : e.code == 'user-disabled'
                        ? 'This account has been disabled.'
                        : 'An error occurred. Please try again.';
        Get.snackbar("Error", errorMessage,
            backgroundColor: Colors.red[700],
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            borderRadius: 20);
      } catch (e) {
        setState(() => isLoading = false);
        Get.snackbar("Error", "An unexpected error occurred. Please try again.",
            backgroundColor: Colors.red[700],
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
            borderRadius: 20);
      }
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() => isLoading = true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await auth.signInWithCredential(credential);
      setState(() => isLoading = false);
      Get.snackbar("Success", "Google Sign-In Successful! 🎉",
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 20,
          duration: const Duration(seconds: 3));
      Get.offAll(() => const HomePage());
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar("Error", "$e",
          backgroundColor: Colors.red[700],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 20);
    }
  }

  Future<void> signInWithApple() async {
    setState(() => isLoading = true);
    try {
      final AppleAuthProvider appleProvider = AppleAuthProvider();
      await auth.signInWithProvider(appleProvider);
      setState(() => isLoading = false);
      Get.snackbar("Success", "Apple Sign-In Successful! 🎉",
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 20,
          duration: const Duration(seconds: 3));
      Get.offAll(() => const HomePage());
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar("Error", "Apple Sign-In failed. Please try again.",
          backgroundColor: Colors.red[700],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E2A44).withOpacity(0.9),
                  const Color(0xFF0F1626).withOpacity(0.8)
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
                  builder: (context, child) => Transform.translate(
                      offset: Offset(0, floatAnimation.value),
                      child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(colors: [
                                const Color(0xFF4682B4).withOpacity(0.4),
                                Colors.transparent
                              ]),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xFF4682B4)
                                        .withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 2)
                              ]))))),
          Positioned(
              bottom: 100,
              right: 50,
              child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) => Transform.translate(
                      offset: Offset(0, floatAnimation.value),
                      child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(colors: [
                                const Color(0xFF87CEEB).withOpacity(0.3),
                                Colors.transparent
                              ]),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xFF87CEEB)
                                        .withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2)
                              ]))))),
          Positioned(
              top: 200,
              right: 100,
              child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) => Transform.translate(
                      offset: Offset(0, floatAnimation.value),
                      child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(colors: [
                                const Color(0xFF4682B4).withOpacity(0.4),
                                Colors.transparent
                              ]),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xFF4682B4)
                                        .withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 2)
                              ]))))),
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
                      Hero(
                          tag: "logo",
                          child: Shimmer.fromColors(
                              baseColor: Colors.white,
                              highlightColor: const Color(0xFF87CEEB),
                              period: const Duration(seconds: 2),
                              child: Text('Login ✨',
                                  style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2,
                                      shadows: [
                                        Shadow(
                                            color: const Color(0xFF4682B4)
                                                .withOpacity(0.4),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4))
                                      ])))),
                      const SizedBox(height: 50),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.white.withOpacity(0.05)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3))
                              ]),
                          child: TextFormField(
                              controller: usernameController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email_outlined,
                                      color: Colors.white70),
                                  hintText: "Email",
                                  hintStyle:
                                      const TextStyle(color: Colors.white70),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none),
                                  filled: true,
                                  fillColor: Colors.transparent),
                              validator: (value) => value == null ||
                                      value.isEmpty
                                  ? 'Please enter your email'
                                  : !value.contains('@') || !value.contains('.')
                                      ? 'Please enter a valid email'
                                      : null)),
                      const SizedBox(height: 20),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.white.withOpacity(0.05)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3))
                              ]),
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
                                          color: Colors.white70),
                                      onPressed: () => setState(() =>
                                          obscurePassword = !obscurePassword)),
                                  hintText: "Password",
                                  hintStyle:
                                      const TextStyle(color: Colors.white70),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none),
                                  filled: true,
                                  fillColor: Colors.transparent),
                              validator: (value) => value == null ||
                                      value.isEmpty
                                  ? 'Please enter your password'
                                  : value.length < 6
                                      ? 'Password must be at least 6 characters'
                                      : null)),
                      const SizedBox(height: 10),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {
                                String email = usernameController.text.trim();
                                if (isValidEmail(email)) {
                                  auth
                                      .sendPasswordResetEmail(email: email)
                                      .then((_) => Get.snackbar(
                                          "Password Reset",
                                          "We've sent a password reset link to your email",
                                          backgroundColor: Colors.green[700],
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                          margin: const EdgeInsets.all(16),
                                          borderRadius: 20))
                                      .catchError((error) => Get.snackbar(
                                          "Error",
                                          "Couldn't send reset email. Please check your email address.",
                                          backgroundColor: Colors.red[700],
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                          margin: const EdgeInsets.all(16),
                                          borderRadius: 20));
                                } else {
                                  Get.snackbar("Error",
                                      "Please enter a valid email address first",
                                      backgroundColor: Colors.red[700],
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: const EdgeInsets.all(16),
                                      borderRadius: 20);
                                }
                              },
                              child: const Text("Forgot Password?",
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500)))),
                      const SizedBox(height: 20),
                      isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xFF4682B4))
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
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight),
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                            color: const Color(0xFF4682B4)
                                                .withOpacity(0.3),
                                            blurRadius: 10,
                                            spreadRadius: 2)
                                      ]),
                                  child: const Text('Login 🚀',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 1.2)))),
                      const SizedBox(height: 30),
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
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              blurRadius: 8,
                                              spreadRadius: 1)
                                        ]),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.g_mobiledata,
                                              color: Colors.black, size: 28),
                                          const SizedBox(width: 8),
                                          Text('Google',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16))
                                        ]))),
                            const SizedBox(width: 16),
                            GestureDetector(
                                onTap: () =>
                                    Get.to(BottomNavBar()),
                                child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 8,
                                              spreadRadius: 1)
                                        ]),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.apple,
                                              color: Colors.white, size: 28),
                                          const SizedBox(width: 8),
                                          Text('Apple',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16))
                                        ])))
                          ]),
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

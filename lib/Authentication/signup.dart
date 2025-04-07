import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weatherapp/Pages/Homepage.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> floatAnimation;

  @override
  void initState() {
    super.initState();
    animationController =
    AnimationController(vsync: this, duration: Duration(seconds: 5))
      ..repeat(reverse: true);
    fadeAnimation = Tween<double>(begin: 0, end: 100).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
    floatAnimation = Tween<Offset>(
        begin: Offset(0, 10), end: Offset(10, -20))
        .animate(CurvedAnimation(
        parent: animationController, curve: Curves.easeOutSine));
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    animationController.dispose();
    super.dispose();
  }

  void handleSignup() async {
    if (formKey.currentState?.validate() ?? false) {
      setState(() => isLoading = true);
      await Future.delayed(Duration(seconds: 2));
      setState(() => isLoading = false);

      Get.snackbar(
        "Success",
        "Signup Successful! 🎉",
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
        borderRadius: 20,
        duration: Duration(seconds: 3),
      );
      Get.off(() => Homepage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E2A44), Color(0xFF0F1626)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 40,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: fadeAnimation,
                  child: Transform.translate(
                    offset: floatAnimation.value,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF4682B4).withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4682B4).withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 80,
            right: 60,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: fadeAnimation,
                  child: Transform.translate(
                    offset: floatAnimation.value,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF4682B4).withOpacity(0.3),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4682B4).withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Color(0xFF4682B4),
                        child: Text(
                          'Signup ✨',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon:
                          Icon(Icons.email_outlined, color: Colors.white70),
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor:  Color(0xFF0F1626).withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                            BorderSide(color: Color(0xFF4682B4), width: 1.5),
                          ),
                        ),
                        validator: (value) =>
                        value!.isEmpty ? 'Please enter your email' : null,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.name,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon:
                          Icon(Icons.person_outline, color: Colors.white70),
                          hintText: "Username",
                          hintStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Color(0xFF2E3B3E).withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                            BorderSide(color: Color(0xFF4682B4), width: 1.5),
                          ),
                        ),
                        validator: (value) =>
                        value!.isEmpty ? 'Please enter your username' : null,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        style: TextStyle(color: Colors.white),
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          prefixIcon:
                          Icon(Icons.lock_outline, color: Colors.white70),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () =>
                                setState(() => obscurePassword = !obscurePassword),
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Color(0xFF2E3B3E).withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                            BorderSide(color: Color(0xFF4682B4), width: 1.5),
                          ),
                        ),
                        validator: (value) =>
                        value!.isEmpty ? 'Please enter your password' : null,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: confirmPasswordController,
                        style: TextStyle(color: Colors.white),
                        obscureText: obscureConfirmPassword,
                        decoration: InputDecoration(
                          prefixIcon:
                          Icon(Icons.lock_outline, color: Colors.white70),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () => setState(() =>
                            obscureConfirmPassword = !obscureConfirmPassword),
                          ),
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Color(0xFF2E3B3E).withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                            BorderSide(color: Color(0xFF4682B4), width: 1.5),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return 'Please confirm your password';
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 40),
                      if (isLoading) CircularProgressIndicator(color: Color(0xFF4682B4)) else ElevatedButton(
                        onPressed: handleSignup,
                        style: ElevatedButton.styleFrom(
                          padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF4682B4), // Steel blue
                                Color(0xFF87CEEB), // Light sky blue
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Text(
                            'Signup',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.g_mobiledata, color: Colors.black, size: 28),
                            label: Text(
                              "Google",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              shadowColor: Colors.grey.withOpacity(0.4),
                            ).copyWith(
                              backgroundColor:
                              WidgetStatePropertyAll(Colors.white),
                              overlayColor: WidgetStatePropertyAll(
                                  Colors.black.withOpacity(0.9)),
                            ),
                          ),
                          SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: () => Get.to(() => Homepage()),
                            icon: Icon(Icons.apple, color: Colors.white, size: 28),
                            label: Text(
                              "Apple",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              shadowColor: Colors.grey.withOpacity(0.4),
                            ).copyWith(
                              backgroundColor:
                              WidgetStatePropertyAll(Colors.black),
                              overlayColor: WidgetStatePropertyAll(
                                  Colors.white.withOpacity(0.1)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          "Already have an account? Login",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
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
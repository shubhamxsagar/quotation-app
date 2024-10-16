import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quotation/core/localstorage/localstorage.dart';
import 'package:quotation/routes/my_app_route.dart';
import 'package:quotation/widgets/custom_button.dart';
import 'package:quotation/widgets/custom_text_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signUpWithEmail(BuildContext context) async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      context.goNamed(RouteConstants.home); // Navigate to home screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Authenticate with Firebase using Google credentials
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // Save UID to local storage
      final localStorage = ref.read(localStorageProvider);
      localStorage.setUid(userCredential.user?.uid ?? '');

      // Check if user exists in Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (!userDoc.exists) {
        // If user doesn't exist, create a new one
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'email': userCredential.user?.email,
          'createdAt': Timestamp.now(),
        });
      }

      context.goNamed(RouteConstants.home);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            Text(
              "Hello! Register to get started",
              style: textTheme.displayMedium?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            // CustomTextField(
            //   obscureText: false,
            //   hintText: 'Username',
            //   controller: emailController,
            //   keyboardType: TextInputType.emailAddress,
            // ),
            // const SizedBox(height: 16),
            CustomTextField(
              obscureText: false,
              hintText: 'Email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'Password',
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'Confirm Password',
              controller: confirmPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Register',
              onPressed: () => signUpWithEmail(context),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Or Register with',
                style: textTheme.displayMedium?.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        signInWithGoogle(context);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 0.5,
                              blurRadius: 0.1,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Image.asset(
                              'assets/google.png',
                              width: 35,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: textTheme.displayMedium?.copyWith(fontSize: 16),
                ),
                TextButton(
                  onPressed: () => context.push('/login'),
                  child: const Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

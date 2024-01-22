import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:sizer/sizer.dart';
import 'package:to_do/auth.dart';
import 'package:to_do/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen(
      (event) {
        setState(
          () {
            _user = event;
            if (_user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 166, 14, 204),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 90.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 39, 150, 241),
                    borderRadius: BorderRadius.circular(
                      20.sp,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'TO-DO-LIST',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 25.sp,
                        ),
                      ),
                      Center(
                        child: SignInButton(Buttons.google, onPressed: () {
                          handleGoogleSignIn();
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void handleGoogleSignIn() {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(googleAuthProvider);
    } catch (error) {
      print("error");
    }
  }
}

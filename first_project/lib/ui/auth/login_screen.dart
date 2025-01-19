import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/ui/auth/login_with_phone_number.dart';
import 'package:first_project/ui/auth/signup_screen.dart';
import 'package:first_project/ui/posts/post_screen.dart';
import 'package:first_project/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utilis/utilis.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final emailController = TextEditingController();
  final passwordCotroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordCotroller.dispose();
  }

  void Login() {
    setState(() {
      loading = true;
    });
    try {
      _auth
          .signInWithEmailAndPassword(
              email: emailController.text.toString(),
              password: passwordCotroller.text.toString())
          .then((value) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PostScreen()));
        setState(() {
          loading = false;
        });
      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
        setState(() {
          loading = false;
        });
      });
    } catch (error) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // This code for the app can exit through the mobile button
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text('LogIn Screen'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: SizedBox(
            height: double.infinity,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration: const InputDecoration(
                                  hintText: 'Enter email',
                                  prefixIcon: Icon(Icons.email_outlined)
                                  // helperText: 'enter email e.g jon@gmail.com'
                                  ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'The field in required';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: passwordCotroller,
                              obscureText: true,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline),
                                hintText: 'Enter Password',
                                // helperText: 'enter email e.g jon@gmail.com'
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'the field is required';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 50,
                    ),
                    RoundButton(
                      title: 'LogIn',
                      loading: loading,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            Login();
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account"),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen()));
                            },
                            child: const Text('Sign Up')),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LoginWithPhoneNumber()));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black)),
                        child: const Center(
                          child: Text('Login With Phone Number'),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

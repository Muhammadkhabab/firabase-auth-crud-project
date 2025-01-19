import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/ui/auth/login_screen.dart';
import 'package:first_project/utilis/utilis.dart';
import 'package:first_project/widgets/round_button.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final emailController = TextEditingController();
  final passwordCotroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordCotroller.dispose();
  }

  void SignUp() {
    setState(() {
      loading = true;
    });
    try {
      _auth.createUserWithEmailAndPassword(email: emailController.text.toString(), password: passwordCotroller.text.toString()).then((value) {
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sign Up Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
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
                      decoration: const InputDecoration(hintText: 'Enter email', prefixIcon: Icon(Icons.email_outlined)
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
              title: 'SignUp',
              loading: loading,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  SignUp();
                }
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account"),
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: const Text('LogIn'))
              ],
            )
          ],
        ),
      ),
    );
  }
}

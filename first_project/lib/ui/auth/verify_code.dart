import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/ui/posts/post_screen.dart';
import 'package:first_project/utilis/utilis.dart';
import 'package:flutter/material.dart';

import '../../widgets/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String VerifivcationId;
  const VerifyCodeScreen({super.key, required this.VerifivcationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final verifyCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
                controller: verifyCodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: '6 digit code')),
            const SizedBox(
              height: 70,
            ),
            RoundButton(
                title: 'Verify',
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.VerifivcationId,
                      smsCode: verifyCodeController.text.toString());
                  try {
                    await auth.signInWithCredential(credential);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PostScreen()));
                  } catch (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(e.toString());
                  }
                })
          ],
        ),
      ),
    );
  }
}

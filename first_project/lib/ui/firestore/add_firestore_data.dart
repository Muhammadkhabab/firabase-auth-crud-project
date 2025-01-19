import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:first_project/utilis/utilis.dart';
import 'package:first_project/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({super.key});

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Firestore Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'What is your mind',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
                title: 'Add',
                loading: loading,
                onTap: () async {
                  // setState(() {
                  //   loading = true;
                  // });

                  String id = DateTime.now().microsecondsSinceEpoch.toString();
                  await fireStore.doc(id).set({
                    'tittle': postController.text.toString(),
                    'id': id
                  }).then((value) {
                    // setState(() {
                    //   loading = false;
                    // });
                    Utils().toastMessage('Your post is added');
                  }).onError((error, stackTrace) {
                    // setState(() {
                    //   loading = false;
                    // });
                    Utils().toastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}

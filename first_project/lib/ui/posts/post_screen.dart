import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:first_project/ui/auth/login_screen.dart';
import 'package:first_project/ui/posts/add_post_screen.dart';
import 'package:first_project/utilis/utilis.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Post Screen'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout_outlined)),
          const SizedBox(
            width: 19,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                  //This code is the search anything
                  hintText: 'Search anything here',
                  border: OutlineInputBorder()),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            //This is only widget to use for facth data
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: const Text(
                    'Loading'), // This is loading which is anything not show to this is loading
                itemBuilder: (context, snapshot, animation, index) {
                  final title = Text(snapshot.child('title').value.toString());
                  if (searchFilter.text.isEmpty) {
                    return ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        // This code to show id from firebase
                        subtitle: Text(snapshot.child('id').value.toString()),
                        trailing: PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          showMyDialog(
                                              title.toString(),
                                              snapshot
                                                  .child('id')
                                                  .value
                                                  .toString());
                                        },
                                        leading: const Icon(Icons.edit),
                                        title: const Text('Edit'),
                                      )),
                                  PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          ref
                                              .child(snapshot
                                                  .child('id')
                                                  .value
                                                  .toString())
                                              .remove();
                                        },
                                        leading:
                                            const Icon(Icons.delete_outline),
                                        title: const Text('Delete'),
                                      ))
                                ]));
                  } else if (title.toString().toLowerCase().contains(
                      searchFilter.text.toLowerCase().toLowerCase())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      // This code to show id from firebase
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (Context) => const AddPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: const InputDecoration(hintText: 'Edit'),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.child(id).update({
                      'title': editController.text.toLowerCase()
                    }).then((value) {
                      Utils().toastMessage('Your message is updated');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text('Update'))
            ],
          );
        });
  }
}


// How to fitch data mean to show the data from firbase database into the screen
//There are the two different ways to fitch the data the firbase th one is animated list and the other is stream builder.
// ***** This code to use the stream bulider to retutn the data from the fireBase 
// Expanded(
//             child: StreamBuilder(
//               stream: ref.onValue,
//               builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
//                 if (!snapshot.hasData) {
//                   return const CircularProgressIndicator();
//                 } else {
//                   Map<dynamic, dynamic> map =
//                       snapshot.data!.snapshot.value as dynamic;
//                   List<dynamic> list = [];
//                   list.clear();
//                   list = map.values.toList();
//                   return ListView.builder(
//                       itemCount: snapshot.data!.snapshot.children.length,
//                       itemBuilder: (context, index) {
//                         return ListTile(
//                           title: Text(list[index]['title']),
//                           subtitle: Text(list[index]['id']),
//                         );
//                       }
//                       );
//                 }
//               },
//             ),
//           ),
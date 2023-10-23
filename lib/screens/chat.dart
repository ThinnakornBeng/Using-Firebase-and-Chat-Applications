import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_work_shop_2/models/user_model.dart';

import 'authentication.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController msg = new TextEditingController();
  String? title, body, nameUser;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataUserLogin();
  }

  Future<Null> readDataUserLogin() async {
    FirebaseAuth.instance.authStateChanges().listen(
      (event) async {
        String uidUser = event!.uid;
        FirebaseFirestore.instance
            .collection('userTable')
            .doc(uidUser)
            .snapshots()
            .listen(
          (event) async {
            setState(
              () {
                userModel = UserModel.fromMap(
                  event.data()!,
                );
              },
            );
            nameUser = userModel!.name;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.login)),
        ],
        title: Text('คุณ $nameUser'),
      ),
      body: Container(
        height: size.height / 1.25,
        width: size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('chatTable')
              .orderBy('time', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var map = snapshot.data!.docs[index].data();
                  return message(size, map);
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 40, top: 100),
        height: size.height / 8,
        width: size.height,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: size.height / 10,
            width: size.height,
            child: TextField(
              controller: msg,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      onSentMessage();
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.blue,
                    )),
                hintText: 'กรุณากรอกข้อความที่ต้องการส่ง...',
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> signOut() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.signOut().then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Authentication(),
            ));
      });
    });
  }

  void onSentMessage() async {
    if (msg.text.isNotEmpty) {
      Map<String, dynamic> message = {
        'sendby': nameUser,
        'message': msg.text,
        'time': FieldValue.serverTimestamp(),
        // 'uidRest': queueModel.uidRest,
      };

      await _firestore.collection('chatTable').add(message);
      msg.clear();
    } else {
      print("Enter Some Text");
    }
  }

  Widget message(Size size, var map) {
    return Container(
      width: size.width,
      alignment: map['sendby'] == nameUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          map['message'],
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

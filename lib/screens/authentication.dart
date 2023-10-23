import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_work_shop_2/screens/admin.dart';
import 'package:flutter_application_work_shop_2/screens/chat.dart';
import 'package:flutter_application_work_shop_2/screens/home_page.dart';

import '../models/user_model.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  String? email,
      password,
      type; // ใช้ในการรับข้อมูลจาก TextField และเช็คประเภทการล็อกอิน
  List<UserModel> userModel = []; // model ในการรับข้อมูลจาก Firestore database

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textAuthen(),
            emailTextField(),
            passwordTextField(),
            loginElevatedButton()
          ],
        ),
      ),
    );
  }

  Widget textAuthen() {
    return Text(
            'Authentication',
            style: TextStyle(
              fontSize: 30,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          );
  }

  Widget loginElevatedButton() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: 250,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          checkAuthen();
        },
        child: Text('Login'),
      ),
    );
  }

  Future<Null> checkAuthen() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!)
          .then((value) async {
        String? uid = value.user!.uid;
        await FirebaseFirestore.instance
            .collection('userTable')
            .doc(uid)
            .snapshots()
            .listen((event) {
          UserModel model = UserModel.fromMap(event.data()!);
          switch (model.type) {
            case 'user':
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(),
                  ),
                  (route) => false);
              break;
              case 'admin':
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPage(),
                  ),
                  (route) => false);
              break;
            default:
          }
        });
      });
    });
  }

  Widget passwordTextField() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: 350,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.password_rounded),
          label: Text('Password'),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }
  Widget emailTextField() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: 350,
      child: TextField(
        onChanged: (value) => email = value.trim(),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email_rounded),
          label: Text('Email'),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}

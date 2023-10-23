import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_work_shop_2/models/user_model.dart';
import 'package:flutter_application_work_shop_2/screens/add_picture.dart';
import 'package:flutter_application_work_shop_2/screens/authentication.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserModel> userModel = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataUserModel();
  }

  Future<Null> readDataUserModel() async {
    Firebase.initializeApp().then((value) async {
      FirebaseFirestore.instance
          .collection('userTable')
          .snapshots()
          .listen((event) {
        for (var element in event.docs) {
          UserModel model = UserModel.fromMap(element.data());
          setState(() {
            userModel.add(model);
            print('UserModel is ===>>>$userModel<<<===');
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: Text('Home Page'),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => AddPicturePage(),
          //           ));
          //     },
          //     icon: Icon(Icons.add)),
          // IconButton(
          //     onPressed: () {
          //       signOut();
          //     },
          //     icon: Icon(Icons.login))
        ],
      ),
      body: userModel.isEmpty
          ? Text('ไม่พบข้อมูลผู้ใช้งาน')
          : ListView.builder(
              itemCount: userModel.length,
              itemBuilder: (context, index) => Card(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  color: Color.fromARGB(255, 198, 244, 248),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(userModel[index].name),
                      Text(userModel[index].email),
                      Text(userModel[index].type),
                    ],
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
}

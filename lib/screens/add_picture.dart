import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_work_shop_2/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

class AddPicturePage extends StatefulWidget {
  const AddPicturePage({super.key});

  @override
  State<AddPicturePage> createState() => _AddPicturePageState();
}

class _AddPicturePageState extends State<AddPicturePage> {
  File? file;
  String? urlImageProfile, uidUser, newUrlImageProfile;
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
        uidUser = event!.uid;
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
            urlImageProfile = userModel!.imageProfile;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                upLoadPictureToStoage();
              },
              icon: Icon(Icons.save))
        ],
        title: Text('Add Picture Page'),
      ),
      
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          showImage(),
          choooseImageCamera(),
          choooseImageGallery(),
        ],
      )),
    );
  }

  Widget choooseImageGallery() {
    return Container(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () => choooseImage(ImageSource.gallery),
        child: Container(
          width: 200,
          child: Card(
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.image,
                      size: 30,
                      color: Colors.white,
                    )),
                Text(
                  'เลือกจากแกลลอรี่',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget choooseImageCamera() {
    return Container(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () => choooseImage(ImageSource.camera),
        child: Container(
          width: 200,
          child: Card(
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 30,
                      color: Colors.white,
                    )),
                Text(
                  'เลือกจากกล้อง',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showImage() {
    return Container(
      margin: EdgeInsets.only(top: 40),
      width: 190,
      height: 180,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
        ),
        shadowColor: Colors.red,
        child: Center(
          child: ClipOval(
            child: file == null
                ? Image.network(
                    urlImageProfile!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    file!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  Future<Null> choooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker().pickImage(
        source: imageSource,
        maxHeight: 500,
        maxWidth: 500,
      );
      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }

  Future<Null> upLoadPictureToStoage() async {
    Random random = Random();
    int i = random.nextInt(1000000);

    Firebase.initializeApp().then((value) async {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference reference = storage.ref().child('Profile/ImageProfile$i.jpg');
      UploadTask uploadTask = reference.putFile(file!);

      newUrlImageProfile = await (await uploadTask).ref.getDownloadURL();
      print('UrlImage ===>>> $newUrlImageProfile');

      upDatePictureToCloudFriestore();
    });
  }

  Future<Null> upDatePictureToCloudFriestore() async {
    Firebase.initializeApp().then((value) async {
      FirebaseFirestore.instance
          .collection('userTable')
          .doc(uidUser)
          .update({"imageProfile": newUrlImageProfile}).then(
        (value) async {},
      );
    });
  }
}

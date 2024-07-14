import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class profilepage extends StatefulWidget {
  const profilepage({super.key});

  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {
  Uint8List? image;

  String? url;

  TextEditingController fullname = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController admno = TextEditingController();

  void Submit() async {
    try {
      // var user=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text);

      final DocumentReference register =
          FirebaseFirestore.instance.collection('register').doc(
              // user.user?.uid);

              // 2)
              FirebaseAuth.instance.currentUser?.uid);

      final data = {
        // 'Email': Email.text,
        'Fullname': fullname.text,
        'Admno': admno.text,
        'phone number': phone.text,
      };
      final storageRef = FirebaseStorage.instance.ref();

      final photoRef = storageRef.child("users/" + Email.text + "/photo.jpg");

      if (image != null) {
        await photoRef.putData(image!);
        var url = await photoRef.getDownloadURL();
        data["url"] = url;
      }

      register.update(data);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    // register.set(data);
  }

  void initState() {
    // TODO: implement initState
    WidgetsFlutterBinding.ensureInitialized();
    init();
    super.initState();
  }

  // 5)
  void init() async {
    var result = await FirebaseFirestore.instance
        .collection("register")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (result.docs.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("profile not found"),
        ),
      );
    } else {
      var user = result.docs.first.data();
      Email.text = user['Email'];
      fullname.text = user['Fullname'];

      phone.text = user['phone number'];
      admno.text = user['Admno'];

      url = user['url'];

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/bg1.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(239, 240, 242, 1),
            ),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      FloatingActionButton.small(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        elevation: 0,
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Colors.black,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(width: 1, color: Colors.grey),
                        ),
                        backgroundColor: Colors.transparent.withOpacity(0),
                      ),
                      SizedBox(
                        width: 85,
                      ),
                      Text(
                        'Edit Profile',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 20,
                ),
                Column(children: [
                  // CircleAvatar(
                  //   backgroundImage:
                  //       AssetImage('assets/images/personeforprofiledemo.jpg'),
                  //   radius: 40,
                  // ),
                  if (image != null)
                    CircleAvatar(
                      radius: 40, // Adjust the radius as needed
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.memory(
                          image!,
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  // Display the image from a URL using Image.network
                  if (url != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 40, // Adjust the radius as needed
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image.network(
                            url!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                  SizedBox(),
                  TextButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      image = await (await picker.pickImage(
                              source: ImageSource.gallery))
                          ?.readAsBytes();
                      setState(() {});

                      setState(() {});
                    },
                    child: Text(
                      'Change profile photo',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 5, 5),
                      child: Row(
                        children: [
                          Text(
                            'Full name',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 350,
                      height: 50,
                      child: TextFormField(
                        controller: fullname,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(color: Colors.black38),
                          focusColor: Colors.black38,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 5, 5),
                      child: Row(
                        children: [
                          Text(
                            'Admn No.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 350,
                      height: 50,
                      child: TextFormField(
                        controller: admno,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(color: Colors.black38),
                          focusColor: Colors.black38,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 5, 5),
                      child: Row(
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 350,
                      height: 50,
                      child: TextFormField(
                        controller: Email,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(color: Colors.black38),
                          focusColor: Colors.black38,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 5, 5),
                      child: Row(
                        children: [
                          Text(
                            'Phone Number',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 350,
                      height: 50,
                      child: TextFormField(
                        controller: phone,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(color: Colors.black38),
                          focusColor: Colors.black38,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Container(
                      width: 350,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Submit();
                        },
                        child: const Text(
                          "Save Change",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

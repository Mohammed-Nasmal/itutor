import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itutor1/accountandsettings/profile.dart';

class myaccoutnt extends StatefulWidget {
  const myaccoutnt({super.key});

  @override
  State<myaccoutnt> createState() => _myaccoutntState();
}

class _myaccoutntState extends State<myaccoutnt> {
  // String email = '';

  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  // Future<void> fetchData() async {
  //   try {
  //     DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('register')
  //         .doc(FirebaseAuth.instance.currentUser?.uid)
  //         .get();

  //     if (snapshot.exists) {
  //       // Access the 'Email' field from the document data
  //       setState(() {
  //         email = snapshot.get('Email');
  //       });
  //     } else {
  //       setState(() {
  //         email = 'Document not found';
  //       });
  //     }
  //   } catch (error) {
  //     setState(() {
  //       email = 'Error: $error';
  //     });
  //   }
  // }

//full name with default name when it is null or empty

  // String email = '';
  // String fullName = '';

  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  // Future<void> fetchData() async {
  //   try {
  //     DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('register')
  //         .doc(FirebaseAuth.instance.currentUser?.uid)
  //         .get();

  //     if (snapshot.exists) {
  //       // Access the 'Email' and 'Fullname' fields from the document data
  //       setState(() {
  //         email = snapshot.get('Email');
  //         // Use the null-aware operator to provide a default name if 'Fullname' is null or empty
  //         fullName = (snapshot.get('Fullname') ?? '').toString().trim();
  //         if (fullName.isEmpty) {
  //           fullName = 'Student';
  //         }
  //       });
  //     } else {
  //       setState(() {
  //         email = 'Document not found';
  //         fullName = 'Student';
  //       });
  //     }
  //   } catch (error) {
  //     setState(
  //       () {
  //         email = 'Error: $error';
  //         fullName = 'Error fetching Fullname';
  //       },
  //     );
  //   }
  // }

  String fullName = '';
  String imageUrl = '';
  String email = '';
  bool dataFetched = false;

  @override
  void initState() {
    super.initState();
    fetchEmail();
    fetchData(); // Fetch the rest of the data
  }

  Future<void> fetchEmail() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('register')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          email = snapshot.get('Email');
        });
      } else {
        setState(() {
          email = 'No Email Available';
        });
      }
    } catch (error) {
      setState(() {
        email = 'Error fetching Email';
      });
    }
  }

  Future<void> fetchData() async {
    if (dataFetched) {
      return; // If data has already been fetched, do nothing
    }

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('register')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      print("Snapshot data: ${snapshot.data()}");

      if (snapshot.exists) {
        // Access the 'Fullname', 'ImageUrl' fields from the document data
        String tempEmail =
            (snapshot.get('Email') ?? 'No Email Available').toString().trim();

        setState(() {
          fullName =
              (snapshot.get('Fullname') ?? 'Default Name').toString().trim();
          email = tempEmail;
          imageUrl = snapshot.get('url') ??
              'https://th.bing.com/th/id/OIG.6c43LvdImI095Uv0rgRw?pid=ImgGn';
          dataFetched =
              true; // Set the flag to true after successfully fetching data
        });
      } else {
        setState(() {
          fullName = 'Default Name';
          email = 'No Email Available';
          imageUrl =
              'https://th.bing.com/th/id/OIG.6c43LvdImI095Uv0rgRw?pid=ImgGn';
          dataFetched =
              true; // Set the flag to true even if the document doesn't exist
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
      setState(() {
        fullName = 'Student';
        imageUrl =
            'https://th.bing.com/th/id/OIG.6c43LvdImI095Uv0rgRw?pid=ImgGn';
        dataFetched = true; // Set the flag to true even if there's an error
      });
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
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton.small(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          elevation: 0,
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(width: 1, color: Colors.grey),
                          ),
                          backgroundColor: Colors.transparent.withOpacity(0),
                        ),
                      ),
                      SizedBox(
                        width: 85,
                      ),
                      Text(
                        'My Account',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : Image.asset('assets/images/student.jpeg').image,
                  // backgroundImage: AssetImage('assets/images/student.jpeg'),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$fullName',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      '$email',
                      style: TextStyle(fontSize: 15, color: Colors.white54),
                    ),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => profilepage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.mode,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 86, 110, 247).withOpacity(0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.stars,
                          size: 40,
                          color: Colors.white,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upgrade to Premium',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Enjoy all benefits with no restriction',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(239, 240, 242, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        //container theme
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(Icons.verified_user_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Security',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 195,
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(Icons.tune_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Data Controls',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 160,
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(Icons.contrast_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Theme',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'About',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        //container theme
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(Icons.help_outline_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Help Center',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 170,
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(Icons.description_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Terms of Use',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 160,
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(Icons.lock_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Privacy Policy',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 155,
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(Icons.file_copy_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Licenses',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 185,
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'itutor AI Chatbot',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 131,
                                  ),
                                  Text(
                                    'v.1.0',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 350,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/intro', (route) => false);
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

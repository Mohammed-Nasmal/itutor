import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:itutor1/Promtui/promtassistuser.dart';
import 'package:itutor1/accountandsettings/myaccount.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  String fullName = '';
  String imageUrl = '';
  bool dataFetched = false;

  @override
  void initState() {
    super.initState();
    fetchData();
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

      if (snapshot.exists) {
        // Access the 'Fullname' and 'ImageUrl' fields from the document data
        setState(() {
          fullName =
              (snapshot.get('Fullname') ?? 'Default Name').toString().trim();
          imageUrl = snapshot.get('url') ??
              'https://th.bing.com/th/id/OIG.6c43LvdImI095Uv0rgRw?pid=ImgGn';
          dataFetched =
              true; // Set the flag to true after successfully fetching data
        });
      } else {
        setState(() {
          fullName = 'Pal';
          imageUrl =
              'https://th.bing.com/th/id/OIG.6c43LvdImI095Uv0rgRw?pid=ImgGn';
          dataFetched =
              true; // Set the flag to true even if the document doesn't exist
        });
      }
    } catch (error) {
      setState(() {
        fullName = 'Student';
        imageUrl =
            'https://th.bing.com/th/id/OIG.6c43LvdImI095Uv0rgRw?pid=ImgGn';
        dataFetched = true; // Set the flag to true even if there's an error
      });
    }
  }

  void chatbot() async {
    // Replace 'YOUR_APP_ID' and 'YOUR_API_KEY' with your actual App ID and API Key
    // String appId = '368a6ce87de24cf6a29b132d336de1223';
    // String apiKey = 'Nfqq1MnMmlQgNIe0p5r7ysAO7H2aqoMRR';

    // Replace 'YOUR_USER_ID' with the user ID if required by your application

    dynamic conversationObject = {
      'appId': 'f076a83fdc29b98ef841f6cd2f2b20d1',
      'botIds': ['itutor-monin'],
    };

    KommunicateFlutterPlugin.buildConversation(conversationObject)
        .then((clientConversationId) {
      print("Conversation builder success: $clientConversationId");
    }).catchError((error) {
      print("Conversation builder error: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/background1.png'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            children: [
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          InkWell(
                            onTap: () {
                              // Navigate to the profile screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => myaccoutnt()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: imageUrl.isNotEmpty
                                    ? NetworkImage(imageUrl)
                                    : Image.asset('assets/images/student.jpeg')
                                        .image,
                                // backgroundImage:
                                //     AssetImage('assets/images/student.jpeg'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                '  Hi,$fullName',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                         
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '  Promt Assist',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 100,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) {
                                    return const promtassituser();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              'Explore All',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        //first row for roundedrectangle area
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                //column created to give tex alignment under icons
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    // row for icon buttun inside roundedrectangle area
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.edit_document,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.bookmark_outline_rounded,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Articles',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  //seperate
                                  Text('Genereate greate article'),
                                  Text('With any topics You'),
                                  Text('want.'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                //column created to give tex alignment under icons
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    // row for icon buttun inside roundedrectangle area
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.timer_rounded,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.bookmark_outline_rounded,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Quit Test',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('Tap to take a quick 5-min'),
                                  Text("test lets Get Started!"),
                                  SizedBox(
                                    height: 17,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      //resent content should show here
                      SizedBox(
                        height: 360,
                      ),
                    ],
                  ),
                  Container(
                    height: 55,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.roofing_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.history,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: Container(
          width: 70,
          height: 70,
          child: FittedBox(
            child: new FloatingActionButton(
              onPressed: () {
                chatbot();
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.indigoAccent,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: new BottomAppBar(
          color: Colors.white,
        ),
      ),
    );
  }
}

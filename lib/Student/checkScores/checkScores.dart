import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'scoresList.dart';

class CheckScore extends StatefulWidget {
  const CheckScore({Key? key}) : super(key: key);

  @override
  State<CheckScore> createState() => _CheckScoreState();
}

class _CheckScoreState extends State<CheckScore> {
  @override
  Widget build(BuildContext context) {
    var email = FirebaseAuth.instance.currentUser?.uid;
    var firestore = FirebaseFirestore.instance
        .collection("register")
        .doc(email)
        .collection("answers")
        .snapshots();
    return Scaffold(
      appBar: AppBar(title: Text("Progress"),),
      body: StreamBuilder(
        stream: firestore,
        builder: (context, snapshot) {
          // check if snapshot data is null..............................
          if ((snapshot.data?.docs.length).toString() == "null" ||
              (snapshot.data?.docs.length).toString() == "0") {
            return Container(
                alignment: Alignment.center,
                child: Text(
                  "You have Not Participated in any Quiz\nComplete now to Check Scores here.!",
                  style: TextStyle(
                      height: 1.5,
                      fontSize: 23,
                      color:Color(0xFF263300),
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.visible,
                      wordSpacing: 2,
                      letterSpacing: 0.4),
                  textAlign: TextAlign.center,
                ));
          } else {
            return ListView.builder(
              physics: const ScrollPhysics(),
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2,
              //     mainAxisExtent: MediaQuery.of(context).size.width / 1 ,
              //     mainAxisSpacing: 10),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return scoresList(snapshot, index, context);
              },
            );
          }
        },
      ),
    );
  }
}

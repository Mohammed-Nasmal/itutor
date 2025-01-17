import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


void dialogBoxResult(context, String? docID, String studName) {
  var firebaseStore = FirebaseFirestore.instance
      .collection("register")
      .doc(docID)
      .collection("answers")
      .snapshots();
  String? facEmail = FirebaseAuth.instance.currentUser?.uid;
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        elevation: 20,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.chair_outlined, size: 30),
        title: Text(studName, textAlign: TextAlign.center),
        scrollable: true,
        content: content(context, facEmail, firebaseStore),
      );
    },
  );
}

content(context, facEmail, Stream<QuerySnapshot<Map<String, dynamic>>> firebaseStore) {
  final size = MediaQuery.of(context).size;
  return SizedBox(
    height:size.height / 1.8,
    width:size.width,
    child: StreamBuilder(
      stream: firebaseStore,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return listView(snapshot, facEmail);
      },
    ),
  );
}

listView(snapshot, facEmail) {
  final validData = snapshot.data?.docs.where((d) => d["Faculty Email"] == facEmail).toList();
  return validData.length > 0
      ? ListView.builder(
          shrinkWrap: true,
          itemCount: validData?.length,
          itemBuilder: (context, index) {
            // Get Data From Snapshots................
            double result = int.parse(validData?[index]['Score']) /
                int.parse(validData?[index]['Total Questions']);
            String score = validData?[index]['Score'];
            String totalQues = validData?[index]['Total Questions'];
            String quizTitle = validData?[index]["Quiz Title"];

            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(quizTitle),
                  Text("Score : $score / $totalQues"),
                  Text(result >= 0.5 ? "Passed" : "Failed",
                      style: TextStyle(
                          color: result > 0.5 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w700,
                          fontSize: 18)),
                  Container(
                    height: 1,
                    color: Colors.black,
                  )
                ],
              ),
            );
          },
        )
      : Container(
          alignment: Alignment.center,
          child: Text(
            "Student has not Participated in Your Quiz yet.\nPlease, Check back Later.!",
            style: TextStyle(
                height: 1.5,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263300),
                overflow: TextOverflow.visible,
                wordSpacing: 2,
                letterSpacing: 0.4),
            textAlign: TextAlign.center,
          ));
}

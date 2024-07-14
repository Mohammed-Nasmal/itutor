import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'alertDialog/alertDialog.dart';

class ShowQuizDataCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;

  const ShowQuizDataCard(
      {Key? key, required this.snapshot, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var quizData = snapshot.docs[index];
    return InkWell(
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 20,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  quizData['Quiz Title'].toString(),
                  style: textStyle("title", context),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                child: Text(
                  quizData['Quiz Description'].toString(),
                  style: textStyle("desc", context),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        String? email = FirebaseAuth.instance.currentUser?.uid.toString();

        String quizTitle = snapshot.docs[index]['Quiz Title'];
        String quizDesc = snapshot.docs[index]['Quiz Description'];
        String difficulty = snapshot.docs[index]['Difficulty'];
        String totalQues = snapshot.docs[index]['Total Questions'].toString();

        var size = MediaQuery.of(context).size;

        // Get Snapshots of Questions........................
        var firestoreSnapshots = FirebaseFirestore.instance
            .collection("adminlogin")
            .doc(email)
            .collection("questions")
            .doc("${snapshot.docs[index].id}")
            .collection("${snapshot.docs[index].id}")
            .snapshots();

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              title: Container(
                padding: const EdgeInsets.all(10),
                width: size.width * 0.75,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        quizTitle,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        child: Text("Description: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600))),
                    Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(quizDesc,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400))),
                    Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("Difficulty : $difficulty",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600))),
                    Container(
                        child: Text("Total Questions : $totalQues",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600))),
                  ],
                ),
              ),
              content: SizedBox(
                height: size.height / 1.8,
                width: size.width,
                child: StreamBuilder(
                    stream: firestoreSnapshots,
                    builder: (context, snapshot2) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot2.data?.docs.length,
                        itemBuilder: (context, index2) {
                          if (!snapshot2.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          // Set snapshots in String.............................
                          String? quest = snapshot2
                              .data?.docs[index2]['Question']
                              .toString();
                          String? ans1 = snapshot2.data?.docs[index2]['Answer1']
                              .toString();
                          String? ans2 = snapshot2.data?.docs[index2]['Answer2']
                              .toString();
                          String? ans3 = snapshot2.data?.docs[index2]['Answer3']
                              .toString();
                          String? ans4 = snapshot2.data?.docs[index2]['Answer4']
                              .toString();

                          return Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Question #${index2 + 1}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                  "${quest == "null" ? "" : quest}",
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AnswerContainer(
                                        value:
                                            "A.) ${ans1 == "null" ? "" : ans1}"),
                                    AnswerContainer(
                                        value:
                                            "B.) ${ans2 == "null" ? "" : ans2}"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AnswerContainer(
                                        value:
                                            "C.) ${ans3 == "null" ? "" : ans3}"),
                                    AnswerContainer(
                                        value:
                                            "D.) ${ans4 == "null" ? "" : ans4}"),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
              ),
            );
          },
        );
      },
    );
  }

  TextStyle textStyle(String value, BuildContext context) {
    return TextStyle(
      fontSize: (value == "title") ? 24 : 16,
      color: (value == "title") ? Colors.blue.shade700 : Colors.black,
      fontWeight: (value == "title") ? FontWeight.w800 : FontWeight.w600,
      overflow: TextOverflow.visible,
    );
  }
}

class AnswerContainer extends StatelessWidget {
  final String value;

  const AnswerContainer({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Text(
          value,
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

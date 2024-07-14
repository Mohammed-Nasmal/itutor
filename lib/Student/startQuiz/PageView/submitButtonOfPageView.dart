import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/studentProviders/startQuizProvider.dart';
import '../../../providers/studentProviders/studentProvider.dart';
import '../../../providers/studentProviders/timerCountDownProvider.dart';
import '../resultScreen/mainPage.dart';

Widget submitButtonPageView(context, pageController, answers, snapshot, index) {
  String? userName = FirebaseAuth.instance.currentUser?.uid.toString();
  var firestore = FirebaseFirestore.instance
      .collection("register")
      .doc(userName)
      .collection("answers")
      .get();
  return Consumer3<StartQuizProvider, StudentProvider, TimerProvider>(
    builder: (context, quizProvider, studentProvider, timerProvider, child) {
      return Container(
        margin: EdgeInsets.only(top: 30,bottom: 30),
        child: ElevatedButton(
            style: buttonStyle(context),
            onPressed: () async {
              if (timerProvider.timer > 0) {
                // To check if Index value is greater than -1..... i.e. Answer Selected.................
                if (quizProvider.answerIndex >= 0) {
                  pageController.nextPage(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeIn);

                  // To check for Correct Answer............................................
                  if (answers[quizProvider.answerIndex] ==
                      snapshot.data?.docs[index]["Answer1"]) {
                    quizProvider.getTotalRight();
                  }
                  // Reset Index Value to -1 Once Tapped so that no item is selected...............
                  quizProvider.resetAnswerValue();

                  // IF Quiz is over............. i.e. all page index value matches length of snapshot..............
                  if (index + 1 == snapshot.data?.docs.length) {
                    int count = await firestore.then((value) => value.size);

                    Map<String, String> setValue = {
                      "Faculty Email": studentProvider.facultyEmail,
                      "Faculty Name": studentProvider.facultyName,
                      "Quiz Title": studentProvider.quizTitle,
                      "Score": quizProvider.totalRight.toString(),
                      "Total Questions": studentProvider.totalQuestions,
                      "Quiz Description": studentProvider.quizDesc,
                    };
                    FirebaseFirestore.instance
                        .collection("register")
                        .doc(userName)
                        .collection("answers")
                        .doc("${count + 1}")
                        .set(setValue);

                    timerProvider.cancelTimer();
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResultSummary()));
                  }
                }
              }
              // If timer has ended.........................................
              else {
                int count = await firestore.then((value) => value.size);

                Map<String, String> setValue = {
                  "Faculty Email": studentProvider.facultyEmail,
                  "Faculty Name": studentProvider.facultyName,
                  "Quiz Title": studentProvider.quizTitle,
                  "Score": quizProvider.totalRight.toString(),
                  "Total Questions": studentProvider.totalQuestions,
                  "Quiz Description": studentProvider.quizDesc,
                };
                FirebaseFirestore.instance
                    .collection("register")
                    .doc(userName)
                    .collection("answers")
                    .doc("${count + 1}")
                    .set(setValue);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ResultSummary()));
              }
            },
            child: Text(
              "Submit",
              style: TextStyle(fontSize: 20,color: Colors.white),
            )),
      );
    },
  );
}

buttonStyle(context) {
  return ButtonStyle(
      elevation: const MaterialStatePropertyAll(15),
      shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      backgroundColor: MaterialStatePropertyAll(Color(0xFF555553)),
      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(
          horizontal: 15, vertical: 10)));
}

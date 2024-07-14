import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/studentProviders/startQuizProvider.dart';
import '../../providers/studentProviders/studentProvider.dart';
import '../../providers/studentProviders/studentSnapshotProvider.dart';
import '../../providers/studentProviders/timerCountDownProvider.dart';
import 'PageView/contentOfPageView.dart';
import 'PageView/listViewofPageView.dart';
import 'PageView/submitButtonOfPageView.dart';
import 'resultScreen/mainPage.dart';

class StartQuiz extends StatefulWidget {
  const StartQuiz({Key? key}) : super(key: key);

  @override
  State<StartQuiz> createState() => _StartQuizState();
}

class _StartQuizState extends State<StartQuiz> {
  final PageController _pagecontroller = PageController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        //appBar: appBarSimpleWithoutBack(context, "Start Quiz"),
        body: Consumer<SnapshotProvider>(
          builder: (context, providerValue, child) {
            String? userName =
                FirebaseAuth.instance.currentUser?.uid.toString();
            var firestore = FirebaseFirestore.instance
                .collection("register")
                .doc(userName)
                .collection("answers")
                .get();
            return Container(
              alignment: Alignment.topCenter,
              child: StreamBuilder(
                  stream: providerValue.firestoreSnapshots,
                  builder: (context, snapshot) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Consumer<TimerProvider>(
                          builder: (context, timerProvider, child) {
                            int mins = timerProvider.timer ~/ 60;
                            int sec = (timerProvider.timer % 60).toInt();
                            return Container(
                                margin: const EdgeInsets.only(top: 50),
                                child: Text(
                                  timerProvider.timer > 0
                                      ? "${mins} min ${sec} sec left"
                                      : "Times Up",
                                  style: TextStyle(fontSize: 30),
                                ));
                          },
                        ),
                        Expanded(
                          child: PageView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _pagecontroller,
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              List answers = [];
                              answers
                                  .add(snapshot.data?.docs[index]["Answer1"]);
                              answers
                                  .add(snapshot.data?.docs[index]["Answer2"]);
                              answers
                                  .add(snapshot.data?.docs[index]["Answer3"]);
                              answers
                                  .add(snapshot.data?.docs[index]["Answer4"]);
                              answers.shuffle();
                              return SingleChildScrollView(
                                child: Container(
                                    margin: EdgeInsets.only(top: 50),
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.only(right: 20),
                                          child: Text(
                                              "Question ${index + 1}/${snapshot.data?.docs.length}",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.cyan),
                                              textAlign: TextAlign.right),
                                        ),
                                        Container(
                                          color: Colors.black,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 1,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 20),
                                          child: Text(
                                              "${snapshot.data?.docs[index]["Question"].toString() == "null" ? "" : snapshot.data?.docs[index]["Question"]}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.justify),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: 4,
                                              itemBuilder:
                                                  (context, itemIndex) {
                                                return Consumer<
                                                    StartQuizProvider>(
                                                  builder: (context,
                                                      providerValue, child) {
                                                    return InkWell(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: providerValue
                                                                        .answerIndex ==
                                                                    itemIndex
                                                                ? Colors.green
                                                                    .shade700
                                                                : Color(
                                                                    0xFF9393F4),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        padding:
                                                            EdgeInsets.all(20),
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                vertical: 10,
                                                                horizontal: 20),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                "${String.fromCharCode((65 + itemIndex))})."),
                                                            const SizedBox(
                                                                width: 8),
                                                            Expanded(
                                                                child: Text(
                                                              " ${answers[itemIndex].toString() == "null" ? "" : answers[itemIndex]}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ))
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        providerValue
                                                            .getAnswerID(
                                                                itemIndex);
                                                      },
                                                    );
                                                  },
                                                );
                                              }),
                                        ),
                                        Consumer3<StartQuizProvider,
                                            StudentProvider, TimerProvider>(
                                          builder: (context,
                                              quizProvider,
                                              studentProvider,
                                              timerProvider,
                                              child) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  top: 30, bottom: 30),
                                              child: ElevatedButton(
                                                  style: buttonStyle(context),
                                                  onPressed: () async {
                                                    if (timerProvider.timer >
                                                        0) {
                                                      // To check if Index value is greater than -1..... i.e. Answer Selected.................
                                                      if (quizProvider
                                                              .answerIndex >=
                                                          0) {
                                                        _pagecontroller.nextPage(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        800),
                                                            curve:
                                                                Curves.easeIn);

                                                        // To check for Correct Answer............................................
                                                        if (answers[quizProvider
                                                                .answerIndex] ==
                                                            snapshot.data?.docs[
                                                                    index]
                                                                ["Answer1"]) {
                                                          quizProvider
                                                              .getTotalRight();
                                                        }
                                                        // Reset Index Value to -1 Once Tapped so that no item is selected...............
                                                        quizProvider
                                                            .resetAnswerValue();

                                                        // IF Quiz is over............. i.e. all page index value matches length of snapshot..............
                                                        if (index + 1 ==
                                                            snapshot.data?.docs
                                                                .length) {
                                                          int count =
                                                              await firestore
                                                                  .then((value) =>
                                                                      value
                                                                          .size);

                                                          Map<String, String>
                                                              setValue = {
                                                            "Faculty Email":
                                                                studentProvider
                                                                    .facultyEmail,
                                                            "Faculty Name":
                                                                studentProvider
                                                                    .facultyName,
                                                            "Quiz Title":
                                                                studentProvider
                                                                    .quizTitle,
                                                            "Score":
                                                                quizProvider
                                                                    .totalRight
                                                                    .toString(),
                                                            "Total Questions":
                                                                studentProvider
                                                                    .totalQuestions,
                                                            "Quiz Description":
                                                                studentProvider
                                                                    .quizDesc,
                                                          };
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "register")
                                                              .doc(userName)
                                                              .collection(
                                                                  "answers")
                                                              .doc(
                                                                  "${count + 1}")
                                                              .set(setValue);

                                                          timerProvider
                                                              .cancelTimer();
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const ResultSummary()));
                                                        }
                                                      }
                                                    }
                                                    // If timer has ended.........................................
                                                    else {
                                                      int count =
                                                          await firestore.then(
                                                              (value) =>
                                                                  value.size);

                                                      Map<String, String>
                                                          setValue = {
                                                        "Faculty Email":
                                                            studentProvider
                                                                .facultyEmail,
                                                        "Faculty Name":
                                                            studentProvider
                                                                .facultyName,
                                                        "Quiz Title":
                                                            studentProvider
                                                                .quizTitle,
                                                        "Score": quizProvider
                                                            .totalRight
                                                            .toString(),
                                                        "Total Questions":
                                                            studentProvider
                                                                .totalQuestions,
                                                        "Quiz Description":
                                                            studentProvider
                                                                .quizDesc,
                                                      };
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "register")
                                                          .doc(userName)
                                                          .collection("answers")
                                                          .doc("${count + 1}")
                                                          .set(setValue);
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const ResultSummary()));
                                                    }
                                                  },
                                                  child: Text(
                                                    "Submit",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  )),
                                            );
                                          },
                                        ),
                                      ],
                                    )),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }),
            );
          },
        ),
      ),
    );
  }
}

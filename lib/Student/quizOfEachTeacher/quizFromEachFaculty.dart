import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itutor1/providers/studentProviders/timerCountDownProvider.dart';
import 'package:provider/provider.dart';

import '../../providers/studentProviders/startQuizProvider.dart';
import '../../providers/studentProviders/studentProvider.dart';
import '../../providers/studentProviders/studentSnapshotProvider.dart';
import '../startQuiz/mainPage.dart';
import 'showQuizForStudent.dart';

class QuizFromEachFaculty extends StatefulWidget {
  final String department;
  const QuizFromEachFaculty({Key? key, required this.department})
      : super(key: key);

  @override
  State<QuizFromEachFaculty> createState() => _QuizFromEachFacultyState();
}

class _QuizFromEachFacultyState extends State<QuizFromEachFaculty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StudentProvider>(
        builder: (context, providerValue, child) {
          print(widget.department);
          // Firebase Snapshot......................
          var firestoreSnapshots = FirebaseFirestore.instance
              .collectionGroup("questions")
              .where("Department", isEqualTo: widget.department)
              .get();

          return Container(
            alignment: Alignment.topCenter,
            child: FutureBuilder(
              future: firestoreSnapshots,
              builder: (context, snapshot) {
                print(snapshot.error);
                if (snapshot.data != null)
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Card(
                          margin: const EdgeInsets.all(10),
                          color: Colors.white,
                          elevation: 20,
                          child: Column(
                            children: [
                              textDisplay(
                                  snapshot.data!.docs[index]['Quiz Title']
                                      .toString(),
                                  "title",
                                  context),
                              textDisplay(
                                  snapshot.data!.docs[index]['Quiz Description']
                                      .toString(),
                                  "desc",
                                  context),
                              textDisplay(
                                  snapshot.data!.docs[index]['Difficulty']
                                      .toString(),
                                  "diff",
                                  context),
                              textDisplay(
                                  snapshot.data!.docs[index]['Total Questions']
                                      .toString(),
                                  "total",
                                  context),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Consumer<StudentProvider>(
                                  builder: (context, providerValue, child) {
                                    return ElevatedButton(
                                        onPressed: () async {
                                          providerValue.getDifficultyLevel(
                                              snapshot.data!
                                                  .docs[index]['Difficulty']
                                                  .toString());
                                          providerValue.getTotalQuestions(
                                              snapshot
                                                  .data!
                                                  .docs[index]
                                                      ['Total Questions']
                                                  .toString());
                                          providerValue.getQuizTitle(snapshot
                                              .data!.docs[index]['Quiz Title']
                                              .toString());
                                          providerValue.getQuizDescription(
                                              snapshot
                                                  .data!
                                                  .docs[index]
                                                      ['Quiz Description']
                                                  .toString());
                                          providerValue.setFacultyEmail(snapshot
                                              .data!.docs[index]['uid']
                                              .toString());
                                          providerValue.getQuizID(snapshot
                                              .data!.docs[index].id
                                              .toString());
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return SizedBox(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: AlertDialog(
                                                    elevation: 20,
                                                    scrollable: true,
                                                    alignment: Alignment.center,
                                                    actionsPadding:
                                                        EdgeInsets.only(
                                                            right: 30,
                                                            bottom: 20,
                                                            top: 10),
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 30,
                                                            horizontal: 30),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    title: Text("Instructions",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 22)),
                                                    content: Consumer<
                                                            StudentProvider>(
                                                        builder: (context,
                                                            providerValue,
                                                            child) {
                                                      return Text(
                                                          "\u2022 Welcome to Online ${providerValue.quizTitle} \n\u2022 Exam has Total ${providerValue.totalQuestions} Questions.\n\u2022 Total Time for the Exam is ${int.parse(providerValue.totalQuestions)} Minutes \n\u2022 Negative Marking : No \n\u2022 Each Question is Compulsory to Attend \n\u2022 You Can't Navigate back to previous Question.",
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              wordSpacing: 1,
                                                              height: 1.5,
                                                              fontSize: 15));
                                                    }),
                                                    actions: [
                                                      Consumer4<
                                                          StartQuizProvider,
                                                          StudentProvider,
                                                          TimerProvider,
                                                          SnapshotProvider>(
                                                        builder: (context,
                                                            startQuizProvider,
                                                            studentProvider,
                                                            timerProvider,
                                                            snapshotProvider,
                                                            child) {
                                                          return ElevatedButton(
                                                              onPressed: () {
                                                                startQuizProvider
                                                                    .resetAnswerValue();
                                                                startQuizProvider
                                                                    .resetTotalCorrectAns();
                                                                int time = int.parse(
                                                                        studentProvider
                                                                            .totalQuestions) *
                                                                    1 *
                                                                    60;
                                                                timerProvider
                                                                    .setTimerData(
                                                                        time);

                                                                var firestoreSnapshots = FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "adminlogin")
                                                                    .doc(studentProvider
                                                                        .facultyEmail)
                                                                    .collection(
                                                                        "questions")
                                                                    .doc(studentProvider
                                                                        .quizID)
                                                                    .collection(
                                                                        studentProvider
                                                                            .quizID)
                                                                    .snapshots();

                                                                snapshotProvider
                                                                    .setfirestoreSnapshots(
                                                                        firestoreSnapshots);
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                                timerProvider
                                                                    .startTimer();
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const StartQuiz()));
                                                              },
                                                              style: const ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStatePropertyAll(
                                                                          Colors
                                                                              .green),
                                                                  foregroundColor:
                                                                      MaterialStatePropertyAll(
                                                                          Colors
                                                                              .white)),
                                                              child: const Text(
                                                                  "Start Test"));
                                                        },
                                                      )
                                                    ],
                                                  ));
                                            },
                                          );
                                        },
                                        child: Text("Attempt Quiz"));
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  );
                return const Center(child: CircularProgressIndicator());
              },
            ),
          );
        },
      ),
    );
  }

  Text textNoQuizAvailable() {
    return Text(
      "This Faculty has no Quiz to Show.\n Kindly check back later.!",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Color(0xFF263300),
          overflow: TextOverflow.visible,
          wordSpacing: 2,
          letterSpacing: 0.4),
    );
  }
}

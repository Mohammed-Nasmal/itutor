import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/createQuizProvider.dart';
import 'alertDialogAddQuestions/dialogAddQuestion.dart';
import 'listView.dart';
import 'submitQuizButton.dart';
import 'textFieldWidgets.dart';
import 'toggleButtonForDifficultyLevel.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({Key? key}) : super(key: key);

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Quiz"),
        actions: [
          Container(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Consumer<CreateQuizProvider>(
                        builder: (context, providerValue, child) {
                          return Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: AlertDialog(
                                scrollable: true,
                                elevation: 10,
                                alignment: Alignment.center,
                                contentPadding: const EdgeInsets.all(20),
                                actionsAlignment: MainAxisAlignment.center,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: const Center(child: Text("Question")),
                                content: SingleChildScrollView(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          decoration: InputDecoration(
                                              label: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child:
                                                      const Text("Question"))),
                                          minLines: 2,
                                          maxLines: 2,
                                          expands: false,
                                          onChanged: (value) {
                                            providerValue
                                                .getQuestionInfo(value);
                                          },
                                        ),
                                        Container(
                                          height: 30,
                                        ),
                                        TextFormField(
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            decoration: const InputDecoration(
                                                labelText:
                                                    "Option 1 (Correct Answer)",
                                                labelStyle: TextStyle(
                                                    color: Colors.green)),
                                            onChanged: (value) => providerValue
                                                .getOption1(value)),
                                        TextFormField(
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            decoration: const InputDecoration(
                                                labelText: "Option 2",
                                                labelStyle: TextStyle(
                                                    color: Colors.redAccent)),
                                            onChanged: (value) => providerValue
                                                .getOption2(value)),
                                        TextFormField(
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            decoration: const InputDecoration(
                                                labelText: "Option 3",
                                                labelStyle: TextStyle(
                                                    color: Colors.redAccent)),
                                            onChanged: (value) => providerValue
                                                .getOption3(value)),
                                        TextFormField(
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            decoration: const InputDecoration(
                                                labelText: "Option 4",
                                                labelStyle: TextStyle(
                                                    color: Colors.redAccent)),
                                            onChanged: (value) => providerValue
                                                .getOption4(value)),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  SingleChildScrollView(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("Cancel")),
                                          ElevatedButton(
                                              onPressed: () {
                                                if (providerValue
                                                            .questionInfo !=
                                                        "" &&
                                                    providerValue.option1 !=
                                                        "" &&
                                                    providerValue.option2 !=
                                                        "" &&
                                                    providerValue.option3 !=
                                                        "" &&
                                                    providerValue.option4 !=
                                                        "") {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  providerValue.setDataToList();
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Text("Submit")),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: const Icon(Icons.add, color: Colors.black, size: 35),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Consumer<CreateQuizProvider>(
            builder: (context, providerValue, child) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: SizedBox(
                        width: size.width,
                        child: Column(
                          children: [
                            TextFormField(
                                textCapitalization: TextCapitalization.words,
                                onChanged: (value) {
                                  providerValue.getQuizTitle(value);
                                },
                                decoration: const InputDecoration(
                                    labelText: "Quiz Title")),
                            TextFormField(
                              textCapitalization: TextCapitalization.words,
                              onChanged: (value) {
                                providerValue.getQuizDesc(value);
                              },
                              decoration: const InputDecoration(
                                  labelText: "Quiz Description"),
                              maxLines: 3,
                              minLines: 3,
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 10, bottom: 20),
                                padding:
                                    const EdgeInsets.only(top: 10, right: 10),
                                child: Consumer<CreateQuizProvider>(
                                  builder: (context, providerValue, child) {
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Radio(
                                                activeColor: Colors.cyan,
                                                value: 0,
                                                groupValue: providerValue
                                                    .radioForQuizDifficulty,
                                                onChanged: (changedValue) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  providerValue
                                                      .getQuizDifficulty(
                                                          changedValue);
                                                },
                                              ),
                                              Text("Easy",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black))
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                activeColor: Colors.cyan,
                                                value: 1,
                                                groupValue: providerValue
                                                    .radioForQuizDifficulty,
                                                onChanged: (changedValue) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  providerValue
                                                      .getQuizDifficulty(
                                                          changedValue);
                                                },
                                              ),
                                              Text("Medium",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black))
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Radio(
                                                activeColor: Colors.cyan,
                                                value: 2,
                                                groupValue: providerValue
                                                    .radioForQuizDifficulty,
                                                onChanged: (changedValue) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  providerValue
                                                      .getQuizDifficulty(
                                                          changedValue);
                                                },
                                              ),
                                              Text("Difficult",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black))
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )),
                          ],
                        ),
                      ),
                    ),
                    ListViewQuestions(),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Consumer<CreateQuizProvider>(
                            builder: (context, providerValue, child) {
                              return ElevatedButton(
                                  onPressed: () async {
                                    // Get email of current logged in user..............................
                                    String? email = FirebaseAuth
                                        .instance.currentUser?.uid
                                        .toString();

                                    var teacher = await FirebaseFirestore
                                        .instance
                                        .collection("adminlogin")
                                        .doc(email)
                                        .get();

                                    //Count Docs Size in Collection......................................
                                    int getDocsCount = await FirebaseFirestore
                                        .instance
                                        .collection("adminlogin")
                                        .doc(email)
                                        .collection("questions")
                                        .get()
                                        .then((value) => value.size);
                                    int i = 0;
                                    int a = 101;

                                    // Check the list value, quiz title and Quiz Description if not empty.............
                                    if (providerValue.list.isNotEmpty &&
                                        providerValue.quizTitle != "" &&
                                        providerValue.quizDesc != "") {
                                      // Set Quiz Description and Quiz Title to the Firebase Database.....................
                                      await FirebaseFirestore.instance
                                          .collection("adminlogin")
                                          .doc(email)
                                          .collection("questions")
                                          .doc("${a + getDocsCount}")
                                          .set({
                                        "Quiz Title": providerValue.quizTitle,
                                        "Quiz Description":
                                            providerValue.quizDesc,
                                        "Total Questions":
                                            providerValue.list.length,
                                        "uid": email,
                                        "Department": teacher.get("Department"),
                                        "Difficulty": providerValue
                                            .stringForQuizDifficulty
                                      });

                                      await FirebaseFirestore.instance
                                          .collection("adminlogin")
                                          .doc(email)
                                          .update({
                                        "attempt": getDocsCount + 1,
                                      });

                                      // Set each Element from list to the Firebase Database.....................
                                      for (var element in providerValue.list) {
                                        i++;
                                        await FirebaseFirestore.instance
                                            .collection("adminlogin")
                                            .doc(email)
                                            .collection("questions")
                                            .doc("${a + getDocsCount}")
                                            .collection("${a + getDocsCount}")
                                            .doc("$i")
                                            .set(element);
                                      }
                                      // Clear the value of list, Quiz Desc and Quiz Title...............
                                      providerValue.clearProviderValue();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    "Submit Quiz",
                                    style: TextStyle(fontSize: 16),
                                  ));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'quizDataCard.dart';

class ShowQuiz extends StatelessWidget {
  const ShowQuiz({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? email = FirebaseAuth.instance.currentUser?.uid.toString();
    Stream<QuerySnapshot> firestoreSnapshots = FirebaseFirestore.instance
        .collection("adminlogin")
        .doc(email)
        .collection("questions")
        .snapshots();

    return Container(
      alignment: Alignment.topCenter,
      child: StreamBuilder<QuerySnapshot>(
        stream: firestoreSnapshots,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Container(
                alignment: Alignment.center,
                child: Text(
                  "You have not Created a Quiz\n Create one to Display Here!",
                  style: TextStyle(
                      height: 1.5,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263300),
                      overflow: TextOverflow.visible,
                      wordSpacing: 2,
                      letterSpacing: 0.4),
                  textAlign: TextAlign.center,
                ));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var quizData = snapshot.data?.docs[index];
                return SizedBox(
                  child: QuizDataCard(
                    quizData: quizData,
                    quizData2: snapshot.data,
                    index: index,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class QuizDataCard extends StatelessWidget {
  final QueryDocumentSnapshot? quizData;
  final QuerySnapshot? quizData2;

  final int index;

  const QuizDataCard(
      {Key? key, this.quizData, this.quizData2, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (quizData == null) {
      return const Center(child: Text('No Data Available'));
    }
    // Assuming showQuizData(context, snapshot, index) returns a widget that
    // uses quizData to build its UI. Replace this with the actual implementation.
    return ShowQuizDataCard(snapshot: quizData2!, index: index);
  }
}

// Ensure that showQuizData is a function that returns a Widget and
// properly utilizes the quizData parameter.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'checkScoreList.dart';

class StudentResult extends StatefulWidget {
  final String department;
  const StudentResult({Key? key,required this.department}) : super(key: key);

  @override
  State<StudentResult> createState() => _StudentResultState();
}

class _StudentResultState extends State<StudentResult> {
  @override
  Widget build(BuildContext context) {
    var firestore = FirebaseFirestore.instance.collection("register").where("Department",isEqualTo: widget.department).snapshots();

    return Scaffold(
        appBar:AppBar(title: Text("Scores"),),

        body: Center(
          child: SizedBox(
            child: Center(
              child: StreamBuilder(
                stream: firestore,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if ((snapshot.data?.docs.length).toString() == "null" ||
                      (snapshot.data?.docs.length).toString() == "0") {
                    return Container(
                        alignment: Alignment.center,
                        child: Text(
                          "No Candidate to Display !",
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
                    final validData = snapshot.data?.docs
                        .toList();
                    return  ListView.builder(
                            itemCount: validData?.length,
                            itemBuilder: (context, index) {
                              return checkScoreList(validData, context, index);
                            },
                          );
                      
                  }
                },
              ),
            ),
          ),
        ));
  }
}

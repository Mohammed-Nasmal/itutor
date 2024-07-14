import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'dialogBoxResult.dart';

Widget checkScoreList(List<QueryDocumentSnapshot<Map<String, dynamic>>>? snapshot, context, index) {
  // Get Data From Snapshots...................................
  String? docID = snapshot?[index].id;
   // Get Data From Snapshots
  
  // Check if "FullName" exists
  String? studName =  (snapshot![index].data()).containsKey("Fullname") ?  snapshot[index]["Fullname"] as String?:"";
  
  // Check if "Department" exists
  String about = (snapshot![index].data()).containsKey("Department")
      ? snapshot[index]["Department"] as String
      : "";

  // Now you can use docID, studName, and about variables as needed
  return InkWell(
    child: Card(
      elevation: 18,
      shape: cardShape(),
      margin: cardMargin(context),
      child: SingleChildScrollView(
        child: Container(
          padding: containerPadding(context),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              studentName(context, studName),
              aboutStudent(context, about),
              // studentQualification(context, qualification),
            ],
          ),
        ),
      ),
    ),
    onTap: () {
      dialogBoxResult(context, docID, studName!);
    },
  );
}

containerPadding(context) {
  return EdgeInsets.symmetric(vertical: 20, horizontal: 10);
}

cardMargin(context) {
  return EdgeInsets.symmetric(horizontal: 20, vertical: 10);
}

cardShape() {
  return const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)));
}

studentQualification(context, String qualification) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Qualification :",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      Text(qualification,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    ],
  );
}

aboutStudent(context, String about) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: Text(about,
        style: TextStyle(fontSize: 16), textAlign: TextAlign.center),
  );
}

studentName(context, String? studName) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    child: Text(studName!,
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
  );
}

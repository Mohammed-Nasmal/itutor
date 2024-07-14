import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/provider.dart';
import '../createQuiz/mainScreen.dart';

class CreateQuizFloatingActionButton extends StatelessWidget {
  const CreateQuizFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 1)),
      width: 100,
      height: 45,
      child: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        elevation: 20,
        isExtended: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateQuiz(),
              ));
          // if (providerValue.experience == "" ||
          //     providerValue.qualification == "" ||
          //     providerValue.about == "") {
          //   showDialog(
          //     context: context,
          //     builder: (context) {
          //       return AlertDialog(
          //         title: const Text("Alert",
          //             style: TextStyle(
          //                 color: Colors.red,
          //                 fontSize: 25,
          //                 fontWeight: FontWeight.bold)),
          //         elevation: 20,
          //         content: const Text(
          //             "Kindly Update Profile Section to Create Quiz"),
          //         actions: [
          //           TextButton(
          //               onPressed: () {
          //                 Navigator.pop(context);
          //               },
          //               child: const Text(
          //                 "Cancel",
          //                 style: TextStyle(fontSize: 15),
          //               )),
          //           TextButton(
          //               onPressed: () {
          //                 Navigator.pop(context);
          //                 // Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage(),));

          //               },
          //               child: const Text(
          //                 "Update",
          //                 style: TextStyle(fontSize: 15),
          //               ))
          //         ],
          //       );
          //     },
          //   );
          // } else {

          // }
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add),
              Text("Create",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class FloatingButtonCreate extends StatelessWidget {
  const FloatingButtonCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 1)),
      width: 100,
      height: 45,
      child: Consumer<ProfilePageProvider>(
        builder: (context, providerValue, child) {
          return FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            elevation: 20,
            isExtended: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateQuiz(),
                  ));
            },
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  Text("Create",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

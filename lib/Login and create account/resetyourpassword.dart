import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class reset_pass extends StatefulWidget {
  const reset_pass({super.key});

  @override
  State<reset_pass> createState() => _reset_passState();
}

class _reset_passState extends State<reset_pass> {
  TextEditingController email = TextEditingController();
  void forgotpassword(BuildContext context) async {
    try {
      if (email.text.isEmpty) {
        throw Exception("Email must not be empty");
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password reset email sent to your email")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/resetyourpass.png'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      elevation: 1,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.grey,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(width: 1, color: Colors.grey),
                      ),
                      backgroundColor: Colors.transparent.withOpacity(0),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Email Address'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: TextField(
                        controller: email,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.black38),
                          hintText: "Enter your email address",
                          focusColor: Colors.black38,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                    ),
                    SizedBox(
                      height: 50,
                      width: 350,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (ctx) {
                          //       return const logintoacc();
                          //     },
                          //   ),
                          // );
                          forgotpassword(context);
                        },
                        child: const Text(
                          "Reset request",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

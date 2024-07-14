import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itutor1/Login%20and%20create%20account/resetyourpassword.dart';
import 'package:shared_preferences/shared_preferences.dart';

class logintoacc extends StatefulWidget {
  const logintoacc({super.key});

  @override
  State<logintoacc> createState() => _logintoaccState();
}

class _logintoaccState extends State<logintoacc> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  void submit(BuildContext context) async {
    try {
      var user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.text, password: pass.text);

      if (user.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Login Failed",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 63, 63, 63),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        var doc = await FirebaseFirestore.instance
            .collection("register")
            .doc(user.user!.uid)
            .get();
        if (doc.exists) {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

          await sharedPreferences.setInt("type", 1);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Login Successful",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pushNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Login Failed',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login Failed',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  bool _obscureText = true;
  bool checkBoxValue = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/logintoacc.png'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton.small(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        elevation: 0,
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Colors.white,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: const Text('Email Address'),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: const Text('Password'),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: TextField(
                          controller: pass,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.black38),
                            hintText: "Enter your password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Checkbox(
                            splashRadius: 3,
                            shape: const CircleBorder(),
                            value: checkBoxValue,
                            onChanged: (bool? newValue) {
                              setState(
                                () {
                                  checkBoxValue = newValue!;
                                },
                              );
                            },
                          ),
                          const Text(
                            'Remember me',
                            style: TextStyle(color: Colors.black38),
                          ),
                          const SizedBox(
                            width: 90,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) {
                                    return const reset_pass();
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
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
                                submit(context);
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('or login with'),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.apple),
                                color: Colors.black,
                                iconSize: 60,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.facebook),
                                color: Colors.blue,
                                iconSize: 50,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.mail_sharp),
                                color: Colors.red,
                                iconSize: 50,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

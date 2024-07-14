import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Createnewacc extends StatefulWidget {
  const Createnewacc({super.key});

  @override
  State<Createnewacc> createState() => _CreatenewaccState();
}

final Department = [
  'B.Voc Digital Film Production',
  'B.Voc Fish Processing Technology',
  'B.Voc Logistics Management',
  'B.Voc Tourism Hospitality Management',
  'BA Economics',
  'BA English Language and Literature',
  'BA Mass Communication',
  'B.Com CA',
  'B.Com Cooperation',
  'B.Com Finance',
  'BCA',
  'B.Sc Aquaculture',
  'B.Sc Botany',
  'B.Sc Mathematics',
  'B.Sc Physics',
  'B.Sc Psychology',
];
String? selectDepartment;

final Role = ['Student', 'Teacher'];
String? selectRole;

class _CreatenewaccState extends State<Createnewacc> {
  TextEditingController Con = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Dep = TextEditingController();

  TextEditingController Password = TextEditingController();
  void submit() async {
    try {
      if (Password.text != Con.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password and Confirm Password do not match"),
          ),
        );
        return;
      }
      var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: Email.text, password: Password.text);

      if (user.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration Failed"),
          ),
        );
      }
      // if (Password != Con) {
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text("Registration failed"),
      //   ));
      // }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration Successful"),
          ),
        );
        Navigator.pushNamed(context, '/login');
      }
      final DocumentReference reg =
          FirebaseFirestore.instance.collection('register').doc(user.user?.uid);

      var reslt = await reg.get();
      if (reslt.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User aldready exist,Please login!'),
          ),
        );
      }

      final data = {
        // 'Confirm': Con.text,
        'Department': selectDepartment,
        'Email': Email.text,
        'Password': Password.text,
        'uid': user.user?.uid,
      };
      reg.set(data);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
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
            image: AssetImage('assets/images/createnewacc.png'),
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
                        height: 11,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: const Text(
                          'Email Address',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 4, 5, 4),
                        child: TextField(
                          controller: Email,
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
                        child: const Text(
                          'Password',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 4, 5, 4),
                        child: TextField(
                          controller: Password,
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
                                setState(
                                  () {
                                    _obscureText = !_obscureText;
                                  },
                                );
                              },
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: const Text(
                          'Confirm your password',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 4, 5, 4),
                        child: TextField(
                          controller: Con,
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
                                setState(
                                  () {
                                    _obscureText = !_obscureText;
                                  },
                                );
                              },
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: const Text(
                          'Department name',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(1, 2, 2, 1),
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.black38),
                            hintText: "Select your derpartment",
                            border: OutlineInputBorder(),
                          ),
                          items: Department.map(
                            (e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ),
                          ).toList(),
                          onChanged: (val) {
                            selectDepartment = val;
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      //   child: const Text(
                      //     'User Role',
                      //     style: TextStyle(fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(1, 2, 2, 1),
                      //   child: DropdownButtonFormField(
                      //     decoration: InputDecoration(
                      //       hintStyle: TextStyle(color: Colors.black38),
                      //       hintText: "Select your role",
                      //       border: OutlineInputBorder(),
                      //     ),
                      //     items: Role.map(
                      //       (e) => DropdownMenuItem(
                      //         child: Text(e),
                      //         value: e,
                      //       ),
                      //     ).toList(),
                      //     onChanged: (val) {
                      //       selectRole = val;
                      //     },
                      //   ),
                      // ),
                      Row(
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
                          const Text('I agree to itutor'),
                          // const SizedBox(
                          //   width: 3,
                          // ),
                          const Text(
                            'License Agreement,Terms&',
                            style: TextStyle(color: Colors.blue),
                          ),
                          const Text(
                            'Policy',
                            style: TextStyle(color: Colors.blue),
                          )
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
                              
                                submit();
                              },
                              child: const Text(
                                "Register Now",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          Text('or login with'),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.apple),
                                color: Colors.black,
                                iconSize: 30,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.facebook),
                                color: Colors.blue,
                                iconSize: 30,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.mail_sharp),
                                color: Colors.red,
                                iconSize: 30,
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   height: 20,
                          // ),
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

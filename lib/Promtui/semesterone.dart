import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class semesterone extends StatefulWidget {
  final int sem;
  const semesterone({super.key, required this.sem});

  @override
  State<semesterone> createState() => _semesteroneState();
}

class _semesteroneState extends State<semesterone> {
  String? depart;

  init() async {
    String collection = "adminlogin";
    int type = (await SharedPreferences.getInstance()).getInt("type")!;
    if (type == 1) {
      collection = "register";
    }
    depart = (await FirebaseFirestore.instance
            .collection(collection)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get())
        .data()!['Department'];
    setState(() {});
  }

  Future<Map<String, String?>?> uploadPdf() async {
    // Let the user select a PDF file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      try {
        // Create a reference to the location you want to upload to in Firebase Storage
        Reference storageReference =
            FirebaseStorage.instance.ref().child('pdfs/${file.name}');

        // Upload the file to Firebase Storage
        await storageReference.putFile(File(file.path!));

        // Success!
        print('File uploaded');
        return {
          "url": await storageReference.getDownloadURL(),
          "name": file.name
        };
      } catch (e) {
        // If any error occurs
        print(e);
        return null;
      }
    } else {
      // User canceled the picker
      return null;
    }
  }

  uploadFile(BuildContext context) async {
    dynamic pdfUrl = await uploadPdf();
    if (pdfUrl != null) {
      await FirebaseFirestore.instance.collection('notes').add({
        'title': pdfUrl['name'],
        'description': "",
        'Department': depart,
        'sem': widget.sem,
        'pdfUrl': pdfUrl['url'],
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Note Added')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to upload PDF')));
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg1.png'), fit: BoxFit.cover),
          ),
          child: ListView(
            children: [
              SizedBox(
                height: 40,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromRGBO(239, 240, 242, 1),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          FloatingActionButton.small(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            elevation: 0,
                            child: Icon(
                              Icons.arrow_back_ios_outlined,
                              color: Colors.black,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(width: 1, color: Colors.grey),
                            ),
                            backgroundColor: Colors.transparent.withOpacity(0),
                          ),
                          SizedBox(
                            width: 85,
                          ),
                          Text(
                            'Semester ${widget.sem}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (depart != null)
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("notes")
                            .where('Department', isEqualTo: depart)
                            .where("sem", isEqualTo: widget.sem)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.size,
                                itemBuilder: (ctx, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.description_rounded,
                                              size: 40,
                                              color: Colors.yellow,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      .data()['title']??"Note",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return SfPdfViewer.network(
                                                        snapshot
                                                            .data!.docs[index]
                                                            .data()['pdfUrl']);
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.link,
                                                color: Colors.indigoAccent,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                String url = snapshot
                                                    .data!.docs[index]
                                                    .data()['pdfUrl'];
                                                try {
                                                  launchUrl(Uri.parse(url));
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Cannot download")));
                                                }
                                              },
                                              icon: Icon(
                                                Icons.download,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }
                          return SizedBox();
                        },
                      ),
                    SizedBox(
                      height: 30,
                    ),
                    FutureBuilder<SharedPreferences>(
                        future: SharedPreferences.getInstance(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.getInt("type") == 0)
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(360),
                                          color: Colors.blue),
                                      child: IconButton(
                                        onPressed: () {
                                          uploadFile(context);
                                        },
                                        icon: Icon(
                                          Icons.cloud_upload_sharp,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    Text('Upload File'),
                                  ],
                                ),
                              ],
                            );
                          return SizedBox();
                        }),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

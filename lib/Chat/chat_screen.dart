import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'chat_widget.dart';

class Chat extends StatelessWidget {
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String currentUserId;
  final int type;
  static const String id = "chat";

  Chat(
      {Key? key,
      required this.currentUserId,
      required this.peerId,
      required this.peerAvatar,
      required this.type,
      required this.peerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        title: Text(peerName),
        backgroundColor: Colors.white,
      ),
      body: new _ChatScreen(
        currentUserId: currentUserId,
        peerId: peerId,
        peerAvatar: peerAvatar,
        type:type,
      ),
    );
  }
}

class _ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String currentUserId;
    final int type;


  _ChatScreen(
      {Key? key,
      required this.peerId,
      required this.peerAvatar,
      required this.type,
      required this.currentUserId})
      : super(key: key);

  @override
  State createState() => new _ChatScreenState();
}

class _ChatScreenState extends State<_ChatScreen> {
  String? peerId;
  String? peerAvatar;
  String? id;

  var listMessage;
  String? groupChatId;

  File? imageFile;
  bool? isLoading;
  bool? isShowSticker;
  String? imageUrl;
  var stCollection = 'messages';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    id = widget.currentUserId;
    peerId = widget.peerId;
    peerAvatar = widget.peerAvatar;

    groupChatId = '';
    

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

    readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    id = widget.currentUserId ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }


    FirebaseFirestore.instance
        .collection(widget.type == 0 ?'adminlogin' : 'register')
        .doc(id)
        .update({'chattingWith': peerId});

    setState(() {});
  }

  Future getImage(int index) async {
    XFile? selectedFile;

    if (kIsWeb) {
      //selectedFile=await ImagePicker.platform.pickImage(source: ImageSource.gallery);
      selectedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    } else {
      if (index == 0)
        selectedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
      else
        selectedFile =
            await ImagePicker().pickImage(source: ImageSource.camera);

      //imageFile =File(selectedFile.path);
    }

    if (selectedFile != null) {
      setState(() {
        //orFile=selectedFile;
        isLoading = true;
      });
      uploadFile(selectedFile);
    }
  }

  Future uploadFile(XFile orFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref().child(fileName);

    try {
      firebase_storage.UploadTask uploadTask;

      final metadata = firebase_storage.SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': orFile.path});

      if (kIsWeb)
        uploadTask = reference.putData(await orFile.readAsBytes(), metadata);
      else
        uploadTask = reference.putData(await orFile.readAsBytes());

      firebase_storage.TaskSnapshot storageTaskSnapshot = await uploadTask;

      storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
        imageUrl = downloadUrl;
        setState(() {
          isLoading = false;
          onSendMessage(imageUrl!, 1);
        });
      }, onError: (err) {
        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId!)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              ChatWidget.widgetChatBuildListMessage(
                  groupChatId,
                  listMessage,
                  widget.currentUserId,
                  peerAvatar,
                  listScrollController,
                  stCollection),

              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading!
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepPurple)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          // Material(
          //   child: new Container(
          //     margin: new EdgeInsets.symmetric(horizontal: 1.0),
          //     child: new IconButton(
          //       icon: new Icon(Icons.image),
          //       onPressed: () => getImage(0),
          //       color: Colors.deepPurple,
          //     ),
          //   ),
          //   color: Colors.white,
          // ),
          // Visibility(
          //   visible: !kIsWeb,
          //   child: Material(
          //     child: new Container(
          //       margin: new EdgeInsets.symmetric(horizontal: 1.0),
          //       child: new IconButton(
          //         icon: new Icon(Icons.camera_alt),
          //         onPressed: () => getImage(1),
          //         color: Colors.deepPurple,
          //       ),
          //     ),
          //     color: Colors.white,
          //   ),
          // ),
          // Edit text
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: TextField(
                style: TextStyle(color: Colors.deepPurple, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Colors.deepPurple,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(color: Colors.grey.shade600, width: 0.5)),
          color: Colors.white),
    );
  }
}

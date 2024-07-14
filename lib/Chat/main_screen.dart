import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:itutor1/Chat/chatDB.dart';
import 'package:itutor1/Chat/chatData.dart';

import 'chat_screen.dart';
import 'chat_widget.dart';

List<dynamic> friendList = [];

class DashboardScreen extends StatefulWidget {
  static const String id = "dashboard_screen";
  final String currentUserId;
  final int type;

  DashboardScreen({Key? key, required this.currentUserId, required this.type})
      : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<StreamSubscription> unreadSubscriptions = [];
  List<StreamController> controllers = [];

  bool isLoading = false;
  bool addNewFriend = false;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  final friendController = TextEditingController();

  late Stream<QuerySnapshot> _streamFriendList;

  @override
  void initState() {
    super.initState();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFriendList(bool onLoad) async {
    var user = (await FirebaseFirestore.instance
            .collection(widget.type == 0 ? 'adminlogin' : 'register')
            .doc(widget.currentUserId)
            .get())
        .data();
    return await FirebaseFirestore.instance
        .collection(widget.type == 0 ? 'register' : 'adminlogin')
        .where("Department", isEqualTo: user!['Department'])
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chats"),
        ),
        backgroundColor: Colors.white,
        body: showFriendList(widget.currentUserId),
      ),
    );
  }

  Future<bool> onBackPress() {
    ChatData.openDialog(context);
    return Future.value(false);
  }

  showToast(var text, bool error) {
    // if (error == false){
    //
    // }

    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: error ? Colors.red : Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget showFriendList(var currentUserId) {
    return Stack(
      children: <Widget>[
        // List
        FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: getFriendList(true),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                QuerySnapshot<Map<String, dynamic>> newFrList = snapshot.data!;
                if (newFrList.size > 0) {
                  return widgetFriendList(currentUserId, newFrList);
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                        'No Friend in your list\nAdd New Friend to start chat',
                        style: TextStyle(fontSize: 16.0),
                      )),
                    ],
                  );
                }
              } else {
                return Center(
                  child: Text('Loading'),
                );
              }
            }),
      ],
    );
  }

  Widget widgetFriendList(
      var currentUserId, QuerySnapshot<Map<String, dynamic>> friendLists) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
      child: ListView(
          children: friendLists.docs.map((QueryDocumentSnapshot document) {
        return new ListTile(
          leading: Material(
            child: ChatWidget.widgetShowImages(
                widget.type == 0
                    ? "https://cdn-icons-png.freepik.com/512/201/201818.png"
                    : "https://cdn-icons-png.freepik.com/512/3650/3650049.png",
                50),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            clipBehavior: Clip.hardEdge,
          ),
          title: new Text(document['Email']),
          subtitle: new Text(document['Department']),
          trailing: Wrap(children: [
            StreamBuilder(
                stream: getUnread(document.get('uid')),
                builder: (context, AsyncSnapshot<MessageData> unreadData) {
                  int unreadMsg = 0; //unreadData.data.snapshot.docs.length -1;

                  if (unreadData.hasData &&
                      unreadData.data != null &&
                      unreadData.data!.snapshot.docs.isNotEmpty) {
                    print("Unread:${unreadData.data!.snapshot.docs.length}");
                    for (int i = 0;
                        i < unreadData.data!.snapshot.docs.length;
                        i++) {
                      try {
                        if (int.parse(unreadData.data!.lastSeen.toString()) <
                                int.parse(unreadData
                                    .data!.snapshot.docs[i]['timestamp']
                                    .toString()) &&
                            unreadData.data!.snapshot.docs[i]['idFrom']
                                    .toString() !=
                                currentUserId.toString())
                          unreadMsg = unreadMsg + 1;
                      } catch (ex) {
                        print('exception' + ex.toString());
                      }
                    }
                  }
                  return unreadMsg > 0
                      ? Container(
                          height: 40,
                          width: 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(unreadMsg.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                          //: Container(width: 0, height: 0),

                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        )
                      : SizedBox(
                          height: 10,
                        );
                }),
          ]),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                          currentUserId: widget.currentUserId,
                          peerId: document.id,
                          type: widget.type,
                          peerName: document.get('Email'),
                          peerAvatar: widget.type == 0
                              ? "https://cdn-icons-png.freepik.com/512/201/201818.png"
                              : "https://cdn-icons-png.freepik.com/512/3650/3650049.png",
                        )));
          },
        );
      }).toList()),
    );
  }

  Stream<MessageData>? getUnread(var peerId) {
    var id = widget.currentUserId ?? '';
    var groupChatId = ChatData.getGroupChatID(id, peerId);

    //ChatDBFireStore().setChatLastSeen(widget.currentUserId,'messages',groupChatId);
    //ChatDBFireStore().setChatLastSeen(peerId,'messages',groupChatId);

    try {
      print('unreadData ' + groupChatId);
      var controller = StreamController<MessageData>.broadcast();

      unreadSubscriptions.add(FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .snapshots()
          .listen((doc) {
        unreadSubscriptions.add(FirebaseFirestore.instance
            .collection('messages')
            .doc(groupChatId)
            .collection(groupChatId)
            .orderBy("timestamp", descending: false)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.size != 0) {
            controller.add(MessageData(
                snapshot: snapshot,
                lastSeen: int.parse(snapshot.docs.last.data()['timestamp'])));
          }
        }));
      }));
      controllers.add(controller);
      return controller.stream;
    } catch (e) {
      print('unreadExcept' + e.toString());
    }
    return null;
  }
}

class MessageData {
  int lastSeen;
  QuerySnapshot snapshot;
  MessageData({required this.snapshot, required this.lastSeen});
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets / 2,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}

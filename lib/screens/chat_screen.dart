import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/message_bubble.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String messageText;
  final messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final User user = _auth.currentUser; //synchronous method
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async //Fetch the documents for this query
  // {
  //   final QuerySnapshot chat = await _firestore.collection('messages').get();
  //   //get() returns a Future<QuerySnapshot>
  //   for (QueryDocumentSnapshot message in chat.docs) {
  //     print(message.data);
  //   }
  // } //retrieving / pulling the data out of the firebase database

//   void messagesStream() async {
//     await for (QuerySnapshot snapshot
//         in _firestore.collection('messages').snapshots()) {
// //Notifies of query results at this location.
// //have subscribed to snapshots to listen for new changes to the collection
// //.snapshots() returns Stream<QuerySnapshot> i.e, just like a list/bunch of Future<QuerySnapshot>
//       for (QueryDocumentSnapshot message in snapshot.docs) {
//         print(message.data);
//       }
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/background6.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.green.withOpacity(0.3), BlendMode.dstATop),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                }),
          ],
          title: Text('🌬 Mann Ki Baat ✍'),
          backgroundColor: Color(0xFF36013F),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          messageText = value;
                        },
                        controller: messageTextController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                      onPressed: () {
                        //so that it wont send an empty message to firestore
                        if (messageText.isNotEmpty) {
                          messageTextController.clear();
                          //Implementing send functionality (to cloud firestore)
                          _firestore.collection('messages').add({
                            'text': messageText,
                            'sender': loggedInUser.email, //_auth.currentUser
                            'timestamp': DateTime.now(),
                          });
                        }
                        //after 1 send button make textfield value null
                        //so that futher it wont send same messageText
                        messageText = '';
                      },
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

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
//Widget that builds/update itself based on the latest snapshot of interaction with a [Stream], using [State.setState]
      stream: _firestore
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        //build strategy
        if (snapshot.hasData == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<QueryDocumentSnapshot> chat = snapshot.data.docs;

        //.data => The latest data received by the asynchronous computation
//AsyncSnapshot<QuerySnapshot> snapshot (from StreamBuilder flutter) actually contains QuerySnapshot from firebase
//QuerySnapshot in turn contains List<QueryDocumentSnapshot>

        List<MessageBubble> messageBubbles = [];
        for (QueryDocumentSnapshot message in chat) {
//QueryDocumentSnapshot.data => Contains all the data of single [DocumentSnapshot].
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];
          final messageTimeStamp = message.data()['timestamp'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            msgSender: messageSender,
            msgText: messageText,
            msgTimeStamp: messageTimeStamp,
            isMe: (currentUser == messageSender),
            //true => The message is going to be from the loggedInUser.
            //false => The message is from other guys.
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          //so that it only takes its available space, not whole screen
          child: ListView(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            reverse: true,
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

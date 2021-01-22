import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String msgSender;
  final String msgText;
  final Timestamp msgTimeStamp;
  final bool isMe;

  MessageBubble({this.msgSender, this.msgText, this.msgTimeStamp, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            (isMe) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$msgSender',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFFBCAAA4),
            ),
          ),
          Material(
            color: (isMe) ? Color(0xFFB4AAF9) : Color(0xFF620024),
            elevation: 10,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 20 : 0),
              bottomLeft: Radius.circular(20),
              topRight: Radius.circular(isMe ? 0 : 20),
              bottomRight: Radius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$msgText',
                style: TextStyle(
                  color: (isMe) ? Colors.black : Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Text(
            msgTimeStamp.toDate().toString().substring(0, 16),
            style: TextStyle(
              fontSize: 9,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}

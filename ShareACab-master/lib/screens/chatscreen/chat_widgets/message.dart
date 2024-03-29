import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shareacab/screens/chatscreen/chat_widgets/chat_bubble.dart';

class MessageScreen extends StatelessWidget {
  final String docId;

  MessageScreen(this.docId);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatroom')
            .doc(docId)
            .collection('chats')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .limit(30)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data.docs;

          return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) => MessageBubble(
              chatDocs[index]['text'],
              chatDocs[index]['name'],
              chatDocs[index]['userId'] == FirebaseAuth.instance.currentUser.uid,
              key: ValueKey(chatDocs[index].id),
              time: DateFormat().add_jm().format(
                    DateTime.parse(
                      chatDocs[index]['createdAt'].toDate().toString(),
                    ),
                  ),
            ),
          );
        });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/message_bubble.dart';
import '../services/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  final String? chatId;
  final String receiverId;

  const ChatScreen({super.key, required this.chatId, required this.receiverId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User? loggedInUser;
  String? chatId;

  @override
  void initState() {
    super.initState();
    chatId = widget.chatId;
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        loggedInUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final TextEditingController _textController = TextEditingController();
    return FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('users').doc(widget.receiverId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final receiverData = snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              backgroundColor: const Color(0xffeeeeee),
              appBar: AppBar(
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(receiverData['imageUrl']),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(receiverData['name'])
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                      child: chatId != null && chatId!.isNotEmpty
                          ? MessagesStream(chatId: chatId!)
                          : const Center(
                              child: Text("No Messages Yet"),
                            )),
                  Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: _textController,
                          decoration: const InputDecoration(
                              hintText: 'Enter Message',
                              border: InputBorder.none),
                        )),
                        IconButton(
                            onPressed: () async {
                              if (_textController.text.isNotEmpty) {
                                if (chatId == null || chatId!.isEmpty) {
                                  chatId = await chatProvider
                                      .createChatRoom(widget.receiverId);
                                }
                                if (chatId != null) {
                                  chatProvider.sendMessage(chatId!,
                                      _textController.text, widget.receiverId);
                                  _textController.clear();
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Color(0xff3876fd),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

class MessagesStream extends StatelessWidget {
  final String chatId;

  const MessagesStream({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final messages = snapshot.data!.docs;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages) {
            final messageData = message.data() as Map<String, dynamic>;
            final messageText = messageData['messageBody'];
            final messageSender = messageData['senderId'];
            final timestamp =
                messageData['timestamp'] ?? FieldValue.serverTimestamp();
            final currentUser = FirebaseAuth.instance.currentUser!.uid;
            final messageWidget = MessageBubble(
              text: messageText,
              isMe: currentUser == messageSender,
              sender: messageSender,
              timestamp: timestamp,
            );
            messageWidgets.add(messageWidget);
          }
          return ListView(
            reverse: true,
            children: messageWidgets,
          );
        });
  }
}

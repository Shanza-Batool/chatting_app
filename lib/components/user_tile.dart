import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/chat_screen.dart';
import '../services/chat_provider.dart';

class UserTile extends StatelessWidget {
  final String userId;
  final String name;
  final String email;
  final String imageUrl;

  const UserTile(
      {super.key,
      required this.imageUrl,
      required this.email,
      required this.name,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(name),
      subtitle: Text(email),
      onTap: () async {
        final chatId = await chatProvider.getChatRoom(userId) ??
            await chatProvider.createChatRoom(userId);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      chatId: chatId,
                      receiverId: userId,
                    )));
      },
    );
  }
}

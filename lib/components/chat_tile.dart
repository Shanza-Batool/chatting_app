import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String chatId;
  final String lastMessage;
  final DateTime timestamp;
  final Map<String, dynamic> receiverData;
  final VoidCallback onTap; // This should be included in the constructor parameters

  const ChatTile({
    Key? key,
    required this.chatId,
    required this.timestamp,
    required this.lastMessage,
    required this.receiverData,
    required this.onTap, // Make sure it's included in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return lastMessage.isNotEmpty
        ? ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(receiverData['imageUrl']),
      ),
      title: Text(receiverData['name']),
      subtitle: Text(
        lastMessage,
        maxLines: 2,
      ),
      trailing: Text(
        '${timestamp.hour}:${timestamp.minute}',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      onTap: onTap, // Use onTap directly here
    )
        : Container();
  }
}

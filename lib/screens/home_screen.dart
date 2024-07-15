import 'package:chatting_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/chat_tile.dart';
import '../services/chat_service.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Stream<List<Map<String, dynamic>>> _chatDataListStream;

  @override
  void initState() {
    super.initState();
    _initializeChatData();
  }

  void _initializeChatData() {
    final chatService = Provider.of<ChatService>(context, listen: false);
    _chatDataListStream = chatService.getChatsStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            onPressed: () {
              // Implement logout functionality
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _chatDataListStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No chats available.'));
          }
          final chatDataList = snapshot.data!;
          return ListView.builder(
            itemCount: chatDataList.length,
            itemBuilder: (context, index) {
              final chatData = chatDataList[index];
              return ChatTile(
                chatId: chatData['chatId'],
                timestamp: chatData['timestamp'],
                lastMessage: chatData['lastMessage'],
                receiverData: chatData['userData'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatId: chatData['chatId'],
                        receiverId: chatData['userData']['uid'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SearchScreen()));
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}

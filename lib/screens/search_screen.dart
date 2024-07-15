import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/user_tile.dart';
import '../services/chat_provider.dart';
import 'chat_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
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

  void handleSearch(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Search Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search Users',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: handleSearch,
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: searchQuery.isEmpty
                ? const Stream.empty()
                : chatProvider.searchUsers(searchQuery),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final users = snapshot.data!.docs;
              List<UserTile> userWidgets = [];
              for (var user in users) {
                final userData = user.data() as Map<String, dynamic>;
                if (userData['uid'] != loggedInUser!.uid) {
                  final userWidget = UserTile(
                      imageUrl: userData['imageUrl'],
                      email: userData['email'],
                      name: userData['name'],
                      userId: userData['uid']);
                  userWidgets.add(userWidget);
                }
              }
              return ListView(
                children: userWidgets,
              );
            },
          ))
        ],
      ),
    );
  }
}

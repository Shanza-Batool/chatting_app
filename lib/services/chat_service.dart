import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getChatsStream() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      return _firestore
          .collection('chats')
          .where('users', arrayContains: currentUser.uid)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs.map((doc) {
        final chatData = doc.data();
        return {
          'chatId': doc.id,
          'lastMessage': chatData['lastMessage'] ?? '',
          'timestamp': chatData['timestamp']?.toDate() ?? DateTime.now(),
          'userData': {},
        };
      }).toList());
    } else {
      throw Exception('User not authenticated');
    }
  }

  Future<Map<String, dynamic>> fetchChatData(String chatId) async {
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    final chatData = chatDoc.data();
    if (chatData == null) return {};
    final users = chatData['users'] as List<dynamic>;
    final currentUser = _auth.currentUser;
    final receiverId = users.firstWhere((id) => id != currentUser!.uid);
    final userDoc = await _firestore.collection('users').doc(receiverId).get();
    final userData = userDoc.data();
    return {
      'chatId': chatId,
      'lastMessage': chatData['lastMessage'] ?? '',
      'timestamp': chatData['timestamp']?.toDate() ?? DateTime.now(),
      'userData': userData,
    };
  }
}

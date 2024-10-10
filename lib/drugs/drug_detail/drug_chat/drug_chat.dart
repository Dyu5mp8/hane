import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrugChat extends StatelessWidget {
  final String drugId; // ID of the drug for which the chat is displayed

  DrugChat({required this.drugId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diskussion'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('drugs')
                  .doc(drugId)
                  .collection('chat')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator()); // Loading indicator
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("Ingen diskussion ännu"), // Displayed when there are no messages"),
                  );
                }
                var chatDocs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true, // Display the latest message at the bottom
                  itemCount: chatDocs.length,
                  itemBuilder: (context, index) {
                    var chat = chatDocs[index];
                    var isCurrentUser = chat['user'] == FirebaseAuth.instance.currentUser?.email; // Use FirebaseAuth for current user email
                    return MessageBubble(
                      message: chat['message'],
                      user: chat['user'],
                      isCurrentUser: isCurrentUser,
                    );
                  },
                );
              },
            ),
          ),
          ChatInputField(drugId: drugId), // Widget to send new messages
        ],
      ),
    );
  }
}

// Message bubble widget to make the chat more modern
class MessageBubble extends StatelessWidget {
  final String message;
  final String user;
  final bool isCurrentUser;

  const MessageBubble({
    required this.message,
    required this.user,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isCurrentUser)
                  CircleAvatar(
                    child: Text(user[0].toUpperCase()),
                  ),
                SizedBox(width: 10),

              
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isCurrentUser ? Colors.blueAccent : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: isCurrentUser ? Radius.circular(12) : Radius.circular(0),
                        bottomRight: isCurrentUser ? Radius.circular(0) : Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: isCurrentUser ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              user,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// Chat input field with modern design
class ChatInputField extends StatefulWidget {
  final String drugId;

  ChatInputField({required this.drugId});

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(BuildContext context) {
    // Get the current user's email from FirebaseAuth
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? 'Anonym'; 

    if (_controller.text.isEmpty) return;

    FirebaseFirestore.instance
        .collection('drugs')
        .doc(widget.drugId)
        .collection('chat')
        .add({
      'user': currentUserEmail, // Use FirebaseAuth to get current user's email
      'message': _controller.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                hintText: 'Skicka ett meddelande...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () => _sendMessage(context), // Passing the context to _sendMessage method
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:intl/intl.dart';

class DrugChat extends StatefulWidget {
  final Drug drug;// ID of the drug for which the chat is displayed

  DrugChat({required this.drug});

  @override
  _DrugChatState createState() => _DrugChatState();
}

class _DrugChatState extends State<DrugChat> {
  final ScrollController _scrollController = ScrollController();
@override
void initState() {
  super.initState();
  Future.delayed(Duration.zero, () {
    markAsRead();
  });
}

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  void markAsRead() {
    Provider.of<DrugListProvider>(context, listen: false).updateLastReadTimestamp(widget.drug.id!);
  
    widget.drug.markMessagesAsRead();
  }

  void _onNewMessage() {
    markAsRead();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diskussion'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end, // Aligns children to the bottom
        children: [
          Expanded(
            child: StreamBuilder(
              stream: Provider.of<DrugListProvider>(context)
                  .getChatStream(widget.drug.id!),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator()); // Loading indicator
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text("Ingen diskussion ännu"), // Displayed when there are no messages
                  );
                }
                var chatDocs = snapshot.data!.docs;

                // Scroll to the bottom when a new message arrives
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true, // Take only the space needed
                  physics: AlwaysScrollableScrollPhysics(), // Allow scrolling when content is less
                  itemCount: chatDocs.length,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  reverse: true, // Reverse the list and scroll direction
                  itemBuilder: (context, index) {
                    var chat = chatDocs[index];
                    var isCurrentUser =
                        chat['user'] == FirebaseAuth.instance.currentUser?.email;
                    Timestamp timestamp = chat['timestamp'] as Timestamp;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MessageBubble(
                        message: chat['message'],
                        user: chat['user'],
                        isCurrentUser: isCurrentUser,
                        timestamp: timestamp,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ChatInputField(
            drugId: widget.drug.id!,
            onNewMessage: _onNewMessage, // Notify when a new message is sent
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final String user;
  final bool isCurrentUser;
  final Timestamp timestamp;

  const MessageBubble({
    required this.message,
    required this.user,
    required this.isCurrentUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    // Format the timestamp to a readable time (HH:mm)
    String formattedTime = DateFormat('HH:mm').format(timestamp.toDate());

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Message bubble
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isCurrentUser)
                CircleAvatar(
                  child: Text(user[0].toUpperCase()),
                ),
              if (!isCurrentUser) SizedBox(width: 10),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isCurrentUser ? Colors.blueAccent : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft:
                          isCurrentUser ? Radius.circular(12) : Radius.circular(0),
                      bottomRight:
                          isCurrentUser ? Radius.circular(0) : Radius.circular(12),
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
              if (isCurrentUser) SizedBox(width: 10),
              if (isCurrentUser)
                CircleAvatar(
                  child: Text(user[0].toUpperCase()),
                ),
            ],
          ),
          // Spacing between bubble and metadata
          SizedBox(height: 5),
          // User and timestamp below the bubble
          Row(
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                user,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(width: 5),
              Text(
                formattedTime, // Display the formatted timestamp
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Chat input field with modern design
class ChatInputField extends StatefulWidget {
  final String drugId;
  final VoidCallback onNewMessage; // Callback when a new message is sent

  ChatInputField({required this.drugId, required this.onNewMessage});

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
 void _sendMessage() async {
    var provider = Provider.of<DrugListProvider>(context, listen: false);
    if (_controller.text.isEmpty) return;

    try {
      await provider.sendChatMessage(widget.drugId, _controller.text);
      _controller.clear();
      widget.onNewMessage(); // Notify that a new message has been sent
    } catch (e) {
      // Handle any errors that occur during sending the message
      print("Failed to send message: $e");
      // Optionally, show an error message to the user
    }
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
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                hintText: 'Skicka ett meddelande...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
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
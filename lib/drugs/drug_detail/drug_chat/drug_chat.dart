import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:intl/intl.dart';

class DrugChat extends StatefulWidget {
  final Drug drug; // ID of the drug for which the chat is displayed

  const DrugChat({super.key, required this.drug});

  @override
  State<DrugChat> createState() => _DrugChatState();
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
    Provider.of<DrugListProvider>(context, listen: false)
        .updateLastReadTimestamp(widget.drug.id!);

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
        title: Text(
          'Diskussion: ${widget.drug.name}',
        ),
      ),
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.end, // Aligns children to the bottom
        children: [
          Expanded(
            child: StreamBuilder(
              stream: Provider.of<DrugListProvider>(context)
                  .getChatStream(widget.drug.id!),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator()); // Loading indicator
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                        "Ingen diskussion ännu"), // Displayed when there are no messages
                  );
                }
                var chatDocs = snapshot.data!.docs;

                // Scroll to the bottom when a new message arrives
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true, // Take only the space needed
                  physics:
                      const AlwaysScrollableScrollPhysics(), // Allow scrolling when content is less
                  itemCount: chatDocs.length,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  reverse: true, // Reverse the list and scroll direction
                  itemBuilder: (context, index) {
                    var chat = chatDocs[index];
                    var isCurrentUser = chat['user'] ==
                        FirebaseAuth.instance.currentUser?.email;
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChatInputField(
              drugId: widget.drug.id!,
              onNewMessage: _onNewMessage, // Notify when a new message is sent
            ),
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
    super.key,
    required this.message,
    required this.user,
    required this.isCurrentUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    // Format the timestamp to a readable time (HH:mm)
    String formattedTime = DateFormat('d MMM HH:mm').format(timestamp.toDate());

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
              if (!isCurrentUser) const SizedBox(width: 10),
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isCurrentUser ? Colors.blueAccent : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: isCurrentUser
                          ? const Radius.circular(12)
                          : const Radius.circular(0),
                      bottomRight: isCurrentUser
                          ? const Radius.circular(0)
                          : const Radius.circular(12),
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
              if (isCurrentUser) const SizedBox(width: 10),
              if (isCurrentUser)
                CircleAvatar(
                  child: Text(user[0].toUpperCase()),
                ),
            ],
          ),
          // Spacing between bubble and metadata
          const SizedBox(height: 5),
          // User and timestamp below the bubble
          Row(
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                user,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(width: 5),
              Text(
                formattedTime, // Display the formatted timestamp
                style: const TextStyle(fontSize: 12, color: Colors.grey),
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

  const ChatInputField(
      {super.key, required this.drugId, required this.onNewMessage});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  void _sendMessage() async {
    var provider = Provider.of<DrugListProvider>(context, listen: false);
    if (_controller.text.isEmpty) return;

    String message = _controller.text;
    _controller.clear();

    try {
      await provider.sendChatMessage(widget.drugId, message);
      widget.onNewMessage(); // Notify that a new message has been sent
    } catch (e) {
      if (context.mounted) {
        // Handle any errors that occur during sending the message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kunde inte skicka meddelandet')),
        );
        // Optionally, show an error message to the user
      }
    } finally {
      if (context.mounted) {
        FocusScope.of(context)
            .unfocus(); // Hide the keyboard after sending the message
      }
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
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                hintText: 'Skicka ett meddelande...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (value) => _sendMessage(),
              minLines: 1,
              maxLines: 3,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: const CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

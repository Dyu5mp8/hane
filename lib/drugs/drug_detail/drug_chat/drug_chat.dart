import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hane/drugs/drug_detail/edit_mode_provider.dart';
import 'package:hane/drugs/models/drug.dart';
import 'package:hane/drugs/services/drug_list_provider.dart';
import 'package:intl/intl.dart';

class ChatMessage {
  final String message;
  final String user;
  final Timestamp timestamp;
  final bool isSolved;


  ChatMessage({
    required this.message,
    required this.user,
    required this.timestamp,
    this.isSolved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'user': user,
      'timestamp': timestamp,
      'isSolved': isSolved,
    };
  }

factory ChatMessage.fromFirestore(Map<String, dynamic> data) {
  return ChatMessage(
    message: data['message'],
    user: data['user'],
    timestamp: data['timestamp'],
    isSolved: data['isSolved'] ?? false, // Provide a default value if null
  );
}
}

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
  stream: Provider.of<DrugListProvider>(context).getChatStream(widget.drug.id!),
  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.data!.docs.isEmpty) {
      return const Center(child: Text("Ingen diskussion ännu"));
    }

    // Map documents to ChatMessage instances
    List<ChatMessage> chatMessages = snapshot.data!.docs
        .map((doc) => ChatMessage.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();

    // Scroll to the bottom when a new message arrives
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: chatMessages.length,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      reverse: true,
      itemBuilder: (context, index) {
        var chatMessage = chatMessages[index];
        var isCurrentUser = chatMessage.user == FirebaseAuth.instance.currentUser?.email;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: MessageBubble(
            chatMessage: chatMessage,
            isCurrentUser: isCurrentUser,
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
  final ChatMessage chatMessage;
  final bool isCurrentUser;

  const MessageBubble({
    Key? key,
    required this.chatMessage,
    required this.isCurrentUser,
  }) : super(key: key);

  Color bubbleColor() {
    double opacity = chatMessage.isSolved ? 0.5 : 1.0;
    return isCurrentUser
        ? Colors.blueAccent.withOpacity(opacity)
        : Colors.grey[200]!.withOpacity(opacity);
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('d MMM HH:mm').format(chatMessage.timestamp.toDate());

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Message bubble
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isCurrentUser)
                CircleAvatar(
                  child: Text(chatMessage.user[0].toUpperCase()),
                ),
              if (!isCurrentUser) const SizedBox(width: 10),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: bubbleColor(),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: isCurrentUser ? const Radius.circular(12) : Radius.zero,
                      bottomRight: isCurrentUser ? Radius.zero : const Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    chatMessage.message,
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
                  child: Text(chatMessage.user[0].toUpperCase()),
                ),
            ],
          ),
          const SizedBox(height: 5),
          // User and timestamp below the bubble
          Row(
            mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                chatMessage.user,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(width: 5),
              Text(
                formattedTime,
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

  String messageText = _controller.text;
  _controller.clear();

  ChatMessage chatMessage = ChatMessage(
    message: messageText,
    user: FirebaseAuth.instance.currentUser?.email ?? 'Anonymous',
    timestamp: Timestamp.now(),
  );

  try {
    await provider.sendChatMessage(widget.drugId, chatMessage);
    widget.onNewMessage();
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kunde inte skicka meddelandet ${e.toString()}')),
      );
    }
  } finally {
    if (context.mounted) {
      FocusScope.of(context).unfocus();
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

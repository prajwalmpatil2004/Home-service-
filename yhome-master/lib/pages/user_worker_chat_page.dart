import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class WorkerChatPage extends StatefulWidget {
  final String workerName;
  final String workerPhone;

  const WorkerChatPage({
    Key? key,
    required this.workerName,
    required this.workerPhone,
  }) : super(key: key);

  @override
  State<WorkerChatPage> createState() => _WorkerChatPageState();
}

class _WorkerChatPageState extends State<WorkerChatPage> {
  final List<Map<String, dynamic>> _messages = [
    {
      "text": "Hello, I need help with the work.",
      "isUser": true,
      "time": "10:00 AM",
    },
    {
      "text": "Hi! How can I assist you today?",
      "isUser": false,
      "time": "10:01 AM",
    },
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    String text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        "text": text,
        "isUser": true,
        "time": TimeOfDay.now().format(context),
      });
    });

    _controller.clear();
    _scrollToBottom();

    // Auto reply simulation
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _messages.add({
          "text":
              "Thanks for your message. I will check and get back to you shortly.",
          "isUser": false,
          "time": TimeOfDay.now().format(context),
        });
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, int index) {
    bool isUser = msg['isUser'];
    return FadeInRight(
      delay: Duration(milliseconds: 100 * index),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isUser ? Colors.blueAccent : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isUser ? 16 : 0),
              bottomRight: Radius.circular(isUser ? 0 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                msg['text'],
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                  height: 1.3,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 6),
              Text(
                msg['time'],
                style: TextStyle(
                  color: isUser ? Colors.white70 : Colors.black54,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.blueAccent;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.workerName,
              style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.workerPhone,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index], index);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 120),
                    child: Scrollbar(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Type your message...",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        minLines: 1,
                        maxLines: 5,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: themeColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                    tooltip: "Send Message",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

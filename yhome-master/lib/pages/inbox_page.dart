import 'package:flutter/material.dart';
import 'dart:async';

class InboxPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<InboxPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": message});
      _isTyping = true;
    });

    _controller.clear();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isTyping = false;
        _messages.add({
          "role": "bot",
          "text": _getBotResponse(message),
        });
      });
    });
  }

  String _getBotResponse(String query) {
    query = query.toLowerCase();

    if (query.contains("hello") || query.contains("hi")) {
      return "Hello 👋, how can I assist you today?";
    } else if (query.contains("electrician")) {
      return "I can help you find nearby electricians 🔌.";
    } else if (query.contains("plumber")) {
      return "Sure! I'll connect you with plumbers in your area 🚰.";
    } else if (query.contains("painter")) {
      return "Painters 🎨 are available. Do you want me to list nearby ones?";
    } else if (query.contains("carpenter")) {
      return "Yes, I can arrange carpenters 🪚 for your needs.";
    } else if (query.contains("thanks") || query.contains("thank you")) {
      return "You’re welcome! Always happy to help 😊";
    } else if (query.contains("bye")) {
      return "Goodbye 👋. Have a nice day!";
    }

    return "Hmm 🤔 I’m not sure about that. Try asking about electricians, plumbers, painters, or carpenters.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Inbox", style: TextStyle(color: Colors.black)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  // Typing indicator
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const TypingIndicator(),
                    ),
                  );
                }

                final msg = _messages[index];
                final isUser = msg["role"] == "user";

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: Offset(isUser ? 0.5 : -0.5, 0),
                      end: Offset.zero,
                    ).animate(animation);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Align(
                    key: ValueKey(msg),
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: isUser
                            ? null
                            : Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        msg["text"] ?? "",
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTapDown: (_) => setState(() {}),
                  onTapUp: (_) => setState(() {}),
                  child: AnimatedScale(
                    scale: 1.1,
                    duration: const Duration(milliseconds: 150),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(14),
                      ),
                      onPressed: () => _sendMessage(_controller.text),
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
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

/// Animated typing indicator (three bouncing dots)
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({Key? key}) : super(key: key);

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            double value = (_controller.value + (index * 0.2)) % 1.0;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Opacity(
                opacity: value < 0.5 ? 1.0 : 0.3,
                child: const CircleAvatar(
                    radius: 3, backgroundColor: Colors.black),
              ),
            );
          },
        );
      }),
    );
  }
}

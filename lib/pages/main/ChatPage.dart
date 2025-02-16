import 'package:flutter/material.dart';
import 'package:highthon_10th_favorite/util/style/colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final text = TextColors.of(context);
    return Scaffold(
      backgroundColor: text.white,
      appBar: AppBar(
        backgroundColor: text.white,
        title: Text(
          "채팅 목록",
          style: TextStyle(color: text.primary),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, top: 30),
        child: Column(
          children: [
            Theme.of(context).brightness == Brightness.dark
              ? Image.asset(
                  "assets/images/chat1_dark.png",
                  width: 323,
                  height: 60,
                )
              : Image.asset(
                  "assets/images/chat1.png",
                  width: 323,
                  height: 60,
                ),
            const SizedBox(height: 20),
            Theme.of(context).brightness == Brightness.dark
              ? Image.asset(
                  "assets/images/chat2_dark.png",
                  width: 323,
                  height: 60,
                )
              : Image.asset(
                  "assets/images/chat2.png",
                  width: 323,
                  height: 60,
                )
          ],
        ),
      ),
    );
  }
}

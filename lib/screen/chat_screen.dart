import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Supporter Chat'),
              Row(
                children: [
                  Text('chatlist'),
                  Expanded(child: Text('chat'),),
                  Text('detail'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  
}

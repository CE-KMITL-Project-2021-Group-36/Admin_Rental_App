import 'package:flutter/material.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'ยินดีต้อนรับ',
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}

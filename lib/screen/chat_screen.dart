import 'package:admin_rental_app/config/palette.dart';
import 'package:admin_rental_app/widgets/chat_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatId = '';
  String chatWithUserId = '';
  String chatWithUserName = '';

  double boxHeight = 800;
  bool isSelected = false;
  String currentUserId = 'admin';

  void launchEmailSubmission(userEmail) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: userEmail,
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  getData() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("chats")
        .where('usersInChat', arrayContains: currentUserId)
        .orderBy('lastestMessageCreatedOn', descending: true)
        .get();
    chatWithUserId = snapshot.docs[0].id;
    chatWithUserName =
        snapshot.docs[0]['firstName'] + ' ' + snapshot.docs[0]['lastName'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Text('Supporter Chat'),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: boxHeight,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 2),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'ข้อความ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            chatList(),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: boxHeight,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 2),
                          ],
                        ),
                        child: chatWithUserId == ''
                            ? const Center(
                                child: Text('เลือกผู้ใช้งาน'),
                              )
                            : ChatDetail(
                                chatId: chatId,
                                chatWithUserName: chatWithUserName,
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: boxHeight,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 2),
                          ],
                        ),
                        child: chatWithUserId == ''
                            ? const Center(
                                child: Text('เลือกผู้ใช้งาน'),
                              )
                            : userDetail(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  userDetail() {
    _userData(title, detail) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                detail,
                style: const TextStyle(
                  fontSize: 18,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(chatWithUserId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('มีบางอย่างผิดพลาด');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          final userData = snapshot.data;
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(userData!['avatarUrl']),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  '${userData['firstName']} ${userData['lastName']}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _userData(
                        'เลขบัตรประจำตัวประชาชน', userData['idCardNumber']),
                    _userData('ชื่อจริง', userData['firstName']),
                    _userData('นามสกุล', userData['lastName']),
                    _userData('อีเมล', userData['email']),
                    _userData('เบอร์โทรศัพท์', userData['phoneNumber']),
                  ],
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                SizedBox(
                  width: 160,
                  child: TextButton(
                    onPressed: () {
                      launchEmailSubmission(userData['email']);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.email),
                        SizedBox(
                          width: 4,
                        ),
                        Text('ส่งอีเมล'),
                      ],
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(24),
                      primary: Colors.white,
                      backgroundColor: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget chatList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chats")
          .where('usersInChat', arrayContains: currentUserId)
          .orderBy('lastestMessageCreatedOn', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('มีบางอย่างผิดพลาด');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final chatData = snapshot.data;
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: chatData!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot chat = chatData.docs[index];
            String? chatWithUserId;
            for (final i in chat['usersInChat']) {
              if (i != currentUserId) {
                chatWithUserId = i;
                break;
              }
            }
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(chatWithUserId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('มีบางอย่างผิดพลาด');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final userData = snapshot.data;
                final avatarUrl = userData!['avatarUrl'];
                final userName =
                    '${userData['firstName']} ${userData['lastName']}';
                return _buildUserChat(
                  chat.id,
                  avatarUrl,
                  userName,
                  chatWithUserId!,
                  chat['lastestMessage'],
                  chat['lastestMessageSender'],
                  chat['lastestMessageCreatedOn'],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildUserChat(
    String chatId,
    String avatarUrl,
    String chatWithUserName,
    String chatWithUserId,
    String lastestMessage,
    String lastestMessageSender,
    lastestMessageCreatedOn,
  ) {
    bool isMylastestMessage = currentUserId == lastestMessageSender;
    initializeDateFormatting('th', null);
    String date =
        DateFormat('dd MMM', 'th').format(lastestMessageCreatedOn.toDate());
    String time =
        DateFormat('hh:mm a').format(lastestMessageCreatedOn.toDate());

    lastestMessage =
        isMylastestMessage ? 'คุณ: $lastestMessage' : lastestMessage;
    return TextButton(
      onPressed: () {
        this.chatId = chatId;
        this.chatWithUserId = chatWithUserId;
        this.chatWithUserName = chatWithUserName;
        //isSelected = true;
        setState(() {});
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatWithUserName,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
                const SizedBox(height: 8),
                Text(
                  lastestMessage,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

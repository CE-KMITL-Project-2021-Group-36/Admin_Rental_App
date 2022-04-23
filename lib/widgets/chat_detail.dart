import 'dart:io';

import 'package:admin_rental_app/config/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class ChatDetail extends StatefulWidget {
  const ChatDetail({
    Key? key,
    required this.chatWithUserName,
    required this.chatId,
  }) : super(key: key);

  final String chatWithUserName, chatId;

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final TextEditingController _controller = TextEditingController();
  //final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final currentUserId = 'admin';

  final ImagePicker _picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future pickImage(ImageSource source) async {
    XFile? file = await _picker.pickImage(source: source);
    if (file == null) return;
    File image = File(file.path);
    await uploadImage(image);
  }

  Future uploadImage(image) async {
    if (image == null) return;
    final imageName = basename(image!.path);
    final destination = 'chats/$currentUserId/$imageName';
    final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
    await ref.putFile(image!);
    final imageUrl = await ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add(
      {
        'createdOn': DateTime.now(),
        'message': imageUrl,
        'sender': currentUserId,
        'type': 'image'
      },
    );
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .update(
      {
        'lastestMessage': 'ส่งรูปภาพ',
        'lastestMessageSender': currentUserId,
        'lastestMessageCreatedOn': DateTime.now(),
      },
    );
  }

  void sendMessage() async {
    CollectionReference messages = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages');
    CollectionReference chats = FirebaseFirestore.instance.collection('chats');
    await messages.add(
      {
        'createdOn': DateTime.now(),
        'message': _controller.text,
        'sender': currentUserId,
        'type': 'text'
      },
    );
    await chats.doc(widget.chatId).update(
      {
        'lastestMessage': _controller.text,
        'lastestMessageSender': currentUserId,
        'lastestMessageCreatedOn': DateTime.now(),
      },
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.chatWithUserName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: _buildMessageList(),
          ),
        ),
        _buildSendMessageTextField(),
      ],
    );
  }

  _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .orderBy('createdOn', descending: true)
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
        final messages = snapshot.data;
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          reverse: true,
          shrinkWrap: true,
          itemCount: messages!.docs.length,
          itemBuilder: (context, index) {
            final message = messages.docs[index];
            return _buildMessage(
              message: message['message'],
              type: message['type'],
              isMe: message['sender'] == currentUserId,
              createdOn: DateFormat('yyyy-MM-dd hh:mm')
                  .format(message['createdOn'].toDate()),
            );
          },
        );
      },
    );
  }

  Widget _buildMessage({
    required String message,
    required bool isMe,
    required String createdOn,
    required String type,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Align(
        alignment: (isMe ? Alignment.topRight : Alignment.topLeft),
        child: Tooltip(
          message: createdOn,
          child: _buildContent(type, message, isMe),
        ),
      ),
    );
  }

  _buildContent(type, message, isMe) {
    switch (type) {
      case 'text':
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: (isMe ? primaryColor : Colors.grey[200]),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
          child: Text(
            message,
            style: TextStyle(
              color: (isMe ? Colors.white : Colors.black),
              fontSize: 16,
            ),
          ),
        );
      case 'image':
        return Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.network(
            message,
          ),
        );
      default:
        return const Text('บางอย่างผิดพลาด');
    }
  }

  Widget _buildSendMessageTextField() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            Icons.photo,
          ),
          color: primaryColor,
          onPressed: () {
            pickImage(ImageSource.gallery);
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "พิมพ์ข้อความ...",
                enabledBorder: InputBorder.none,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.send,
          ),
          color: primaryColor,
          onPressed: () {
            sendMessage();
          },
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
}

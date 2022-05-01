import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference withdrawalRequests =
      FirebaseFirestore.instance.collection('withdrawal_requests');
  final CollectionReference reports =
      FirebaseFirestore.instance.collection('reports');
}

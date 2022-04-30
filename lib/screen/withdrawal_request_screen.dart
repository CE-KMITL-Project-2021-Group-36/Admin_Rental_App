import 'package:admin_rental_app/config/palette.dart';
import 'package:admin_rental_app/screen/withdrawal_request_detail_screen.dart';
import 'package:admin_rental_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WithdrawalRequestScreen extends StatefulWidget {
  const WithdrawalRequestScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawalRequestScreen> createState() =>
      _WithdrawalRequestScreenState();
}

class _WithdrawalRequestScreenState extends State<WithdrawalRequestScreen> {
  final FirebaseServices firebase = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firebase.withdrawalRequests
            .where('finished', isEqualTo: false)
            .orderBy('timestamp', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('มีบางอย่างผิดพลาด'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                DateTime dt = (data['timestamp'] as Timestamp).toDate();
                return Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 500,
                    height: 100,
                    child: Card(
                      color: primaryLightColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListTile(
                          dense: false,
                          leading: const Icon(
                            Icons.account_circle_rounded,
                            size: 60,
                          ),
                          title: Text(data['fullName']),
                          subtitle: Text(
                            DateFormat('dd-MM-yyyy   HH:mm').format(dt),
                          ),
                          onTap: () {
                            debugPrint(document.id);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return WithdrawalRequestDetail(
                                    uid: document.id,
                                  );
                                });
                          },
                          // subtitle: Text(data['company']),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        });
  }
}

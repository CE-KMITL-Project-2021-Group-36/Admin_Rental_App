import 'package:admin_rental_app/config/palette.dart';
import 'package:admin_rental_app/screen/kyc_detail_screen.dart';
import 'package:admin_rental_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KYCScreen extends StatefulWidget {
  const KYCScreen({Key? key}) : super(key: key);

  @override
  _KYCScreenState createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  final FirebaseServices firebase = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firebase.users
            .where('kyc.status', isEqualTo: 'รอตรวจสอบ')
            .orderBy('kyc.created', descending: false)
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
                DateTime dt = (data['kyc']['created'] as Timestamp).toDate();
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
                          title:
                              Text(data['firstName'] + ' ' + data['lastName']),
                          subtitle: Text(
                            DateFormat('dd-MM-yyyy   HH:mm').format(dt),
                          ),
                          onTap: () {
                            debugPrint(document.id);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return KYCDetail(
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

    // return Container(
    //   child: ListView.builder(
    //       itemCount: itemsList!.length,
    //       itemBuilder: (context, index) {
    //         return Card(
    //           child: ListTile(
    //             title: Text(itemsList![index]['userId']),
    //             leading: const Icon(Icons.account_circle_rounded),
    //           ),
    //         );
    //       }),
    //   // child: Text(allData![0].toString()),
    // );

    // return ListView(
    //   children: const [
    //     Card(
    //       child: ListTile(
    //         title: Text('ชื่อ นามสกุล'),
    //         subtitle: Text('Timestamp'),
    //         leading: Icon(
    //           Icons.account_circle_rounded,
    //           size: 50,
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }
}

import 'package:admin_rental_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final FirebaseServices firebase = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: firebase.users.doc(widget.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('มีบางอย่างผิดพลาด');
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text('ไม่พบข้อมูล');
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: SizedBox(
                width: 800,
                height: 600,
                child: Row(
                  children: [
                    Image.network(
                      data['avatarUrl'] ??=
                          'https://firebasestorage.googleapis.com/v0/b/rental-app-dcdbf.appspot.com/o/app_files%2Favatar.png?alt=media&token=0b9a2456-3c04-458b-a319-83f5717c5cd4',
                      width: 300,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        Text(
                          'เลขบัตรประจำตัวประชาชน: ' +
                              data['idCardNumber'] +
                              '\nชื่อ: ' +
                              data['firstName'] +
                              '\nนามสกุล: ' +
                              data['lastName'] +
                              '\nอีเมล: ' +
                              data['email'] +
                              '\nเบอร์โทรศัพท์: ' +
                              data['phoneNumber'] +
                              '\nสถานะการยืนยันตัวตน: ' +
                              data['kyc']['status'],
                          style: const TextStyle(
                            fontSize: 20,
                            height: 2,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // TextButton(
                            //   onPressed: () {
                            //   },
                            //   child: const Text('ระงับการใช้งาน'),
                            //   style: TextButton.styleFrom(
                            //       primary: Colors.white,
                            //       backgroundColor: const Color(0xFFFF3D48),
                            //       padding: const EdgeInsets.symmetric(
                            //         vertical: 25,
                            //         horizontal: 50,
                            //       )),
                            // ),
                            // const SizedBox(
                            //   width: 25,
                            // ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('ย้อนกลับ'),
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: const Color(0xFF0ACF97),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 25,
                                    horizontal: 50,
                                  )),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

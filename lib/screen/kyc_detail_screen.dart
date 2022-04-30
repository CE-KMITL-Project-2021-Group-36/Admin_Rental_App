import 'package:admin_rental_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KYCDetail extends StatefulWidget {
  const KYCDetail({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<KYCDetail> createState() => _KYCDetailState();
}

class _KYCDetailState extends State<KYCDetail> {
  final FirebaseServices firebase = FirebaseServices();

  Future<void> approveKYC() {
    return firebase.users.doc(widget.uid).update({
      'kyc.verified': true,
      'kyc.status': 'ยืนยันตัวตนแล้ว',
    }).then((value) => Navigator.of(context).pop());
  }

  Future<void> rejectKYC() {
    return firebase.users.doc(widget.uid).update({
      'kyc.status': 'โปรดยืนยันตัวตนอีกครั้ง',
    }).then((value) => Navigator.of(context).pop());
  }

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
          return const Text("ไม่พบข้อมูล");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: SizedBox(
                width: 800,
                height: 700,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'รูปบัตรประชาชนด้านหน้า',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Image.network(
                          data['kyc']['frontPhoto'],
                          width: 300,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'รูปถ่ายคู่กับบัตรประชาชน',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Image.network(
                          data['kyc']['selfiePhoto'],
                          width: 300,
                        ),
                      ],
                    ),
                    const VerticalDivider(
                      width: 60,
                      thickness: 3,
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
                              data['lastName'],
                          style: const TextStyle(
                            fontSize: 20,
                            height: 2,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: rejectKYC,
                              child: const Text('ปฏิเสธ'),
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: const Color(0xFFFF3D48),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 25,
                                    horizontal: 50,
                                  )),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            TextButton(
                              onPressed: approveKYC,
                              child: const Text('ยืนยัน'),
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

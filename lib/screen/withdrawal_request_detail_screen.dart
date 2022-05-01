import 'package:admin_rental_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WithdrawalRequestDetail extends StatefulWidget {
  const WithdrawalRequestDetail({Key? key, required this.uid})
      : super(key: key);
  final String uid;

  @override
  State<WithdrawalRequestDetail> createState() =>
      _WithdrawalRequestDetailState();
}

class _WithdrawalRequestDetailState extends State<WithdrawalRequestDetail> {
  final FirebaseServices firebase = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: firebase.withdrawalRequests.doc(widget.uid).get(),
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
          debugPrint(data['amount'].runtimeType.toString());
          final String bank = data['bank'] ??= '';
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: SizedBox(
                width: 350,
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    Text(
                      'ชื่อ - นามสกุล: ' +
                          data['fullName'] +
                          '\nบัญชี: ' +
                          data['type'] +
                          bank +
                          '\nเลขที่บัญชี: ' +
                          data['destination'] +
                          '\nจำนวนเงิน: ' +
                          '฿' +
                          data['amount'].toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        height: 2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () async {
                            await firebase.users.doc(data['userId']).update({
                              'wallet.balance':
                                  FieldValue.increment(data['amount'])
                            });
                            await firebase.users
                                .doc(data['userId'])
                                .collection('wallet_transactions')
                                .doc(data['walletTransactionId'])
                                .update({
                              'status': 'ไม่สำเร็จ',
                            });
                            final String timestamp =
                                (DateTime.now().millisecondsSinceEpoch / 1000)
                                    .ceil()
                                    .toString();
                            await firebase.users
                                .doc(data['userId'])
                                .collection('wallet_transactions')
                                .doc(timestamp)
                                .set({
                              'amount': data['amount'],
                              'timestamp': timestamp,
                              'type': 'คืนเงิน',
                              'status': 'ถอนเงินไม่สำเร็จ'
                            });
                            await firebase.withdrawalRequests
                                .doc(widget.uid)
                                .update({
                              'finished': true,
                            }).then((value) => Navigator.of(context).pop());
                          },
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
                          onPressed: () async {
                            await firebase.users
                                .doc(data['userId'])
                                .collection('wallet_transactions')
                                .doc(data['walletTransactionId'])
                                .update({'status': 'สำเร็จ'});
                            await firebase.withdrawalRequests
                                .doc(widget.uid)
                                .update({
                              'finished': true,
                            }).then((value) => Navigator.of(context).pop());
                          },
                          child: const Text('โอนแล้ว'),
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

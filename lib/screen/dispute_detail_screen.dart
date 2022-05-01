import 'package:admin_rental_app/config/palette.dart';
import 'package:admin_rental_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DisputeDetail extends StatefulWidget {
  const DisputeDetail({Key? key, required this.documentId}) : super(key: key);
  final String documentId;

  @override
  State<DisputeDetail> createState() => _DisputeDetailState();
}

class _DisputeDetailState extends State<DisputeDetail> {
  final FirebaseServices firebase = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: firebase.disputes.doc(widget.documentId).get(),
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
                height: 700,
                child: Row(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 700,
                      child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: data['imageUrls'].length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                final imageProvider =
                                    Image.network(data['imageUrls'][index])
                                        .image;
                                showImageViewer(
                                  context,
                                  imageProvider,
                                );
                              },
                              child: Image.network(
                                data['imageUrls'][index],
                                width: 300,
                              ),
                            );
                          }),
                    ),
                    const VerticalDivider(
                      width: 60,
                      thickness: 3,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'หัวข้อ: ' +
                              data['title'] +
                              '\nหมายเลขสัญญาเช่า: ' +
                              data['contractId'] +
                              '\nรายละเอียด: ' +
                              data['detail'],
                          style: const TextStyle(
                            fontSize: 20,
                            height: 2,
                          ),
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future:
                              firebase.contracts.doc(data['contractId']).get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('มีบางอย่างผิดพลาด');
                            }
                            if (snapshot.hasData && !snapshot.data!.exists) {
                              return const Text('ไม่พบข้อมูล');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              Map<String, dynamic> contract =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return Column(
                                children: [
                                  const Text(
                                    'วิดีโอเจ้าของสินค้า ส่งสินค้า',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  contract['ownerDeliveryVideo'] == ''
                                      ? const Padding(
                                          padding: EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            '- ยังไม่มีวิดีโอขณะนี้',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          width: 100,
                                          child: TextButton(
                                            onPressed: () {
                                              final url = contract[
                                                  'ownerDeliveryVideo'];
                                              launchUrlString(url);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.play_arrow_rounded),
                                                Text(
                                                  'เล่นวิดีโอ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            style: TextButton.styleFrom(
                                              primary: Colors.white,
                                              backgroundColor: primaryColor,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'วิดีโอผู้เช่า รับสินค้า',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  contract['renterPickupVideo'] == ''
                                      ? const Padding(
                                          padding: EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            '- ยังไม่มีวิดีโอขณะนี้',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          width: 100,
                                          child: TextButton(
                                            onPressed: () {
                                              final url =
                                                  contract['renterPickupVideo'];
                                              launchUrlString(url);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.play_arrow_rounded),
                                                Text(
                                                  'เล่นวิดีโอ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            style: TextButton.styleFrom(
                                              primary: Colors.white,
                                              backgroundColor: primaryColor,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'วิดีโอผู้เช่า ส่งคืนสินค้า',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  contract['renterReturnVideo'] == ''
                                      ? const Padding(
                                          padding: EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            '- ยังไม่มีวิดีโอขณะนี้',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          width: 100,
                                          child: TextButton(
                                            onPressed: () {
                                              final url =
                                                  contract['renterReturnVideo'];
                                              launchUrlString(url);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.play_arrow_rounded),
                                                Text(
                                                  'เล่นวิดีโอ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            style: TextButton.styleFrom(
                                              primary: Colors.white,
                                              backgroundColor: primaryColor,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'วิดีโอเจ้าของสินค้า รับสินค้าคืน',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  contract['ownerPickupVideo'] == ''
                                      ? const Padding(
                                          padding: EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            '- ยังไม่มีวิดีโอขณะนี้',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          width: 100,
                                          child: TextButton(
                                            onPressed: () {
                                              final url =
                                                  contract['ownerPickupVideo'];
                                              launchUrlString(url);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.play_arrow_rounded),
                                                Text(
                                                  'เล่นวิดีโอ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            style: TextButton.styleFrom(
                                              primary: Colors.white,
                                              backgroundColor: primaryColor,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              );
                            }

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () async {
                                await firebase.reports
                                    .doc(widget.documentId)
                                    .update({'active': false}).then(
                                        (value) => Navigator.pop(context));
                              },
                              child: const Text('ลบข้อพิพาท'),
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

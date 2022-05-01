import 'package:admin_rental_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

class ReportDetail extends StatefulWidget {
  const ReportDetail({Key? key, required this.documentId}) : super(key: key);
  final String documentId;

  @override
  State<ReportDetail> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  final FirebaseServices firebase = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: firebase.reports.doc(widget.documentId).get(),
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
                              '\nรายละเอียด: ' +
                              data['detail'] +
                              '\nผู้รายงาน: ' +
                              data['reporterName'],
                          style: const TextStyle(
                            fontSize: 20,
                            height: 2,
                          ),
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
                              child: const Text('ลบ'),
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

import 'package:admin_rental_app/screen/user_detail_screen.dart';
import 'package:admin_rental_app/services/firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String query = '';
  final firebase = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: const InputDecoration(
                // border: InputBorder.none,
                // focusedBorder: InputBorder.none,
                // enabledBorder: InputBorder.none,
                // errorBorder: InputBorder.none,
                // disabledBorder: InputBorder.none,
                hintText: 'ค้นหา',
                contentPadding: EdgeInsets.all(8)),
            onChanged: (text) {
              query = text;
              setState(() {});
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: firebase.users
                .where("firstName", isGreaterThanOrEqualTo: query)
                .where("firstName", isLessThanOrEqualTo: "$query\uf8ff")
                .where("firstName", isNotEqualTo: "บริการช่วยเหลือลูกค้า")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('บางอย่างผิดพลาด');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final data = snapshot.requireData;

              return SizedBox(
                width: 400,
                height: MediaQuery.of(context).size.height / 2,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return UserDetail(
                                uid: data.docs[index].id,
                              );
                            });
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(
                              '${data.docs[index]['firstName']} ${data.docs[index]['lastName']}'),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

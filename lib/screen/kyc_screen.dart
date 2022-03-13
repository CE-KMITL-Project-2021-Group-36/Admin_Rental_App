import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KYCScreen extends StatefulWidget {
  const KYCScreen({Key? key}) : super(key: key);

  @override
  _KYCScreenState createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  final _fireStore = FirebaseFirestore.instance;

  // Future<void> getData() async {
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await _fireStore.collection('kyc').get();
  //
  //   // Get data from docs and convert map to List
  //   allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   //for a specific field
  //   // final allData = querySnapshot.docs.map((doc) => doc.get('uid')).toList();
  //
  //   // print(allData);
  // }

  // @override
  // void initState() {
  //   // getData();
  //   getKYCList();
  //   super.initState();
  // }
  //
  // final CollectionReference kyc = FirebaseFirestore.instance.collection('kyc');
  // List itemsList = [];
  //
  // Future getKYCList() async {
  //   try {
  //     await kyc.get().then((querySnapshot) {
  //       for (var element in querySnapshot.docs) {
  //         itemsList.add(element.data);
  //       }
  //     });
  //     return itemsList;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
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
    return ListView(
      children: const [
        Card(
          child: ListTile(
            title: Text('ชื่อ นามสกุล'),
            subtitle: Text('Timestamp'),
            leading: Icon(
              Icons.account_circle_rounded,
              size: 50,
            ),
          ),
        )
      ],
    );
  }
}

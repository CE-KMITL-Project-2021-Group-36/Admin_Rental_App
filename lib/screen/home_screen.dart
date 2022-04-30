import 'package:admin_rental_app/config/palette.dart';
import 'package:admin_rental_app/screen/chat_screen.dart';
import 'package:admin_rental_app/screen/dashboard_screen.dart';
import 'package:admin_rental_app/screen/drawer_list_tile.dart';
import 'package:admin_rental_app/screen/kyc_screen.dart';
import 'package:admin_rental_app/screen/report_screen.dart';
import 'package:admin_rental_app/screen/user_management_screen.dart';
import 'package:admin_rental_app/screen/withdrawal_request_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int position = 1;
  final pages = [
    const DashBoardScreen(),
    const KYCScreen(),
    const UserManagementScreen(),
    const WithdrawalRequestScreen(),
    const ChatScreen(),
    const ReportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: [
          Row(
            children: [
              Text(
                'ผู้ดูแลระบบ   ',
                style: TextStyle(color: surfaceColor, fontSize: 18),
              ),
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  icon: Icon(
                    Icons.logout,
                    color: surfaceColor,
                  )),
              SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Drawer(
                child: ListView(
                  children: [
                    DrawerHeader(
                      child: Image.asset('assets/images/appicon.png'),
                    ),
                    DrawerListTile(
                      title: "หน้าแรก",
                      icon: const Icon(Icons.home),
                      press: () {
                        setState(() {
                          position = 0;
                        });
                      },
                      selected: position == 0 ? true : false,
                    ),
                    DrawerListTile(
                      title: "จัดการ KYC",
                      icon: const Icon(Icons.check_circle),
                      press: () {
                        setState(() {
                          position = 1;
                        });
                      },
                      selected: position == 1 ? true : false,
                    ),
                    DrawerListTile(
                      title: "จัดการบัญชีผู้ใช้",
                      icon: const Icon(Icons.account_box),
                      press: () {
                        setState(() {
                          position = 2;
                        });
                      },
                      selected: position == 2 ? true : false,
                    ),
                    DrawerListTile(
                      title: "คำขอถอนเงิน",
                      icon: const Icon(Icons.account_balance),
                      press: () {
                        setState(() {
                          position = 3;
                        });
                      },
                      selected: position == 3 ? true : false,
                    ),
                    DrawerListTile(
                      title: "แชทกับผู้ใช้",
                      icon: const Icon(Icons.support_agent),
                      press: () {
                        setState(() {
                          position = 4;
                        });
                      },
                      selected: position == 4 ? true : false,
                    ),
                    DrawerListTile(
                      title: "จัดการรายงาน",
                      icon: const Icon(Icons.report),
                      press: () {
                        setState(() {
                          position = 5;
                        });
                      },
                      selected: position == 5 ? true : false,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: pages[position],
              flex: 5,
            )
          ],
        ),
      ),
    );
  }
}

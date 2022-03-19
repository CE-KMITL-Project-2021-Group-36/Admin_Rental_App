import 'package:admin_rental_app/config/palette.dart';
import 'package:flutter/material.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
    required this.selected,
  }) : super(key: key);

  final String title;
  final Icon icon;
  final VoidCallback press;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0,
      leading: icon,
      title: Text(
        title,
      ),
      textColor: selected == true ? primaryColor : Colors.white54,
      selected: selected,
      selectedColor: primaryColor,
      selectedTileColor: Colors.white,
    );
  }
}

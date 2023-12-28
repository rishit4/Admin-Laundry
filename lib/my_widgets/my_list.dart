import 'package:flutter/material.dart';

class MYListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;

  const MYListTile(
      {super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      onTap: onTap,
      title: Text(
        text,
        style: const TextStyle(
            color: Colors.black, letterSpacing: 2, fontWeight: FontWeight.bold),
      ),
    );
  }
}

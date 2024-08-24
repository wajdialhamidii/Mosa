import 'package:flutter/material.dart';

import '../utils/constants.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.onTap,
    this.onLongPress,
    required this.title,
    required this.imageUrl,
    required this.tagText,
    required this.tagColor,
    required this.subtitle,
  });

  final void Function()? onTap;
  final void Function()? onLongPress;
  final String title;
  final Widget subtitle;
  final String imageUrl;
  final String tagText;
  final Color tagColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        subtitle: subtitle,
        trailing: Container(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
          decoration: BoxDecoration(
              color: tagColor, borderRadius: BorderRadius.circular(50.0)),
          child: Text(
            tagText,
            style: const TextStyle(
              fontSize: 10.0,
              color: kWhiteColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'ibmFont',
            ),
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: kMainColor,
          child: Image.asset(imageUrl),
        ),
        title: Text(title),
      ),
    );
  }
}

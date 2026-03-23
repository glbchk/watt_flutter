import 'package:flutter/material.dart';

class MenuItem {
  final int? id;
  final String title;
  final String? subTitle;
  final IconData? icon;

  MenuItem({this.id, required this.title, this.subTitle, this.icon});
}

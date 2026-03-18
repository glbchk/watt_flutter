// import 'package:flutter/material.dart';
// import 'package:watt/data/models/menu_item_model.dart';
//
// List<MenuItem> menuItems = [
//   MenuItem(id: 1, title: "", icon: Icons.home),
//   MenuItem(id: 2, title: "", icon: Icons.home),
//   MenuItem(id: 3, title: "", icon: Icons.home),
// ];
//
// class DropdownMenuItemWidget extends StatelessWidget {
//   final String label;
//   final VoidCallback onTap;
//
//   const DropdownMenuItemWidget({
//     super.key,
//     required this.label,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownMenuEntry<MenuItem>(
//       value: menuItems,
//       label: label,
//       leadingIcon: ClipOval(
//         child: Container(
//           color: context.theme.appColors.grey4,
//           width: 40,
//           height: 40,
//           child: Icon(
//             size: 24,
//             Icons.location_on_outlined,
//             color: context.theme.appColors.grey2,
//           ),
//         ),
//       ),
//     );
//   }
// }

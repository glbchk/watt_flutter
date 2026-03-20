import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watt/utils/colors.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback onBackPressed;
  final BuildContext context;
  final FocusNode? focusNode;
  final void Function(bool)? onFocusChange;
  final TextEditingController controller;
  final GoogleMapController? mapController;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final VoidCallback onIconPressed;

  const SearchBarWidget({
    super.key,
    required this.onBackPressed,
    required this.context,
    this.focusNode,
    required this.onFocusChange,
    required this.controller,
    required this.mapController,
    this.onSubmitted,
    this.onChanged,
    required this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.theme.appColors.background,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: context.theme.appColors.onSecondary.withAlpha(38),
                spreadRadius: 0,
                blurRadius: 15,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(5),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: onBackPressed,
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: context.theme.appColors.background,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: context.theme.appColors.onSecondary.withAlpha(38),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search),

                const SizedBox(width: 10),

                Expanded(
                  child: Focus(
                    onFocusChange: onFocusChange,
                    child: TextField(
                      focusNode: focusNode,
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Search location",
                        border: InputBorder.none,
                      ),
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onIconPressed,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

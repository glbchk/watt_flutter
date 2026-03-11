import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watt/utils/colors.dart';

import '../../presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_available_hours_property_page.dart';

class UiHelperMethods {
  static OverlayEntry? removeOverlay(OverlayEntry? overlayEntry) {
    if (overlayEntry != null && overlayEntry.mounted) {
      overlayEntry.remove();
    }
    return null;
  }

  static OverlayEntry showOverlay({
    required BuildContext context,
    required LayerLink layerLink,
    required List<String> suggestions,
    required TextEditingController controller,
    required FocusNode focusNode,
    required VoidCallback onDismiss,
  }) {
    final overlay = Overlay.of(context);

    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  focusNode.unfocus();
                  onDismiss();
                },
              ),
            ),

            Positioned(
              width: MediaQuery.of(context).size.width - 40,
              child: CompositedTransformFollower(
                link: layerLink,
                offset: const Offset(0, 84),
                showWhenUnlinked: false,
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: context.theme.appColors.onSecondary.withAlpha(
                            38,
                          ),
                          spreadRadius: 0,
                          blurRadius: 15,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: suggestions.length + 1,
                      itemBuilder: (context, index) {
                        if (index == suggestions.length) {
                          return ListTile(
                            minTileHeight: 60,
                            leading: ClipOval(
                              child: Container(
                                color: context.theme.appColors.grey4,
                                width: 40,
                                height: 40,
                                child: Icon(
                                  size: 24,
                                  Icons.my_location,
                                  color: context.theme.appColors.primary,
                                ),
                              ),
                            ),
                            title: const Text("Use my current location"),
                            onTap: () {
                              focusNode.unfocus();
                              onDismiss();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailAvailableHoursPropertyPage(),
                                ),
                              );
                            },
                          );
                        }

                        final suggestion = suggestions[index];

                        return Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: ListTile(
                            minTileHeight: 60,
                            leading: ClipOval(
                              child: Container(
                                color: context.theme.appColors.grey4,
                                width: 40,
                                height: 40,
                                child: Icon(
                                  size: 24,
                                  Icons.location_on_outlined,
                                  color: context.theme.appColors.grey2,
                                ),
                              ),
                            ),
                            title: Text(suggestion),
                            onTap: () {
                              controller.text = suggestion;
                              focusNode.unfocus();
                              onDismiss();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(overlayEntry);

    return overlayEntry;
  }

  static Future<void> pickDate({
    required BuildContext context,
    required DateTime? initialDate,
    required TextEditingController controller,
    required Function(DateTime) onDateSelected,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      // Apply your Watt theme colors to the picker
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.theme.appColors.primary,
              onPrimary: Colors.white,
              onSurface: context.theme.appColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Format the date for the text field
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
      onDateSelected(picked);
    }
  }
}

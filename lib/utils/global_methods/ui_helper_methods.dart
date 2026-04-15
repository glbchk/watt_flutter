import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/extra_pages/choose_location_on_map_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

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
    final overlay = Overlay.of(context, rootOverlay: true);

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
                                  builder: (_) => ChooseLocationOnMapPage(
                                    autoDetectMyLocation: true,
                                  ),
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

  static Widget buildCarOptionsShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.theme.appColors.grey4.withValues(alpha: 0.5),
      highlightColor: context.theme.appColors.background,
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildListOptionsShimmer(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20.0),
      child: Shimmer.fromColors(
        baseColor: context.theme.appColors.grey4.withValues(alpha: 0.5),
        highlightColor: context.theme.appColors.background,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              height: 60,
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 1,
                    color: context.theme.appColors.grey3,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static Future<dynamic> showContactOptions(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              // bottom: 34,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.theme.appColors.background,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 25),
                        child: Column(
                          spacing: 5,
                          children: [
                            Text(
                              "Phone number",
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "046-56-5678904",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        minTileHeight: 56,
                        title: Center(
                          child: Text(
                            "Call",
                            style: TextStyle(
                              color: context.theme.appColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        minTileHeight: 56,
                        title: Center(
                          child: Text(
                            "Send SMS",
                            style: TextStyle(
                              color: context.theme.appColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        minTileHeight: 56,
                        title: Center(
                          child: Text(
                            "Send email",
                            style: TextStyle(
                              color: context.theme.appColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                WattWhiteButton(
                  label: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

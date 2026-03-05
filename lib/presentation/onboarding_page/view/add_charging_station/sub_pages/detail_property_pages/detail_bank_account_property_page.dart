import 'package:flutter/material.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/extra_pages/add_iban_in_charging_station.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

class DetailBankAccountPropertyPage extends StatefulWidget {
  // final VoidCallback onPress;

  const DetailBankAccountPropertyPage({
    super.key,
    // required this.onPress,
  });

  @override
  State<DetailBankAccountPropertyPage> createState() =>
      _DetailBankAccountPropertyPageState();
}

class _DetailBankAccountPropertyPageState
    extends State<DetailBankAccountPropertyPage> {
  @override
  Widget build(BuildContext context) {
    return DetailsWidget(
      title: 'Bank account',
      content: Container(
        color: context.theme.appColors.background,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Choose IBAN or add new one to recieve earnings\n from your charging station',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            WattWhiteButton(
              label: 'Add IBAN',
              textColor: context.theme.appColors.onSurface,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddIbanInChargingStationPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      onPressed: () {},
    );
  }
}

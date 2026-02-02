import 'package:flutter/material.dart';
import 'package:watt/presentation/onboarding_page/view/add_payment_method/add_credit_card_page.dart';
import 'package:watt/presentation/onboarding_page/view/components/background_gradient.dart';
import 'package:watt/presentation/onboarding_page/view/components/tall_card_button.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/bottom_floating_button.dart';

import '../components/short_header_onboarding.dart';

class AddPaymentMethodPage extends StatefulWidget {
  const AddPaymentMethodPage({super.key});

  @override
  State<AddPaymentMethodPage> createState() => _AddPaymentMethodPageState();
}

class _AddPaymentMethodPageState extends State<AddPaymentMethodPage> {
  final double marginSize = 15.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: ShortHeaderOnboarding(
            mainTitle: 'Add your charger station',
            subtitle: 'Select your charger',
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            BackgroundGradient(
              bgHeight: 0.28,
            ),
            Transform.translate(
              offset: Offset(0, -40),
              child: Column(
                children: [
                  TallCardButton(
                    label: 'Credit Card',
                    svgImage: KCardIcons.paymentMethod,
                    iconColor: wattColorScheme.primary,
                    marginDistance: marginSize,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddCreditCardPage(),
                        ),
                      );
                    },
                  ),
                  TallCardButton(
                    label: 'IBAN',
                    svgImage: KCardIcons.paymentMethod,
                    iconColor: wattColorScheme.primary,
                    marginDistance: marginSize,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomFloatingButton(
        label: 'Complete later',
        callback: () {},
      ),
    );
  }
}

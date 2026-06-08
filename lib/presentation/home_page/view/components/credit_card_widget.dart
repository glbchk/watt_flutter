import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:watt/utils/colors.dart';

class CreditCardWidget extends StatelessWidget {
  final String? bg;
  final String? networkLogo;
  final String? cardNumber;
  final String? cardHolder;
  final String? expiry;
  final String? cvv;

  const CreditCardWidget({
    super.key,
    this.bg,
    this.networkLogo,
    this.cardNumber,
    this.cardHolder,
    this.expiry,
    this.cvv,
  });

  @override
  Widget build(BuildContext context) {
    final rawCardNumber = cardNumber ?? '';
    final lastFour = rawCardNumber.length >= 4
        ? rawCardNumber.substring(rawCardNumber.length - 4)
        : rawCardNumber;
    final fourDigitsFormatted = lastFour.split('').join(' ');

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(
            bg ?? 'No path found',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  networkLogo ?? 'No path found',
                  height: 45,
                  width: 45,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ...List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 28.0,
                    ),
                    child: Text(
                      '● ● ● ●',
                      style: TextStyle(
                        color: context.theme.appColors.onPrimary,
                        fontSize: 13,
                      ),
                    ),
                  );
                }),
                Flexible(
                  child: Text(
                    fourDigitsFormatted,
                    // fourDigitsFormatted,
                    style: TextStyle(
                      color: context.theme.appColors.onPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 28),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      'Card Holder'.toUpperCase(),
                      style: TextStyle(
                        color: context.theme.appColors.onPrimary,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      cardHolder ?? 'Joe Smith',
                      style: TextStyle(
                        color: context.theme.appColors.onPrimary,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 124),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      'Expires'.toUpperCase(),
                      style: TextStyle(
                        color: context.theme.appColors.onPrimary,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      expiry ?? '1/11',
                      style: TextStyle(
                        color: context.theme.appColors.onPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

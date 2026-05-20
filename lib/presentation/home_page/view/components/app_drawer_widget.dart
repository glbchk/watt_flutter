import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppDrawer extends StatelessWidget {
  final String? name;
  final String? email;
  final String? profileImageUrl;
  final void Function()? onPressedProfile;
  final void Function()? onPressedBookings;
  final void Function()? onPressedMyChargings;
  final void Function()? onPressedMyCars;
  final void Function()? onPressedYourCharger;
  final void Function()? onPressedPaymentMethod;
  final void Function()? onPressedInviteFriends;
  final void Function()? onPressedHelp;
  final void Function()? onPressedFeedback;
  final void Function()? onPressedLogout;

  const AppDrawer({
    super.key,
    this.name,
    this.email,
    this.profileImageUrl,
    this.onPressedProfile,
    this.onPressedBookings,
    this.onPressedMyChargings,
    this.onPressedMyCars,
    this.onPressedYourCharger,
    this.onPressedPaymentMethod,
    this.onPressedInviteFriends,
    this.onPressedHelp,
    this.onPressedFeedback,
    this.onPressedLogout,
  });

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = MediaQuery.of(context).size.width;

    return Drawer(
      elevation: 0,
      backgroundColor: Colors.transparent,
      width: drawerWidth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: drawerWidth - 75,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      left: 35,
                      bottom: 30,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(
                        0xFF007AFF,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: SvgPicture.asset(
                            profileImageUrl ?? 'assets/icons/profile.svg',
                            height: 50,
                            width: 50,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          name ?? 'Joe Doe',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email ?? 'carson@mobility.com',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 15,
                      ),
                      children: [
                        _buildMenuItem(
                          Icons.person_outline,
                          'Profile',
                          () {
                            onPressedProfile?.call();
                          },
                        ),
                        _buildMenuItem(
                          Icons.calendar_today_outlined,
                          'Bookings',
                          () {
                            onPressedBookings?.call();
                          },
                        ),
                        _buildMenuItem(
                          Icons.electric_bolt_outlined,
                          'My chargings',
                          () {
                            onPressedMyChargings?.call();
                          },
                        ),
                        _buildMenuItem(
                          Icons.directions_car_outlined,
                          'My cars',
                          () {
                            onPressedMyCars?.call();
                          },
                        ),
                        _buildMenuItem(
                          Icons.list_alt_outlined,
                          'List your charger',
                          () {
                            onPressedYourCharger?.call();
                          },
                        ),
                        _buildMenuItem(
                          Icons.credit_card_outlined,
                          'Payment methods',
                          () {
                            onPressedPaymentMethod?.call();
                          },
                        ),
                        _buildMenuItem(
                          Icons.send_outlined,
                          'Invite friends',
                          () {
                            onPressedInviteFriends?.call();
                          },
                        ),
                        _buildMenuItem(Icons.help_outline, 'Help', () {
                          onPressedHelp?.call();
                        }),
                        _buildMenuItem(
                          Icons.chat_bubble_outline,
                          'Feedback',
                          () {
                            onPressedFeedback?.call();
                          },
                        ),

                        SizedBox(height: 10),

                        _buildMenuItem(Icons.logout, 'Sign out', () {
                          Navigator.pop(context);
                          onPressedLogout?.call();
                        }),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 35, bottom: 35),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'App V1.d666',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(
              context,
            ).viewPadding.top,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10),
                  ],
                ),
                child: const Icon(Icons.close, color: Colors.black, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      minTileHeight: 50,
      leading: Icon(
        icon,
        color: Colors.grey.shade600,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}

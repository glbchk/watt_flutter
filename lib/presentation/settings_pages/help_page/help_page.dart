import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/home_page/bloc/home_cubit.dart';
import 'package:watt/presentation/home_page/bloc/home_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/accordion_widget.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchFaq();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final faq = state.faq ?? [];

        return DefaultAppBar(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: false,
          title: 'Do you need help?',
          titleColor: context.theme.appColors.onPrimary,
          foregroundColor: context.theme.appColors.onPrimary,
          appBarBackgroundColor: context.theme.appColors.primary,
          scaffoldBackgroundColor: context.theme.appColors.background,
          //TODO: Fix loading states everywhere in the app
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.theme.appColors.background,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...List.generate(
                                faq.length,
                                (index) {
                                  return AccordionWidget(
                                    label: faq.elementAt(index).question,
                                    secondLabel: faq
                                        .elementAt(
                                          index,
                                        )
                                        .answer,
                                    onPressed: () {},
                                  );
                                },
                              ),
                              SizedBox(height: 80),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 34.0),
                                child: Column(
                                  spacing: 10,
                                  children: [
                                    Text(
                                      "Need help? We’re here for you",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      'Tell us what’s going on and we’ll get back to you as soon as possible',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: context.theme.appColors.grey1,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    WattMainButton(
                                      label: 'Send message',
                                      onPressed: () {
                                        context.read<HomeCubit>().sendEmail();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}

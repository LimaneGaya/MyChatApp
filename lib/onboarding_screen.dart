import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapp/auth/provider/auth_provider.dart';
import 'package:mychatapp/auth/screens/auth_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mychatapp/home_screen.dart';

class OnboadringScreen extends StatelessWidget {
  OnboadringScreen({super.key});
  final pageCont = PageController(initialPage: 0);
  final pageCount = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: pageCont,
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Center(
                    child: GradientText(
                      AppLocalizations.of(context)!.meetpeople,
                      textAlign: TextAlign.center,
                      gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.pink],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.purple)),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Text(
                    AppLocalizations.of(context)!.gettoknow,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        pageCont.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      final List<Widget> wdgts = [];
                      for (int i = 0; i <= pageCount; i++) {
                        wdgts.add(Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                                    .withValues(alpha: 0 == i ? 0.9 : 0.4))));
                      }
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: wdgts);
                    },
                  ),
                ],
              ),
            )),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Center(
                    child: GradientText(
                      AppLocalizations.of(context)!.matchwithpeople,
                      textAlign: TextAlign.center,
                      gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.pink],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.purple)),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Text(
                    AppLocalizations.of(context)!.tryluck,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        pageCont.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      final List<Widget> wdgts = [];
                      for (int i = 0; i <= pageCount; i++) {
                        wdgts.add(Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                                    .withValues(alpha: 1 == i ? 0.9 : 0.4))));
                      }
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: wdgts);
                    },
                  ),
                ],
              ),
            )),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Center(
                    child: GradientText(
                      AppLocalizations.of(context)!.gotissue,
                      textAlign: TextAlign.center,
                      gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.pink],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.purple)),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Text(
                    AppLocalizations.of(context)!.aiwillhelp,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        pageCont.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      },
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      final List<Widget> wdgts = [];
                      for (int i = 0; i <= pageCount; i++) {
                        wdgts.add(Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                                    .withValues(alpha: 2 == i ? 0.9 : 0.4))));
                      }
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: wdgts);
                    },
                  ),
                ],
              ),
            )),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Center(
                    child: GradientText(
                      AppLocalizations.of(context)!.readytostart,
                      textAlign: TextAlign.center,
                      gradient: const LinearGradient(
                          colors: [Colors.purple, Colors.pink],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.purple)),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Text(
                    AppLocalizations.of(context)!.getstartednow,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Consumer(
                      builder: (context, ref, child) => ElevatedButton(
                          onPressed: () {
                            ref
                                .read(sharedPrefProvider)
                                .value!
                                .setBool('onboarding', false);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AuthScreen()));
                          },
                          child:
                              Text(AppLocalizations.of(context)!.getstarted)),
                    )
                  ]),
                  Builder(
                    builder: (context) {
                      final List<Widget> wdgts = [];
                      for (int i = 0; i <= pageCount; i++) {
                        wdgts.add(Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                                    .withValues(alpha: 3 == i ? 0.9 : 0.4))));
                      }
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: wdgts);
                    },
                  ),
                ],
              ),
            ))
          ],
        ),
        floatingActionButton: Consumer(
          builder: (context, ref, child) => PopupMenuButton(
            child: const Icon(Icons.language),
            onSelected: (value) {
              ref.read(localProvider.notifier).state = Locale(value);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'fr', child: Text('French')),
              PopupMenuItem(value: 'ar', child: Text('Arabic')),
            ],
          ),
        ));
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.center,
    required this.gradient,
  });
  final String text;
  final TextStyle? style;
  final Gradient gradient;
  final TextAlign textAlign;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}

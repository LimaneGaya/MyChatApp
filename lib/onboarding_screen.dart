import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapp/auth/provider/auth_provider.dart';
import 'package:mychatapp/auth/screens/auth_screen.dart';

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
                    'Get to meet interesting people all around the world',
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
                const Text(
                  'Get to know people from all around the world',
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
                                  .withOpacity(0 == i ? 0.9 : 0.4))));
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
                    'Match with people from all around the world',
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
                const Text(
                  'Try your luck, match with people from all'
                  ' around the world, maybe it\'s the start '
                  'of something beautiful',
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
                                  .withOpacity(1 == i ? 0.9 : 0.4))));
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
                    'Got issue? Ask AI for help',
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
                const Text(
                  'In App AI will help you with all sort of issues',
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
                                  .withOpacity(2 == i ? 0.9 : 0.4))));
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
                    'Ready to get started?',
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
                const Text(
                  'Get started now!',
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
                        child: const Text('Get Started')),
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
                                  .withOpacity(3 == i ? 0.9 : 0.4))));
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
    );
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

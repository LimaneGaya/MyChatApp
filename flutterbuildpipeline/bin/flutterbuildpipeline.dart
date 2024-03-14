import 'dart:io';

import 'package:args/args.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help.')
    ..addFlag('web',
        abbr: 'd', negatable: false, help: 'build a web application.')
    ..addFlag('apk',
        abbr: 'r', negatable: false, help: 'build an apk application.')
    ..addFlag(
      'deploy',
      negatable: false,
      help: 'Deploy the web application.',
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: dart flutterbuildpipeline.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);

    if (results.wasParsed('help')) return printUsage(argParser);

    if (results.wasParsed('web')) return web();
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}

void web() async {
  int major = 0, minor = 0, patch = 0;
  await File('version').readAsString().then((v) {
    final parts = v.split('.');
    major = int.parse(parts[0]);
    minor = int.parse(parts[1]);
    patch = int.parse(parts[2]);
  });
  await File('version').writeAsString('$major.$minor.${patch + 1}');
  Process pros = await Process.start(
      'flutter',
      [
        'build',
        'web',
        '--release',
        '--web-renderer=canvaskit',
        '--build-name=$major.$minor.$patch',
      ],
      runInShell: true);
  stdout.addStream(pros.stdout);
  stderr.addStream(pros.stderr);
  await pros.exitCode;
  stdout.writeln('Pushing to Firebase');
  pros = await Process.start('firebase', ['deploy'], runInShell: true);
  stdout.addStream(pros.stdout);
  stderr.addStream(pros.stderr);
  await pros.exitCode;
}
/* 
'build',
        'web',
        '--release',
        '--web-renderer=canvaskit',
        '--build-name=$major.$minor.$patch',
        '--build-number=1' */
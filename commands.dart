import 'dart:io';

void main(List<String> args) async {
  if (args[0] == 'debug') debug(args);
  if (args[0] == 'release') release(args);
}

void debug(List<String> args) {
  final file = File('version');
  final versioning = file.readAsStringSync().split(' ');
  final int buildNumber = int.parse(versioning[1]) + 1;
  file.writeAsStringSync('${versioning[0]} $buildNumber');
  Process.run('flutter', ['run', '-d', args[1]]).asStream().listen((event) {
    stdout.write(event.stdout);
  });
}

void release(List<String> args) {
  final file = File('version');
  final versioning = file.readAsStringSync().split(' ');
  final List<int> version =
      versioning[0].split('.').map((e) => int.parse(e)).toList();
  if (args.contains('M')) {
    version[0] = version[0] + 1;
  } else if (args.contains('m')) {
    version[1] = version[1] + 1;
  } else {
    version[2] = version[2] + 1;
  }

  final int buildNumber = int.parse(versioning[1]) + 1;
  final String buildName = '${version[0]}.${version[1]}.${version[2]}';
  file.writeAsStringSync('$buildName $buildNumber');
  Process.run(
          'flutter',
          [
            'build',
            'apk',
            '--split-per-abi',
            '--release',
            '--build-name=$buildName',
            '--target-platform',
            'android-arm',
            '--obfuscate',
            '--split-debug-info=debugInfo/v$buildName/'
          ],
          runInShell: true)
      .asStream()
      .listen((event) {
    stdout.write(event.stdout);
    stderr.write(event.stderr);
  });
}

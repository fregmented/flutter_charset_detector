import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_charset_detector/flutter_charset_detector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const channel = MethodChannel('flutter_charset_detector');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (methodCall) async {
      switch (methodCall.method) {
        case 'autoDecode':
          final args = methodCall.arguments as Map;
          return {
            'string': utf8.decode(args['data'] as Uint8List),
            'charset': utf8.name,
          };
        case 'detect':
          return 'utf-8';
        default:
          throw PlatformException(code: 'foo');
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('testAutoDecode', () async {
    const string = 'blah';
    final bytes = Uint8List.fromList(utf8.encode(string));
    final result = await CharsetDetector.autoDecode(bytes);
    expect(result.charset, 'utf-8');
    expect(result.string, string);
  });
  test('testDetect', () async {
    const string = 'blah';
    final bytes = Uint8List.fromList(utf8.encode(string));
    final result = await CharsetDetector.detect(bytes);
    expect(result, 'utf-8');
  });
}

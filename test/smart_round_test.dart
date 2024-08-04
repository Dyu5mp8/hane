import 'package:flutter_test/flutter_test.dart';
import  'package:hane/utils/smart_rounder.dart' as sr;

void main() {
  group('testing rounding', () {
    test('initializes with all parameters', () {
      print(sr.smartRound(1200));
      print(sr.smartRound(1.23));
      print(sr.smartRound(0.0013));
      print(sr.smartRound(0.001));
      print(sr.smartRound(0.0001));
      print(sr.smartRound(0.0000100000));
      print(sr.smartRound(0.0313000));



    });
  });
}
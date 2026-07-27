import 'package:flutter_test/flutter_test.dart';
import 'package:rivermouth_scheduler/core/utils/id_generator.dart';

void main() {
  test('generateId produces non-empty, distinct values', () {
    final a = generateId();
    final b = generateId();
    expect(a, isNotEmpty);
    expect(a, isNot(equals(b)));
  });
}

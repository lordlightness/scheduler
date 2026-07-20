/// Generates a lightweight unique ID without pulling in an external package.
/// Good enough for local, single-device Hive records.
String generateId() {
  final micros = DateTime.now().microsecondsSinceEpoch;
  final rand = (micros * 31) % 100000;
  return '$micros$rand';
}

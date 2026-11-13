import 'package:fl_clash/common/port_probe.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reserved mixed ports exclude common service ports', () {
    for (final port in [53, 80, 443, 7890, 7891, 7892, 8080, 9090, 9091]) {
      expect(isReservedMixedPort(port), isTrue);
    }
    expect(isReservedMixedPort(17890), isFalse);
  });

  test('port conflict detection recognizes bind errors only', () {
    expect(
      isPortConflictError(Exception('bind: address already in use')),
      isTrue,
    );
    expect(isPortConflictError(Exception('connection refused')), isFalse);
  });
}

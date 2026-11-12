import 'package:fl_clash/common/report_redaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('redacts sensitive YAML fields and authorization headers', () {
    final report = redactReport('''
proxies:
  - name: test
    password: hunter2
    uuid: 123e4567-e89b-12d3-a456-426614174000
    private-key: secret-key
auth: bearer-value
Authorization: Bearer abc
cookie: sid=abc
headers: {"Authorization": "Bearer inline-secret", "Cookie": "sid=inline"}
''');

    expect(report, contains('password: ***'));
    expect(report, contains('uuid: ***'));
    expect(report, contains('private-key: ***'));
    expect(report, contains('Authorization: ***'));
    expect(report, contains('cookie: ***'));
    expect(report, isNot(contains('inline-secret')));
    expect(report, isNot(contains('sid=inline')));
    expect(report, isNot(contains('hunter2')));
    expect(report, isNot(contains('bearer-value')));
  });

  test('redacts URL credentials, query values, and long path tokens', () {
    final report = redactReport(
      'https://user:pass@example.test/subscription/abcdEFGH0123456789?token=secret&x=1',
    );

    expect(report, 'https://***@example.test/subscription/***?token=***&x=***');
    expect(report, isNot(contains('secret')));
  });

  test('redacts PEM private key blocks in log text', () {
    final report = redactReport(
      'loaded -----BEGIN PRIVATE KEY-----\nraw-secret\n-----END PRIVATE KEY----- done',
    );

    expect(report, 'loaded *** done');
  });

  test('redacts inline secrets in log lines', () {
    final report = redactReport(
      'request auth token=inline-token uuid=123e4567-e89b-12d3-a456-426614174000 password=log-pass',
    );

    expect(report, isNot(contains('inline-token')));
    expect(report, isNot(contains('log-pass')));
    expect(report, isNot(contains('123e4567')));
  });

  test('redacts proxy share links whole', () {
    final report = redactReport(
      'import ss://YWVzLTI1Ni1nY206c2VjcmV0@1.2.3.4:8388#jp '
      'vmess://eyJpZCI6InZtZXNzLWlkIn0= '
      'trojan://trojan-pass@example.com:443?sni=example.com '
      'hysteria2://hy-pass@example.com:443',
    );

    expect(report, contains('ss://***'));
    expect(report, contains('vmess://***'));
    expect(report, isNot(contains('YWVzLTI1Ni1nY206c2VjcmV0')));
    expect(report, isNot(contains('eyJpZCI6')));
    expect(report, isNot(contains('trojan-pass')));
    expect(report, isNot(contains('hy-pass')));
  });
}

import 'package:flutter_project_template/features/webview/domain/entities/js_bridge_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JsBridgeMessage', () {
    test('creates message with required fields', () {
      const message = JsBridgeMessage(
        type: 'navigation',
        data: {'url': 'https://example.com'},
      );

      expect(message.type, equals('navigation'));
      expect(message.data, containsPair('url', 'https://example.com'));
      expect(message.messageId, isNull);
      expect(message.timestamp, isNull);
    });

    test('creates message with all fields', () {
      final now = DateTime.now();
      final message = JsBridgeMessage(
        type: 'action',
        data: const {'action': 'click', 'target': 'button'},
        messageId: '123',
        timestamp: now,
      );

      expect(message.type, equals('action'));
      expect(message.data, containsPair('action', 'click'));
      expect(message.messageId, equals('123'));
      expect(message.timestamp, equals(now));
    });

    test('fromJson creates message correctly', () {
      final json = {
        'type': 'event',
        'data': {'key': 'value'},
        'messageId': '456',
        'timestamp': 1234567890000,
      };

      final message = JsBridgeMessage.fromJson(json);

      expect(message.type, equals('event'));
      expect(message.data, containsPair('key', 'value'));
      expect(message.messageId, equals('456'));
      expect(message.timestamp,
          equals(DateTime.fromMillisecondsSinceEpoch(1234567890000)),);
    });

    test('toJson serializes message correctly', () {
      final now = DateTime.now();
      final message = JsBridgeMessage(
        type: 'response',
        data: const {'status': 'success'},
        messageId: '789',
        timestamp: now,
      );

      final json = message.toJson();

      expect(json['type'], equals('response'));
      expect(json['data'], containsPair('status', 'success'));
      expect(json['messageId'], equals('789'));
      expect(json['timestamp'], equals(now.millisecondsSinceEpoch));
    });

    test('copyWith creates new message with updated values', () {
      const original = JsBridgeMessage(
        type: 'request',
        data: {'key': 'value'},
      );
      final updated = original.copyWith(
        type: 'response',
        messageId: 'new-id',
      );

      expect(original.type, equals('request'));
      expect(updated.type, equals('response'));
      expect(updated.messageId, equals('new-id'));
      expect(updated.data, containsPair('key', 'value'));
    });

    test('equality compares all fields', () {
      const message1 = JsBridgeMessage(
        type: 'test',
        data: {'key': 'value'},
        messageId: '1',
      );
      const message2 = JsBridgeMessage(
        type: 'test',
        data: {'key': 'value'},
        messageId: '1',
      );
      const message3 = JsBridgeMessage(
        type: 'test',
        data: {'key': 'different'},
        messageId: '1',
      );

      expect(message1, equals(message2));
      expect(message1, isNot(equals(message3)));
    });
  });
}

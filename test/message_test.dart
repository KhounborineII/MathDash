import 'package:flutter_test/flutter_test.dart';
import 'package:math_dash/communication.dart';

void main() {

  test('A message can be created', () {
    Message message = Message(0, MessageType.invite, {'host': 'test'});
    expect(message.version, 0);
    expect(message.type, MessageType.invite);
    expect(message.value, {'host': 'test'});
  });

  test('a message can be converted to and from JSON without data loss', () {
    Message message = Message(0, MessageType.rsvp, {'response': true, 'seed': 123});
    var encodedMessage = message.toJson();
    Message decodedMessage = Message.fromJson(encodedMessage);
    expect(decodedMessage.version, message.version);
    expect(decodedMessage.type, message.type);
    expect(decodedMessage.value, message.value);
  });
}
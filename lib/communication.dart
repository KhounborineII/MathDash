enum MessageType {
  invite,
  ignore,
  rsvp,
  update,
  end;
}

class Message {

  Message(this._version, this._type, this._value);
  late final int _version;
  late final MessageType _type;
  late final Map<String, dynamic> _value;

  int get version => _version;
  MessageType get type => _type;
  Map<String, dynamic> get value => _value;

  // https://stackoverflow.com/questions/27236629 for serializing enum states
  Map<String, dynamic> toJson() {
    return {'version': _version, 'type': _type.index, 'value': _value};
  }

  Message.fromJson(Map<String, dynamic> json)
    : _version = json['version'],
      _type = MessageType.values[json['type']],
      _value = json['value'];
}
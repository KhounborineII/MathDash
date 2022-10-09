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

  Map<String, dynamic> toJson() {
    Map<String, dynamic> valueToReturn = 
      _type == MessageType.invite ? {'host': _value} :
      _type == MessageType.rsvp   ? {'response': _value == -1, 'seed': _value} :
      _type == MessageType.update ? {'new_score': _value} :
      _type == MessageType.end    ? {'final_score': _value} :
      {};
    return {'version': _version, 'type': _type, 'value': valueToReturn};
  }

  Message.fromJson(Map<String, dynamic> json)
    : _version = json['version'],
      _type = json['type'],
      _value = 
        json['type'] == MessageType.invite ? json['value']['host'] :
        json['type'] == MessageType.rsvp   ? json['value']['seed'] :
        json['type'] == MessageType.update ? json['value']['new_score'] :
        json['type'] == MessageType.end    ? json['value']['final_score']:
        null;
}
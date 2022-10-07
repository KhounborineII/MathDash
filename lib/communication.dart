class Message {

  Message(this._version, this._type, this._value);
  late final int _version;
  late final String _type;
  late final dynamic _value;

  int get version => _version;
  String get type => _type;
  dynamic get value => _value;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> valueToReturn = 
      _type == 'invite' ? {'host': _value} :
      _type == 'rsvp'   ? {'response': _value == -1, 'seed': _value} :
      _type == 'update' ? {'new_score': _value} :
      _type == 'end'    ? {'final_score': _value} :
      {};
    return {'version': _version, 'type': _type, 'value': valueToReturn};
  }

  Message.fromJson(Map<String, dynamic> json)
    : _version = json['version'],
      _type = json['type'],
      _value = 
        json['type'] == 'invite' ? json['value']['host'] :
        json['type'] == 'rsvp'   ? json['value']['seed'] :
        json['type'] == 'update' ? json['value']['new_score'] :
        json['type'] == 'end'    ? json['value']['final_score']:
        null;
}


class BusMessageMember {
  BusMessageMember(this._type, this._name);

  Type get type => _type;
  String get name => _name;

  final Type _type;
  final String _name;
}

class BusMessage {
  BusMessage(this._members);
  final List<BusMessageMember> _members;
}
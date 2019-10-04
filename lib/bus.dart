void main() {
  BusMessage("SampleData", {
    "b": bool,
    "i": int,
    "x": double,
    "y": double,
    "s": String,
  });
  BusMessage.byType("CapstanVelocity", double);

  BusMessage.listAll();

  test();

}



class BusMessage {
  BusMessage.byType(final String name, Type type) {
    BusMessage(name, {lowercaseFirst(name): type});
  }

  BusMessage(final String messageTypeName, final Map<String, Type> members) {
    //  enforce upper case for message types
    String name = uppercaseFirst(messageTypeName);

    //  enforce unique name for the message type
    if (_allBusMessages.containsKey(name)) {
      throw new Exception("BusMessage duplicate: " + name);
    }

    //  enforce a limited number of types for message content
    members.forEach((s, type) {
      if (type != bool && type != int && type != double && type != String)
        throw new Exception("BusMessage type not allowed: " + type.toString());
    });
    _name = name;
    _members = members;
    _allBusMessages.putIfAbsent(name, () => this);
  }

  static void listAll() {
    _allBusMessages.forEach((n, m) => m._list());
  }

  void _list() {
    //  write dart class declaration
    print("class " + _name + " extends Immutable" + _name + " {");
    _members.forEach((member, type) {
      print("  set " +
          member +
          "(" +
          type.toString() +
          " value) => _" +
          member +
          " = value;");
    });

    print("");
    print("  Immutable" + _name + " getImmutable() {");
    print("    Immutable" + _name + " ret = new Immutable" + _name + "();");
    _members.forEach((member, type) {
      print("    ret._" + member + " = _" + member + ";");
    });
    print("    return ret;");
    print("  }");

    print("}");

    //  write dart immutable class declaration
    print("");
    print("class Immutable" + _name + " {");
    _members.forEach((member, type) {
      print("  " + type.toString() + " get " + member + " => _" + member + ";");
    });
    print("");
    _members.forEach((member, type) {
      print("  " + type.toString() + " _" + member + ";");
    });
    print("}");
  }

  /// String utility
  static String uppercaseFirst(String s) {
    if (s == null || s.length < 1) return s;
    return s.substring(0, 1).toUpperCase() + s.substring(1);
  }

  /// String utility
  static String lowercaseFirst(String s) {
    if (s == null || s.length < 1) return s;
    return s.substring(0, 1).toLowerCase() + s.substring(1);
  }

  String _name;
  Map<String, Type> _members;

  static Map<String, BusMessage> _allBusMessages = {};
}

void test(){

  SampleData data = new SampleData();
  data.i = 345;
  print(data.i);
  print(data.y);
  print(data._i);
  ImmutableSampleData imData = data.getImmutable();
  print(imData.i);
  print(imData.y);
  print(imData._i);
  data.i = 0;
  print(imData.i);
  print(imData.y);
  print(imData._i);
  print(data.i);
  print(data.y);
  print(data._i);
}

//  test output classes here

class SampleData extends ImmutableSampleData {
  set b(bool value) => _b = value;

  set i(int value) => _i = value;

  set x(double value) => _x = value;

  set y(double value) => _y = value;

  set s(String value) => _s = value;

  ImmutableSampleData getImmutable() {
    ImmutableSampleData ret = new ImmutableSampleData();
    ret._b = _b;
    ret._i = _i;
    ret._x = _x;
    ret._y = _y;
    ret._s = _s;
    return ret;
  }
}

class ImmutableSampleData {
  bool get b => _b;

  int get i => _i;

  double get x => _x;

  double get y => _y;

  String get s => _s;

  bool _b;
  int _i;
  double _x;
  double _y;
  String _s;
}

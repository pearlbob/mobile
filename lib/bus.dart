

void main() {

  BusMessageType("SampleData", {
    "b": bool,
    "i": int,
    "x": double,
    "y": double,
    "s": String,
  });
  BusMessageType.byType("CapstanVelocity", double);

  BusMessageType.listAll();

  test();
}

class BusMessageMember {
  BusMessageMember(this._name, this._type) ;

  String get name => _name;

  Type get type => _type;

  final String _name;
  final Type _type;
}

class BusMessageType {
  BusMessageType.byType(final String name, Type type) {
    BusMessageType(name, {lowercaseFirst(name): type});
  }

  BusMessageType(
      final String messageTypeName, final Map<String, Type> members) {
    //  enforce upper case for message types
    String name = uppercaseFirst(messageTypeName);

    //  enforce unique name for the message type
    if (_allBusMessages.containsKey(name)) {
      throw new Exception("BusMessage duplicate: " + name);
    }

    //  enforce a limited number of types for message content
    members.forEach((s, type) {
      if (type != bool && type != int && type != double && type != String)
        throw new Exception("BusMessageType: $name: type not allowed: " + type.toString());
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
    print("class $_name {");
    _members.forEach((member, type) {
      print("  " + type.toString() + " " + member + ";");
    });

    print("");
    print("  Immutable" + _name + " getImmutable() {");
    print("    Immutable" + _name + " ret = new Immutable" + _name + "();");
    _members.forEach((member, type) {
      print("    ret._" + member + " = " + member + ";");
    });
    print("    return ret;");
    print("  }");

    print("}");

    //  write dart immutable class declaration
    print("");
    print("class Immutable" + _name + " {");
    print("  //  public read access");
    _members.forEach((member, type) {
      print("  " + type.toString() + " get " + member + " => _" + member + ";");
    });
    print("");
    print("  //  private values");
    _members.forEach((member, type) {
      print("  " + type.toString() + " _" + member + ";");
    });

    print("");
    print("  ///  used for diagnostics.");
    print(
        "  ///  note that since the class is immutable, the values will not change.");
    print("  List<BusMessageValue> busMessageValues() {");
    print("    if (_busMessageValues == null) {");
    print("      //  lazy compute");
    print("      _busMessageValues = new List<BusMessageValue>();");
    _members.forEach((member, type) {
      print(
          '      _busMessageValues.add(new BusMessageValue("$member", $type, _$member));');
    });

    print("    }");
    print("  return _busMessageValues;");
    print("  }");
    print("  List<BusMessageValue> _busMessageValues;");

    //List<BusMessageValue> _busMessageValues;

    print("}");
    print("");
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

  static Map<String, BusMessageType> _allBusMessages = {};
}

class BusMessageValue {
  BusMessageValue(this._name, this._type, this._value) ;

  get name => _name;

  get type => _type;

  get value => _value;

  String _name;
  Type _type;
  dynamic _value;
}

void test() {
  SampleData data = new SampleData();

  ImmutableSampleData localVar = data.getImmutable();
  print("localVar" + (localVar.s == null ? " null" : " not null: "+localVar.s) );

  data.i = 345;
  print(data.i);
  print(data.y);
  print(data.i);
  data.x = 1;
  data.y = 2;
  data.s = "bob";

  print("localVar" + (localVar.s == null ? " null" : " not null: "+localVar.s) );
  localVar = data.getImmutable();
  print("localVar" + (localVar.s == null ? " null" : " not null: "+localVar.s) );

  ImmutableSampleData imData = data.getImmutable();
  print(imData.i);
  print(imData.y);
  print(imData.i);
  data.i = 0;
  print(imData.i);
  print(imData.y);
  print(imData.i);
  print(data.i);
  print(data.y);
  print(data.i);

  imData.busMessageValues().forEach((value) {
    print("get(${value.name}) = " +
        value.value.toString() +
        " " +
        value.type.toString());
  });
}

//  test output classes here

class SampleData {
  bool b;
  int i;
  double x;
  double y;
  String s;

  ImmutableSampleData getImmutable() {
    ImmutableSampleData ret = new ImmutableSampleData();
    ret._b = b;
    ret._i = i;
    ret._x = x;
    ret._y = y;
    ret._s = s;
    return ret;
  }
}

class ImmutableSampleData {
  //  public read access
  bool get b => _b;

  int get i => _i;

  double get x => _x;

  double get y => _y;

  String get s => _s;

  //  private values
  bool _b;
  int _i;
  double _x;
  double _y;
  String _s;

  ///  used for diagnostics.
  ///  note that since the class is immutable, the values will not change.
  List<BusMessageValue> busMessageValues() {
    if (_busMessageValues == null) {
      //  lazy compute
      _busMessageValues = new List<BusMessageValue>();
      _busMessageValues.add(new BusMessageValue("b", bool, _b));
      _busMessageValues.add(new BusMessageValue("i", int, _i));
      _busMessageValues.add(new BusMessageValue("x", double, _x));
      _busMessageValues.add(new BusMessageValue("y", double, _y));
      _busMessageValues.add(new BusMessageValue("s", String, _s));
    }
    return _busMessageValues;
  }

  List<BusMessageValue> _busMessageValues;
}

class CapstanVelocity {
  double capstanVelocity;

  ImmutableCapstanVelocity getImmutable() {
    ImmutableCapstanVelocity ret = new ImmutableCapstanVelocity();
    ret._capstanVelocity = capstanVelocity;
    return ret;
  }
}

class ImmutableCapstanVelocity {
  //  public read access
  double get capstanVelocity => _capstanVelocity;

  //  private values
  double _capstanVelocity;

  ///  used for diagnostics.
  ///  note that since the class is immutable, the values will not change.
  List<BusMessageValue> busMessageValues() {
    if (_busMessageValues == null) {
      //  lazy compute
      _busMessageValues = new List<BusMessageValue>();
      _busMessageValues.add(
          new BusMessageValue("capstanVelocity", double, _capstanVelocity));
    }
    return _busMessageValues;
  }

  List<BusMessageValue> _busMessageValues;
}

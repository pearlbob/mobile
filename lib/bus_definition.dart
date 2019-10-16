
import 'package:message_bus/annotations.dart';

part 'bus_definition.g.dart';


@BusMessageType()
class Foo {
  int foo;
  String bar;

  Foo(){ foo = 0; bar = "none";}
//  Foo.bar(this.bar);
//  Foo.foo(this.foo);
}

@BusMessageType()
class SampleData {
  bool b;
  int i;
  double x;
  double y;
  String s;
  bool bobWasHere;
}

@BusMessage("/test/realm/testFoo","Foo")
String path = '/test/realm/testFoo';



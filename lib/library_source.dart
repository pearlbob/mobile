
import 'package:message_bus/annotations.dart';

part 'library_source.g.dart';


@BusMessageType()
class Foo {
  int foo;
  String bar;

//  Foo(){ foo = 0; bar = "none";}
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
  String bobWasHere;
}


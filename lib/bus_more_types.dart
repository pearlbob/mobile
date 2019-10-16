
import 'package:message_bus/annotations.dart';

part 'bus_more_types.g.dart';


@BusMessageType()
class OtherFoo {
  int foo;
  String bar;

  OtherFoo(){ foo = 0; bar = "none other";}
//  OtherFoo.bar(this.bar);
//  OtherFoo.foo(this.foo);
}

@BusMessageType()
class OtherSampleData {
  bool b;
  int i;
  double x;
  double y;
  String s;
  String bobWasHere;
}


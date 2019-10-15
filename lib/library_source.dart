

import 'package:message_bus/annotations.dart';

part 'library_source.g.dart';


@BusMessage()
class FooBusMessage {
  int foo;
  String bar;

  FooBusMessage(this.foo, this.bar);
}

/// annotation type marker
class BusMessageType {
  const BusMessageType();
}
/// annotation message marker
class BusMessage {
  const BusMessage(this.location,this.busMessageType);
  final String location;  //  fixme: should not be a string
  final String busMessageType; //  fixme: should not be a string
}


abstract class ImmutableBusMessageType {
  //  for bus level diagnostics
  Map<String, dynamic> get map;
}

abstract class MutableBusMessageType {
  ImmutableBusMessageType getImmutable();
}
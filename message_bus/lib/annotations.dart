
/// annotation marker
class BusMessageType {
  const BusMessageType();
}


abstract class ImmutableBusMessageType {
  //  for bus level diagnostics
  Map<String, dynamic> get map;
}

abstract class MutableBusMessageType {
  ImmutableBusMessageType getImmutable();
}
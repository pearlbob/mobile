
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


abstract class ImmutableBusMessageType<T>
//  T is only used for message content type identification
{
  //  for bus level diagnostics
  Map<String, dynamic> get map;
}

class MutableBusMessageType<T, I extends ImmutableBusMessageType<T>> {
  //  note: dart cannot create an instance of generic type T
  //  this has to be done by the code generator
  T value;

  //  will be overridden by the code generator
  I getImmutable() {
    return null;
  }
  void source(){ print('send the message to the bus location from here');}
}
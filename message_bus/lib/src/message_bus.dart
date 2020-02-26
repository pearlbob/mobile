

import '../annotations.dart';

//abstract class BusMessageSource<T extends MutableBusMessageType> {
//  source(){
//    sourceImmutable(value.getImmutable());
//  }
//  sourceImmutable(ImmutableBusMessageType val);
//  T value;
//}
//
//abstract class BusMessageSink<T extends ImmutableBusMessageType> {
//  sink(){}
//  T value;
//}

class BusObject {
  BusObject(this._members);

  List<ImmutableBusMessageType> get members => _members;
  final List<ImmutableBusMessageType> _members;
}



/*

bus usage:

define bus message content types
define bus object with sources and sinks
register with bus
  for a given path
  each sink has delivery type
source messages
  bus: get immutable
  bus: determine priority
  bus: distribute to sinks, based on delivery and priority
sink messages
  bus: copy value to sink
  bus: call sink method
unregister with bus

issues:

isolates based on priority?
  transport of message content to other isolates
system side privileges vs object side privileges
unregister on object delete

 */
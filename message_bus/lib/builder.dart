library message_bus.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/bus_message_generator.dart';

Builder busMessageBuilder(BuilderOptions options) =>
    SharedPartBuilder([BusMessageTypeGenerator()], 'busMessage');
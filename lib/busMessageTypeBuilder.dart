import 'dart:async';

import 'package:build/build.dart';

//	flutter pub run build_runner build

class BusMessageTypeBuilder implements Builder {
  @override
  final buildExtensions = const {
    '.bus': ['.bus.dart']
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Each `buildStep` has a single input.
    var inputId = buildStep.inputId;

    print("BusMessageTypeBuilder.build(): "+inputId.toString());

    // Create a new target `AssetId` based on the old one.
    var copy = inputId.addExtension('.dart');
    var contents = await buildStep.readAsString(inputId);

    String output = "/// generated code\n";
    output += contents;

    // Write out the new asset.
    await buildStep.writeAsString(copy, output);
  }
}


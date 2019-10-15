import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations.dart';

class BusMessageGenerator extends GeneratorForAnnotation<BusMessage> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    print('BusMessageGenerator for ${element.name}');

    final buffer = StringBuffer();
    if (element is ClassElement) {
      buffer
        ..writeln('//  a public immutable class modeled after ${element.name}')
        ..writeln('class Immutable${element.name} {')
        ..writeln('')
        ..writeln('  //')
        ..writeln('  Immutable${element.name}(');
      for (var fieldElement in element.fields) {
        buffer.writeln('    this._${fieldElement.name},');
      }
      buffer
        ..writeln('  );')
        ..writeln()
        ..writeln('  //  public constructor from mutable class')
        ..writeln('  static Immutable${element.name} getImmutable(${element.name} m ) {')
        ..write('    return Immutable${element.name}(');
      for (var fieldElement in element.fields) {
        buffer.writeln('    m.${fieldElement.name},');
      }
//      static ImmutableFooBusMessage getImmutable(FooBusMessage m) {
//        return ImmutableFooBusMessage(
//          m.foo,
//          m.bar,
//        );
//      }
      buffer..writeln('  );')..writeln('  }')..writeln('  //  public getters');
      for (var fieldElement in element.fields) {
        buffer.writeln(
            '  ${fieldElement.type.toString()} get ${fieldElement.name} => _${fieldElement.name};');
      }
      buffer..writeln()..writeln('  //  private values');
      for (var fieldElement in element.fields) {
        buffer.writeln(
            '  final ${fieldElement.type.toString()} _${fieldElement.name};');
      }
      buffer.writeln('}');
    } else {
      throw Exception(
          'a bus message type has to be a class, ${element.name} is not a class!');
    }

    return buffer.toString();
  }

//final Logger log = new Logger('MyClassName');
}

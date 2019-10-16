import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../annotations.dart';

class BusMessageTypeGenerator extends GeneratorForAnnotation<BusMessageType> {
  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    print('BusMessageType generated for ${element.name}');

    final buffer = StringBuffer();
    if (element is ClassElement) {
      //  verify the types match our limited content
      for (var fieldElement in element.fields) {
        if (!fieldElement.type.isDartCoreBool &&
            !fieldElement.type.isDartCoreInt &&
            !fieldElement.type.isDartCoreDouble &&
            !fieldElement.type.isDartCoreString)
          throw Exception(
              'bus message content type cannot be: ${fieldElement.type.toString()}');
      }
      {
        //  look for the default and named constructors
        //  if one or more exist, there must be an explicit default constructor
        //  if neither of either exist, the provided default constructor will suffice
        bool hasDefaultConstructor = false;
        int nonDefaultConstructorCount = 0;
        for (var constructorElement in element.constructors) {
          hasDefaultConstructor |= constructorElement.isDefaultConstructor;
          nonDefaultConstructorCount +=
              (constructorElement.isDefaultConstructor ? 0 : 1);
          //print('Constructor: ${constructorElement.toString()}');
        }

        if (!hasDefaultConstructor && nonDefaultConstructorCount > 0) {
          print('hasDefaultConstructor: $hasDefaultConstructor');
          print('nonDefaultConstructorCount: $nonDefaultConstructorCount');
          throw Exception(
              'the bus message type ${element.name} does not have a default constructor!');
        }
      }

      buffer
        ..writeln(
            '//  a public immutable class modeled after the ${element.name} class')
        ..writeln('//  notice that only limited data types are supported.')
        ..writeln(
            '//  notice that no methods other than getters or ImmutableBusMessageType methods are provided.')
        ..writeln(
            'class Immutable${element.name}BusMessageType extends ImmutableBusMessageType {')
        ..writeln('')
        ..writeln('  //    private constructor')
        ..writeln('  Immutable${element.name}BusMessageType._(');
      for (var fieldElement in element.fields) {
        buffer.writeln('    this._${fieldElement.name},');
      }
      buffer
        ..writeln('  );')
        ..writeln()
        ..writeln('  //  public constructor from mutable class')
        ..writeln(
            '  static Immutable${element.name}BusMessageType getImmutable(${element.name} m ) {')
        ..write('    return Immutable${element.name}BusMessageType._(');
      for (var fieldElement in element.fields) {
        buffer.writeln('    m.${fieldElement.name},');
      }

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

      buffer
        ..writeln()
        ..writeln('  //  map for bus diagnostics')
        ..writeln('  //  can be cached since the class is immutable')
        ..writeln('  @override')
        ..writeln('  Map<String, dynamic> get map {')
        ..writeln('    if (_map == null)')
        ..writeln('      _map = {');
      for (var fieldElement in element.fields) {
        buffer
            .writeln('        "${fieldElement.name}": _${fieldElement.name},');
      }
      buffer
        ..writeln('      };')
        ..writeln('return _map;')
        ..writeln('    }')
        ..writeln('  Map<String, dynamic> _map;');

      buffer.writeln('}');

      //  generate the mutable class
      buffer
        ..writeln()
        ..writeln(
            '//  class for sourcing ${element.name} data model message types')
        ..writeln(
            'class ${element.name}BusMessageType extends ${element.name} implements MutableBusMessageType {')
        ..writeln('    @override')
        ..writeln('    ImmutableBusMessageType getImmutable() {')
        ..writeln(
            '    return Immutable${element.name}BusMessageType.getImmutable(this);')
        ..writeln('    }')
        ..writeln('}');

      //  print(buffer.toString());   //  diagnostic only
    } else {
      throw Exception(
          'a bus message type has to be a class, ${element.name} is not a class!');
    }

    return buffer.toString();
  }

//final Logger log = new Logger('MyClassName');
}

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:mobile/generator/lib/src/todo_reporter_generator.dart';

Builder todoReporter(BuilderOptions options) =>
    SharedPartBuilder([TodoReporterGenerator()], 'todo_reporter_generator');
import 'bus_definition.dart';
import 'bus_more_types.dart';

void main() {
  test();
}

void test() {
  {
    FooBusMessageType foo = new FooBusMessageType();
    var im = foo.getImmutable();
    foo.value.foo = 13;
    foo.value.bar = "bob was here";
    var im2 = foo.getImmutable();

    print('${im.foo.toString()}: ${im.bar.toString()}');
    print('${im2.foo.toString()}: ${im2.bar.toString()}');

    ImmutableFooBusMessageType messageType = im2;
    int i = messageType.foo;
    String s = messageType.bar;
  }
  {
    OtherFooBusMessageType foo = OtherFooBusMessageType();
    var im = foo.getImmutable();
    foo.value.foo = 3;
    foo.value.bar = "is this different?";
    var im2 = foo.getImmutable();

    print('${im.foo.toString()}: ${im.bar.toString()}');
    print('${im2.foo.toString()}: ${im2.bar.toString()}');
  }
}

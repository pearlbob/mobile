import 'bus_definition.dart';
import 'bus_more_types.dart';

void main() {
  test();
}

void test() {
  {
    Foo foo = Foo();
    var im = ImmutableFooBusMessageType.getImmutable(foo);
    foo.foo = 13;
    foo.bar = "bob was here";
    var im2 = ImmutableFooBusMessageType.getImmutable(foo);

    print('${im.foo.toString()}: ${im.bar.toString()}');
    print('${im2.foo.toString()}: ${im2.bar.toString()}');
  }
  {
    OtherFoo foo = OtherFoo();
    var im = ImmutableOtherFooBusMessageType.getImmutable(foo);
    foo.foo = 3;
    foo.bar = "is this different?";
    var im2 = ImmutableOtherFooBusMessageType.getImmutable(foo);

    print('${im.foo.toString()}: ${im.bar.toString()}');
    print('${im2.foo.toString()}: ${im2.bar.toString()}');
  }
}

import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

const Color _blue = Colors.blue;
const Color _black = Colors.black;
const Color _green = Color(0xff6bde54);
const Color _red = Color(0xffcc3030);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bobs mobile',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'bob\'s mobile'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 7;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (_counter < 10) _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (_counter > 3) _counter--;
    });
  }

  Widget _buildImage() {
    return new CustomPaint(
      painter: new BobsCustomPainter(),
      child: Container(
        width: 1440,
        height: 1440,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Spacer(),
                IconButton(
                  onPressed: _decrementCounter,
                  icon: Icon(Icons.remove),
                  color: _black,
                  highlightColor: _blue,
                  tooltip: "decrement the part count",
                ),
                Spacer(),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.display1,
                ),
                Spacer(),
                IconButton(
                  onPressed: _incrementCounter,
                  icon: Icon(Icons.add),
                  color: _black,
                  highlightColor: _blue,
                  tooltip: "increment the part count",
                ),
                Spacer(),
              ],
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: _buildImage(),
            ),
          ],
        ),
      ),
    );
  }
}

const double _min_radius = 3;
const double _max_radius = 7;

class _Mobile_part {
  const _Mobile_part(
    this.radius,
    this.color,
      this.gap,
  )   : assert(radius != null),
        assert(radius >= _min_radius),
        assert(radius <= _max_radius),
        assert(color != null);

  final double radius;
  final Color color;
  final double gap;
}

class BobsCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    assert(size.width > 0 || size.height > 0);
    double s = max(size.width, size.height);

    final paint = Paint();
    paint.color = Color(0xfff7f4ef); //  super_white
    Rect rect = new Rect.fromLTWH(0, 0, s, s);
    canvas.drawRect(rect, paint);

    double gap = 0.02 * s;

    List<_Mobile_part> _mobileParts = [
      _Mobile_part(6.4, _red, -2),
      _Mobile_part(5.6, _green, -2),
      _Mobile_part(4.8, _blue, -2),
      _Mobile_part(4.3, _black, 2),
      _Mobile_part(4, _red, -2),
      _Mobile_part(3.6, _green, -2),
      _Mobile_part(3, _blue, 2),
    ];


    double lastX = 0.2 * s;
    double y = 0.5 * s;

    Offset p1;
    Offset p2 = Offset(lastX, y);

    for ( int i = 0; i < _mobileParts.length; i++ ){
      //  draw cross members
      _Mobile_part part = _mobileParts[i];
      p1 = p2;
      double r = part.radius / 100 * s;
      lastX += part.gap/100*s + r;
      p2 = Offset(lastX, p2.dy);

      if ( i > 0 && i < _mobileParts.length-1 ){
        _Mobile_part nextPart = _mobileParts[i+1];
        paint.color = _black;
        paint.strokeWidth = 2;

        canvas.drawLine(p1, p2, paint);
      }

      //  draw the part
      paint.color = part.color;
      canvas.drawCircle(p2, r, paint);

      lastX += r;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

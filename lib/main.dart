import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

const int _alpha = 0xff000000;
const Color _blue = Color(_alpha + 0x2196F3);
const Color _black = Color(_alpha + 0);
const Color _green = Color(_alpha + 0x6bde54);
const Color _red = Color(_alpha + 0xcc3030);

List<_Mobile_part> _mobileParts = [
  _Mobile_part(6.4, _red, 2),
  _Mobile_part(5.6, _green, 2),
  _Mobile_part(4.8, _blue, -1),
  _Mobile_part(4.3, _black, -2),
  _Mobile_part(4, _red, -4),
  _Mobile_part(3.6, _green, 2),
  _Mobile_part(3, _blue, 0),
];
List<_CrossBar> _crossBars = new List();

double _theta = 0.01; //  todo: temp
double _canvasSize = 1440;

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
  Timer _everyTick;

  @override
  void initState() {
    super.initState();

    if (_crossBars.isEmpty) {
      double lastX = 0.5 * _canvasSize;
      double y = 0.5 * _canvasSize;

      //  compute weight
      _Mobile_part lastPart;
      for (int i = _mobileParts.length - 1; i >= 0; i--) {
        _Mobile_part part = _mobileParts[i];
        if (lastPart != null) {
          part.weight += lastPart.weight;
        }
        lastPart = part;
      }

      //  locate parts initial position
      lastPart = null;
      for (int i = 0; i < _mobileParts.length; i++) {
        _Mobile_part part = _mobileParts[i];
        if (lastPart != null) {
          lastX += lastPart.gap / 100 * _canvasSize + lastPart.displayRadius;
        }
        lastPart = part;

        //  scale to display size
        double r = part.radius / 100 * _canvasSize;
        part.displayRadius = r;
        lastX += r;

        part.center = new Offset(lastX, y);
      }

      //  compute cross arms
      {
        _Centered_part lastCenteredPart;
        double dTheta = pi / 25;
        double theta = 0;
        for (int i = _mobileParts.length - 1; i >= 0; i--) {
          _Mobile_part part = _mobileParts[i];
          if (lastCenteredPart != null) {
            _CrossBar _crossBar = new _CrossBar(part, lastCenteredPart);
            theta += dTheta;
            _crossBar.theta = theta;
            _crossBars.add(_crossBar);
            lastCenteredPart = _crossBar;
          } else
            lastCenteredPart = part;
        }
      }
      _crossBars.last?.center = Offset(0.5 * _canvasSize, y);
      _crossBars.last?.setHeight(0);
    }

    // defines a timer
    _everyTick = Timer.periodic(Duration(milliseconds: 16), (Timer t) {
      setState(() {
        //  just tick to force repaint
      });
    });
  }

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
                  color: Colors.black,
                  highlightColor: Colors.blue,
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
                  color: Colors.black,
                  highlightColor: Colors.blue,
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
const double sideViewHeight = 25;

class _Centered_part {
  void paint(Canvas canvas) {}
  Offset center = Offset(0, 0);
  double weight;

  void setHeight(int height) {
    _height = height;
  }

  int _height = 1;
}

class _Mobile_part extends _Centered_part {
  _Mobile_part(
    this.radius,
    this.color,
    this.gap,
  )   : assert(radius != null),
        assert(radius >= _min_radius),
        assert(radius <= _max_radius),
        assert(color != null) {
    weight = 2 * pi * radius * radius;
  }

  @override
  void paint(Canvas canvas) {
    //  draw the part
    final paint = Paint();
    paint.color = color;
    paint.style=PaintingStyle.fill;
    canvas.drawCircle(center, displayRadius, paint);

    //  outline part
    paint.color = Colors.black;
    paint.strokeWidth = 1;
    paint.style=PaintingStyle.stroke;
    {
      Path path = Path();
      path.addArc(Rect.fromCircle(center: center,  radius: displayRadius), 0, 2*pi);
      canvas.drawPath(path, paint);
    }

    //  side view
    paint.strokeWidth = 3;
    paint.color = Colors.black;
    paint.style=PaintingStyle.fill;
    double y = sideViewHeight + sideViewHeight * _height;
    canvas.drawLine(
        Offset(center.dx, y - sideViewHeight), Offset(center.dx, y), paint);
    paint.color = color;
    canvas.drawLine(Offset(center.dx - displayRadius, y),
        Offset(center.dx + displayRadius, y), paint);
  }

  final double radius;
  final Color color;
  final double gap;

  double displayRadius;
}

class _CrossBar extends _Centered_part {
  _CrossBar(this.partEnd, this.joinEnd) {
    weight = partEnd.weight + joinEnd.weight;
    balanceRatio = joinEnd.weight / weight;
    double d = (partEnd.center - joinEnd.center).distance;
    center = Offset(
        partEnd.center.dx * balanceRatio +
            joinEnd.center.dx * (1 - balanceRatio),
        partEnd.center.dy * balanceRatio +
            joinEnd.center.dy * (1 - balanceRatio));
    partLength = d * balanceRatio;
    joinLength = d * (1 - balanceRatio);
    assert((partEnd.weight * partLength - joinEnd.weight * joinLength).abs() <
        1e-9);
  }

  @override
  void paint(Canvas canvas) {
    //  draw the part
    partEnd.center = Offset(center.dx - partLength * cos(theta),
        center.dy - partLength * sin(theta));
    joinEnd.center = Offset(center.dx + joinLength * cos(theta),
        center.dy + joinLength * sin(theta));

    //  up view
    final paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 3;
    canvas.drawLine(partEnd.center, joinEnd.center, paint);
    canvas.drawCircle(center, 6, paint);

    //  side view
    double y = sideViewHeight + sideViewHeight * _height;
    canvas.drawLine(
        Offset(partEnd.center.dx, y), Offset(joinEnd.center.dx, y), paint);
    canvas.drawCircle(Offset(center.dx, y), 6, paint);
    canvas.drawLine(Offset(joinEnd.center.dx, y),
        Offset(joinEnd.center.dx, y + sideViewHeight), paint);

    //  recurse down
    partEnd.paint(canvas);
    joinEnd.paint(canvas);
  }

  @override
  void setHeight(int height) {
    super.setHeight(height);
    partEnd.setHeight(height + 1);
    joinEnd.setHeight(height + 1);
  }

  final _Mobile_part partEnd;
  final _Centered_part joinEnd;
  double balanceRatio; //  partEnd.weight/joinEnd.weight
  double partLength;
  double joinLength;
  double theta = 0;
}

class BobsCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    assert(size.width > 0 || size.height > 0);
    _canvasSize = max(size.width, size.height);

    try {
      final paint = Paint();
      paint.color = Color(0xfff7f4ef); //  super_white
      Rect rect = new Rect.fromLTWH(0, 0, _canvasSize, _canvasSize);
      canvas.drawRect(rect, paint);

      {
        //  todo: temp
        _theta += 0.025;
        double t = _theta;
        for (_CrossBar _crossBar in _crossBars) {
          _crossBar.theta = t;
          t /= 2;
        }
      }

      _crossBars.last?.paint(canvas);
    } catch (exception, stackTrace) {
      print(exception);
      print(stackTrace);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

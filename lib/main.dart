import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final List<String> _keys = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
  List<KeyController> _keyControllers = [];
  List<Animation> _rotateAnimations = [];
  List<Animation> _colorAnimations = [];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _keys.length; i++) {
      var keyController = KeyController(this);
      keyController.rotationController.addListener(() => setState(() {}));
      keyController.colorController.addListener(() => setState(() {}));
      _keyControllers.add(keyController);
      _rotateAnimations.add(Tween(begin: 0.0, end: 2 * pi)
          .animate(keyController.rotationController));
      _colorAnimations.add(ColorTween(begin: Colors.green, end: Colors.red)
          .animate(keyController.colorController));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Wrap(
          children: List.generate(
            _keys.length,
            (i) => _buildButton(
              _keys[i],
              _keyControllers[i],
              _rotateAnimations[i],
              _colorAnimations[i],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _animateAllButtons(),
        child: Icon(Icons.add),
      ),
    );
  }

  _animateAllButtons() {
    _keyControllers.forEach((c) {
      c.rotate();
    });
  }

  _buildButton(
    String text,
    KeyController keyController,
    Animation rotateAnimation,
    Animation colorAnimation,
  ) {
    return Transform.rotate(
      angle: rotateAnimation.value,
      child: GestureDetector(
        child: Container(
          margin: EdgeInsets.all(20),
          width: 100,
          height: 100,
          color: colorAnimation.value,
          child: Center(child: Text(text, style: TextStyle(fontSize: 40))),
        ),
        onTap: () => keyController.rotate(),
        onDoubleTap: () => keyController.flashColor(),
      ),
    );
  }

  @override
  void dispose() {
    _keyControllers.forEach((c) => c.dispose());
    super.dispose();
  }
}

class KeyController {
  AnimationController rotationController;
  AnimationController colorController;
  KeyController(TickerProvider tickerProvider) {
    rotationController = AnimationController(
      vsync: tickerProvider,
      duration: Duration(milliseconds: 1000),
    );
    rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) rotationController.reset();
    });
    colorController = AnimationController(
      vsync: tickerProvider,
      duration: Duration(milliseconds: 500),
    );
    colorController.addStatusListener((status) {
      if (status == AnimationStatus.completed) colorController.reset();
    });
  }
  TickerFuture rotate() {
    if (rotationController.status != AnimationStatus.dismissed)
      return TickerFuture.complete();
    return rotationController.forward();
  }

  TickerFuture flashColor() {
    if (colorController.status != AnimationStatus.dismissed)
      return TickerFuture.complete();
    return colorController.forward();
  }

  void dispose() {
    rotationController.dispose();
    colorController.dispose();
  }
}

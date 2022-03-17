import 'package:flutter/material.dart';
import 'package:wire/wire.dart';
import 'package:wire_flutter/wire_flutter.dart';

import 'CounterProcessor.dart';
import 'const/CounterSignals.dart';
import 'const/CounterDataKey.dart';

void main() {
  CounterProcessor();
  Wire.data(CounterDataKey.COUNT, value: 0);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              WireDataBuilder<int>(
                  dataKey: CounterDataKey.COUNT,
                  builder: (context, value) => Text(
                        '$value',
                        style: Theme.of(context).textTheme.headline4,
                      ))
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () => Wire.send(CounterSignal.INCREASE),
                child: Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: () => Wire.send(CounterSignal.DECREASE),
                child: Icon(Icons.remove),
              )
            ],
          ),
        ));
  }
}

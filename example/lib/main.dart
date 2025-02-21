import 'package:flutter/material.dart';

import 'tile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _scale;
  late TextEditingController _size;
  late TextEditingController _zoom;
  late TextEditingController _xOffset;
  late TextEditingController _yOffset;
  TileOptions options = TileOptions(
      size: Size(256, 256),
      scale: 1.0,
      zoom: 15,
      xOffset: 0,
      yOffset: 0,
      renderMode: RenderMode.vector);

  @override
  void initState() {
    super.initState();
    _scale = TextEditingController(text: '${options.scale}');
    _size = TextEditingController(text: '${options.size.width}');
    _zoom = TextEditingController(text: '${options.zoom.toInt()}');
    _xOffset = TextEditingController(text: '${options.xOffset.toInt()}');
    _yOffset = TextEditingController(text: '${options.yOffset.toInt()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Vector Tile Example"),
        ),
        body: Column(children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: Row(children: [
                _doubleTextField(_scale, 'Scale',
                    (value) => options.withValues(scale: value)),
                _doubleTextField(_size, 'Size',
                    (value) => options.withValues(size: Size(value, value))),
                _doubleTextField(_xOffset, 'X Offset',
                    (value) => options.withValues(xOffset: value)),
                _doubleTextField(_yOffset, 'Y Offset',
                    (value) => options.withValues(yOffset: value)),
                _doubleTextField(
                    _zoom, 'Zoom', (value) => options.withValues(zoom: value)),
              ])),
          _radio('Rendering', RenderMode.values, () => options.renderMode,
              (v) => options.withValues(renderMode: v as RenderMode)),
          Expanded(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Tile(options: options)]))
        ]));
  }

  Widget _doubleTextField(TextEditingController controller, String label,
      TileOptions Function(double) applyer) {
    return _textField(controller, label, (value) {
      final d = double.tryParse(value);
      if (d != null) {
        return applyer(d);
      }
      return null;
    });
  }

  Widget _textField(TextEditingController controller, String label,
          TileOptions? Function(String) applyer) =>
      Padding(
          padding: EdgeInsets.only(right: 5.0),
          child: Container(
              width: 80,
              child: TextField(
                  controller: controller,
                  onChanged: (value) {
                    final newOptions = applyer(value);
                    if (newOptions != null) {
                      setState(() {
                        options = newOptions;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: label,
                  ))));

  Widget _radio<T extends Enum>(String label, List<T> values,
      T Function() currentValue, TileOptions Function(T value) applyer) {
    return Row(
        children: values
            .map((v) => SizedBox(
                width: 150,
                child: ListTile(
                  title: Text(v.name),
                  leading: Radio<T>(
                    value: v,
                    groupValue: currentValue(),
                    onChanged: (T? value) {
                      if (value != null) {
                        setState(() {
                          options = applyer(value);
                        });
                      }
                    },
                  ),
                )))
            .toList());
  }
}

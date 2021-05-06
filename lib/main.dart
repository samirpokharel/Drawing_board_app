import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Drawing App",
      home: DrawingBoard(),
    );
  }
}

class DrawingBoard extends StatefulWidget {
  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  var _points = <DrawingPoints>[];
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.pink,
    Colors.green,
    Colors.purple,
    Colors.amberAccent
  ];

  Color selectedColor = Colors.red;
  double strokeWidth = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          child: GestureDetector(
            onPanStart: (details) {
              setState(() {
                _points.add(
                  DrawingPoints(
                    points: details.localPosition,
                    paint: Paint()
                      ..isAntiAlias = true
                      ..color = selectedColor
                      ..strokeWidth = strokeWidth,
                  ),
                );
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _points.add(
                  DrawingPoints(
                    points: details.localPosition,
                    paint: Paint()
                      ..isAntiAlias = true
                      ..color = selectedColor
                      ..strokeWidth = strokeWidth,
                  ),
                );
              });
            },
            onPanEnd: (details) {
              setState(() {
                _points.add(null);
              });
            },
            child: Stack(
              children: [
                CustomPaint(
                  painter: DrawingPainter(_points, selectedColor),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 50,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: Slider(
                          min: 0,
                          max: 10,
                          value: strokeWidth,
                          onChanged: (val) {
                            setState(() {
                              strokeWidth = val;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 45,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _points = [];
                            });
                          },
                          icon: Icon(Icons.clear),
                          label: Text('Clear Board'),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[200],
            width: double.infinity,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    colors.length, (index) => _buildColorChose(colors[index]))),
          ),
        ));
  }

  _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: AnimatedContainer(
        duration: Duration(microseconds: 200),
        height: isSelected ? 55 : 44,
        width: isSelected ? 55 : 44,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 5) : null,
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  List<DrawingPoints> points;
  Color color;

  DrawingPainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // print(points[0].points);
    List<Offset> offsetPoints = [];
    for (int i = 0; i < points.length; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
            points[i].points, points[i + 1].points, points[i].paint);
      } else if (points[i] != null && points[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(points[i].points);
        offsetPoints
            .add(Offset(points[i].points.dx + 0.1, points[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, points[i].paint);
      }
    }

    // for (int i = 0; i < offsets.length; i++) {
    //   if (offsets[i] != null && offsets[i + 1] != null) {
    //     canvas.drawLine(offsets[i], offsets[i + 1], paint);
    //   } else if (offsets[i] != null && offsets[i + 1] == null) {
    //     canvas.drawPoints(PointMode.points, [offsets[i]], paint);
    //   }
    // }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;
  DrawingPoints({this.points, this.paint});
}

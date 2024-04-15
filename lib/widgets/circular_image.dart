import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final double _width, _height;
  final ImageProvider image;

  const CircularImage(this.image, {Key? key, double width = 40, double height = 40})
      : _width = width,
        _height = height,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: image), boxShadow: const [
        BoxShadow(
          blurRadius: 10,
          color: Colors.black45,
        )
      ]),
    );
  }
}

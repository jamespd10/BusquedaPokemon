import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class GetColor {
  static Future<PaletteGenerator> get(String img) async {
    final _color = await PaletteGenerator.fromImageProvider(
      Image.network(img).image,
    );
    return _color;
  }
}

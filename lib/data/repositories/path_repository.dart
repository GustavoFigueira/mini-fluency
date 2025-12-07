import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/models.dart';

/// Repository responsible for loading and managing path data
class PathRepository {
  static const String _assetPath = 'assets/data/path_data.json';

  Future<PathModel> loadPath() async {
    final jsonString = await rootBundle.loadString(_assetPath);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final pathData = jsonData['path'] as Map<String, dynamic>;
    return PathModel.fromJson(pathData);
  }
}

import 'dart:io';

import 'package:mime/mime.dart';

class LocalFile {
  final String path;
  final String name;
  final String mimeType;

  LocalFile({required this.path, required this.name, required this.mimeType});

  static String getMimeTypeOfFile(String path) {
    var mimeType = lookupMimeType(path);
    if (mimeType != null) {
      return mimeType;
    } else {
      throw Exception("Cannot obtain mimeType for file in path -> $path");
    }
  }

  static LocalFile fromPath(String path) {
    return LocalFile(
        path: path,
        name: path.split('/').last,
        mimeType: getMimeTypeOfFile(path));
  }

  static LocalFile fromFile(File file) {
    return LocalFile(
        path: file.path,
        name: file.path.split('/').last,
        mimeType: getMimeTypeOfFile(file.path));
  }
}

import 'dart:io';

class ImageService {
    Future<bool> isFileSizeExceed(File file, int maxMB) async {
      final fileSize = await file.length();
      final maxBytes = maxMB * 1024 * 1024;
      return fileSize > maxBytes;
    }
}
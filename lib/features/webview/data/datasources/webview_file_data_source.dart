/// WebView file data source.
///
/// Handles file download and management operations.
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// WebView file data source.
///
/// Provides file download and management functionality.
class WebViewFileDataSource {
  /// Creates a file data source.
  WebViewFileDataSource();

  /// Downloads a file from a URL.
  ///
  /// Returns the local file path on success.
  Future<String> downloadFile(String url) async {
    final httpClient = HttpClient();
    try {
      final uri = Uri.parse(url);
      final request = await httpClient.getUrl(uri);
      final response = await request.close();

      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'Failed to download file: ${response.statusCode}',
          uri: uri,
        );
      }

      // Get the filename from the URL or generate one
      final filename = _getFilenameFromUrl(url);
      final directory = await getDownloadDirectory();
      final file = File('${directory.path}/$filename');

      // Write the file
      await response.pipe(file.openWrite());

      return file.path;
    } finally {
      httpClient.close();
    }
  }

  /// Checks if a file exists at the given path.
  Future<bool> fileExists(String filePath) async {
    final file = File(filePath);
    return file.exists();
  }

  /// Deletes a file at the given path.
  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Gets the download directory.
  Future<Directory> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      return dir ?? await getApplicationDocumentsDirectory();
    } else {
      return getApplicationDocumentsDirectory();
    }
  }

  /// Gets the filename from a URL.
  String _getFilenameFromUrl(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;

    if (pathSegments.isNotEmpty) {
      final lastSegment = pathSegments.last;
      if (lastSegment.contains('.')) {
        // Add timestamp to avoid conflicts
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final dotIndex = lastSegment.lastIndexOf('.');
        final name = lastSegment.substring(0, dotIndex);
        final extension = lastSegment.substring(dotIndex);
        return '${name}_$timestamp$extension';
      }
    }

    // Generate a filename if none found
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'download_$timestamp';
  }

  /// Gets the file size in bytes.
  Future<int> getFileSize(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      return file.length();
    }
    return 0;
  }

  /// Lists all downloaded files.
  Future<List<FileSystemEntity>> listDownloadedFiles() async {
    final directory = await getDownloadDirectory();
    if (await directory.exists()) {
      return directory.list().toList();
    }
    return [];
  }

  /// Clears all downloaded files.
  Future<void> clearDownloadedFiles() async {
    final directory = await getDownloadDirectory();
    if (await directory.exists()) {
      await for (final entity in directory.list()) {
        try {
          if (entity is File) {
            await entity.delete();
          }
        } on Exception catch (e) {
          debugPrint('Error deleting file: $e');
        }
      }
    }
  }
}

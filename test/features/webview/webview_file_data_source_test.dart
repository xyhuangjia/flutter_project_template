
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WebViewFileDataSource helpers', () {
    test('generates filename from URL with extension', () async {
      const url = 'https://example.com/files/document.pdf';
      final filename = _getFilenameFromUrl(url);
      expect(filename, contains('_'));
      expect(filename, endsWith('.pdf'));
    });

    test('generates filename from URL without extension', () async {
      const url = 'https://example.com/files/document';
      final filename = _getFilenameFromUrl(url);
      expect(filename, contains('_'));
    });

    test('generates filename with correct format', () async {
      const url = 'https://example.com/file.pdf';
      final filename = _getFilenameFromUrl(url);
      expect(filename, contains('_'));
      expect(filename, endsWith('.pdf'));
    });
  });
}

String _getFilenameFromUrl(String url) {
  final uri = Uri.parse(url);
  final pathSegments = uri.pathSegments;

  if (pathSegments.isNotEmpty) {
    final lastSegment = pathSegments.last;
    if (lastSegment.contains('.')) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final dotIndex = lastSegment.lastIndexOf('.');
      final name = lastSegment.substring(0, dotIndex);
      final extension = lastSegment.substring(dotIndex);
      return '${name}_$timestamp$extension';
    }
  }

  final timestamp = DateTime.now().millisecondsSinceEpoch;
  return 'download_$timestamp';
}

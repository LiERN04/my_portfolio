import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'package:flutter/services.dart';

class UrlLauncherService {
  static Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> downloadAsset(String assetPath, String fileName) async {
    if (kIsWeb) {
      try {
        // Load the asset as bytes
        final ByteData data = await rootBundle.load(assetPath);
        final List<int> bytes = data.buffer.asUint8List();

        // Create blob and download for web
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = fileName;
        html.document.body?.children.add(anchor);
        anchor.click();
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      } catch (e) {
        throw 'Could not download file: $e';
      }
    } else {
      // For mobile platforms, we'll still open as URL
      // You might want to implement platform-specific download logic here
      final Uri uri = Uri.parse(assetPath);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $assetPath';
      }
    }
  }
}

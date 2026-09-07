/// Extracts the YouTube video id from a watch/short/youtu.be URL, or null
/// if the URL doesn't look like a YouTube link.
String? youtubeVideoId(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return null;
  if (uri.host.contains('youtu.be')) {
    return uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
  }
  if (uri.host.contains('youtube.com')) {
    return uri.queryParameters['v'];
  }
  return null;
}

/// Builds an embeddable preview URL for a Google Drive file link, for
/// showing inside the app's own WebView.
String driveEmbedUrl(String url) {
  final uri = Uri.parse(url);
  final dIndex = uri.pathSegments.indexOf('d');
  final fileId = dIndex >= 0 && dIndex + 1 < uri.pathSegments.length
      ? uri.pathSegments[dIndex + 1]
      : null;
  if (fileId == null) return url;
  return 'https://drive.google.com/file/d/$fileId/preview';
}

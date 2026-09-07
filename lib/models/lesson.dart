enum VideoSource { youtube, googleDrive }

class Lesson {
  final String id;
  final String title;
  final String url;
  final VideoSource source;

  const Lesson({
    required this.id,
    required this.title,
    required this.url,
    required this.source,
  });
}

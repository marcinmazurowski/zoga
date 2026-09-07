import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../models/lesson.dart';
import '../theme/app_colors.dart';
import '../utils/video_embed.dart';

/// Plays a lesson's video inside the app: YouTube lessons use the official
/// IFrame player (reliable playback, no hand-off to the YouTube app),
/// Google Drive lessons fall back to an embedded preview WebView.
class VideoPlayerPage extends StatefulWidget {
  final Lesson lesson;

  const VideoPlayerPage({super.key, required this.lesson});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  YoutubePlayerController? _youtubeController;
  WebViewController? _driveController;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final videoId = youtubeVideoId(widget.lesson.url);
    if (widget.lesson.source == VideoSource.youtube && videoId != null) {
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showFullscreenButton: true,
          strictRelatedVideos: true,
          showVideoAnnotations: false,
          enableCaption: false,
        ),
      );
      _loading = false;
    } else {
      _driveController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(onPageFinished: (_) => setState(() => _loading = false)),
        )
        ..loadRequest(Uri.parse(driveEmbedUrl(widget.lesson.url)));
    }
  }

  @override
  void dispose() {
    _youtubeController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        title: Text(widget.lesson.title),
      ),
      body: Stack(
        children: [
          if (_youtubeController != null)
            Center(child: YoutubePlayer(controller: _youtubeController!))
          else if (_driveController != null)
            WebViewWidget(controller: _driveController!),
          if (_loading)
            const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        ],
      ),
    );
  }
}

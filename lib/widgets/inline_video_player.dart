import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../models/lesson.dart';
import '../theme/app_colors.dart';
import '../utils/video_embed.dart';

/// Video player embedded directly inside an expanded lesson tile, instead
/// of pushing a separate full-screen page. YouTube lessons use the official
/// IFrame player (its own fullscreen button still works); Google Drive
/// lessons fall back to an embedded preview WebView.
class InlineVideoPlayer extends StatefulWidget {
  final Lesson lesson;

  const InlineVideoPlayer({super.key, required this.lesson});

  @override
  State<InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<InlineVideoPlayer> {
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
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: AppColors.background,
          child: Stack(
            children: [
              if (_youtubeController != null)
                YoutubePlayer(controller: _youtubeController!)
              else if (_driveController != null)
                WebViewWidget(controller: _driveController!),
              if (_loading)
                const Center(child: CircularProgressIndicator(color: AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }
}

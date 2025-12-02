import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:video_player/video_player.dart';


import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

class VideoBox extends StatefulWidget {
  final String videoUrl;
  const VideoBox({super.key, required this.videoUrl});

  @override
  State<VideoBox> createState() => _VideoBoxState();
}

class _VideoBoxState extends State<VideoBox> {
  VideoPlayerController? _controller;          // for non‑YouTube videos
  YoutubePlayerController? _ytController;     // for YouTube videos
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _ytController?.dispose();
    super.dispose();
  }

  Future<void> _initPlayer() async {
    debugPrint('VideoURL: ${widget.videoUrl}');

    if (widget.videoUrl.trim().isEmpty) {
      setState(() => _hasError = true);
      return;
    }

    // ---------- 1️⃣  YouTube handling ----------
    if (isYouTubeUrl(widget.videoUrl)) {
      final videoId = extractYoutubeId(widget.videoUrl);
      if (videoId == null) {
        setState(() => _hasError = true);
        return;
      }

      _ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );

      setState(() {
        _isInitialized = true;
      });
      return;
    }

    // ---------- 2️⃣  Non‑YouTube handling ----------
    final token = await getToken(); // keep your existing auth logic

    try {
      if (kIsWeb) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
        await _controller!.initialize();
      } else {
        if (widget.videoUrl.startsWith('http')) {
          setState(() => _isDownloading = true);

          final response = await http.get(
            Uri.parse(widget.videoUrl),
            headers: {'Authorization': 'Bearer $token'},
          );

          if (response.statusCode == 200) {
            final dir = await getTemporaryDirectory();
            final fileName = 'video_${widget.videoUrl.hashCode}.mp4';
            final file = File('${dir.path}/$fileName');
            await file.writeAsBytes(response.bodyBytes);

            _controller = VideoPlayerController.file(file);
            await _controller!.initialize();
          } else {
            throw Exception('Auth Failed: ${response.statusCode}');
          }
        } else {
          _controller = VideoPlayerController.asset(widget.videoUrl);
          await _controller!.initialize();
        }
      }

      setState(() {
        _isInitialized = true;
        _isDownloading = false;
      });
    } catch (e) {
      debugPrint('Error initializing video: $e');
      setState(() {
        _hasError = true;
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _errorPlaceholder();
    }

    if (_isDownloading || !_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    // ---------- YouTube player ----------
    if (_ytController != null) {
      return YoutubePlayerBuilder(
        player: YoutubePlayer(controller: _ytController!),
        builder: (context, player) => Stack(
          alignment: Alignment.bottomCenter,
          children: [
            player,
            _buildControls(isYouTube: true),
          ],
        ),
      );
    }

    // ---------- Regular video player ----------
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
        ),
        _buildControls(isYouTube: false),
      ],
    );
  }

  Widget _errorPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.videocam_off, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildControls({required bool isYouTube}) {
    // For YouTube we let the built‑in controls handle most actions.
    // We only add a simple play/pause overlay when the user taps the video.
    if (isYouTube) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.black38,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_controller!.value.isPlaying) {
                  _controller!.pause();
                } else {
                  _controller!.play();
                }
              });
            },
            icon: Icon(
              _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              _controller!.pause();
              _controller!.seekTo(Duration.zero);
              setState(() {});
            },
            icon: const Icon(Icons.replay, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}


bool isYouTubeUrl(String url) {
  final uri = Uri.parse(url);
  if (uri == null) return false;

  final host = uri.host.toLowerCase();
  return host.contains('youtube.com') || host.contains('youtu.be');
}

String? extractYoutubeId(String url) {
  if (!isYouTubeUrl(url)) return null;
  final uri = Uri.parse(url);

  if (uri.host.contains('youtu.be')) {
    return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
  }

  if (uri.queryParameters.containsKey('v')) {
    return uri.queryParameters['v'];
  }

  final possible = uri.pathSegments;
  if (possible.length >= 2 &&
      (possible[0] == 'shorts' || possible[0] == 'embed')) {
    return possible[1];
  }
  return null;
}






/*
class VideoBox extends StatefulWidget {
  final String videoUrl;
  const VideoBox({super.key, required this.videoUrl});

  @override
  State<VideoBox> createState() => _VideoBoxState();
}

class _VideoBoxState extends State<VideoBox> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initPlayer() async {
    debugPrint('VideoURL: ${widget.videoUrl}'); // e.g. https://youtube.com/shorts/sdiUvqpTuZU?si=8zrcHP8Jz4iBd0Yj

    if (widget.videoUrl.trim().isEmpty) {
      if (mounted) setState(() => _hasError = true);
      return;
    }

    final token = await getToken();

    try {
      if (kIsWeb) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
        await _controller!.initialize();
      } else {
        if (widget.videoUrl.startsWith('http')) {
          if (mounted) setState(() => _isDownloading = true);

          final response = await http.get(
            Uri.parse(widget.videoUrl),
            headers: {'Authorization': 'Bearer $token'},
          );

          if (response.statusCode == 200) {
            final dir = await getTemporaryDirectory();
            final fileName = 'video_${widget.videoUrl.hashCode}.mp4';
            final file = File('${dir.path}/$fileName');

            await file.writeAsBytes(response.bodyBytes);

            _controller = VideoPlayerController.file(file);
            await _controller!.initialize();
          } else {
            throw Exception('Auth Failed: ${response.statusCode}');
          }
        } else {
          _controller = VideoPlayerController.asset(widget.videoUrl);
          await _controller!.initialize();
        }
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isDownloading = false;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isDownloading = false;
        });
      }
    }
  }

  bool isYoutubeUrl(String url) {
    final uri = Uri.parse(url);
    if (uri == null) return false;

    final host = uri.host.toLowerCase();
    return host.contains('youtube.com') || host.contains('youtu.be');
  }

  String? extractYoutubeId(String url) {
    if (!isYouTubeUrl(url)) return null;
    final uri = Uri.parse(url);

    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
    }

    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v'];
    }

    final possible = uri.pathSegments;
    if (possible.length >= 2 &&
        (possible[0] == 'shorts' || possible[0] == 'embed')) {
      return possible[1];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off, size: 50, color: Colors.grey[600]),
            const SizedBox(height: 10),
            Text('Vídeo indisponível', style: TextStyle(color: Colors.grey[700])),
          ],
        ),
      );
    }

    if (_isDownloading || !_isInitialized || _controller == null) {
      return ColoredBox(
        color: Colors.black12,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
        ),
        _buildControls(),
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      color: Colors.black38,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_controller!.value.isPlaying) {
                  _controller!.pause();
                } else {
                  _controller!.play();
                }
              });
            },
            icon: Icon(
              _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {
              _controller!.pause();
              _controller!.seekTo(Duration.zero);
              setState(() {});
            },
            icon: const Icon(Icons.replay, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}
*/

/*
// Example inside a ListView or any layout
YoutubeThumbnail(
  videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
  width: 200,
  height: 112, // 16:9 aspect ratio
)
*/


class YoutubeThumbnail extends StatefulWidget {
  final String videoUrl;
  final double? width;   // optional size constraints
  final double? height;
  final VoidCallback? onTap; // if you want to handle the tap elsewhere

  const YoutubeThumbnail({
    Key? key,
    required this.videoUrl,
    this.width,
    this.height,
    this.onTap,
  }) : super(key: key);

  @override
  State<YoutubeThumbnail> createState() => _YoutubeThumbnailState();
}

class _YoutubeThumbnailState extends State<YoutubeThumbnail> {
  late final String? _videoId;
  late final String? _thumbUrl;

  @override
  void initState() {
    super.initState();
    _videoId = extractYoutubeId(widget.videoUrl);
    if (_videoId != null) {
      // YouTube provides several preset sizes:
      //   default.jpg   (120×90)
      //   mqdefault.jpg (320×180)
      //   hqdefault.jpg (480×360)   <-- used here
      //   sddefault.jpg (640×480)
      //   maxresdefault.jpg (1280×720) – may not exist for every video
      _thumbUrl = 'https://img.youtube.com/vi/$_videoId/hqdefault.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbUrl == null) {
      // Not a YouTube link – fall back to a generic placeholder
      return const Icon(Icons.videocam_off, size: 48);
    }

    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        } else {
          // Default behaviour: replace the thumbnail with the full player
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: VideoBox(videoUrl: widget.videoUrl), // your existing widget
                ),
              ),
            ),
          );
        }
      },
      child: CachedNetworkImage(
        imageUrl: _thumbUrl!,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
        placeholder: (c, url) => const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        errorWidget: (c, url, err) => const Icon(Icons.broken_image, size: 48),
      ),
    );
  }
}

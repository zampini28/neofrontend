import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:video_player/video_player.dart';

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
    if (widget.videoUrl.trim().isEmpty) {
      if (mounted) setState(() => _hasError = true);
      return;
    }

    final token = await getToken();

    try {
      if (kIsWeb) {
        debugPrint('---------------- hello world ------------------');  
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
      return Container(
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

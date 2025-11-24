import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:physioapp/services/exercises/physio/exercises_controller_form.dart';
import 'package:video_player/video_player.dart';

class AddVideoBox extends StatefulWidget {
  final ExercisesControllerForm formProvider;
  const AddVideoBox({super.key, required this.formProvider});

  @override
  State<AddVideoBox> createState() => _AddVideoBoxState();
}

class _AddVideoBoxState extends State<AddVideoBox> {
  VideoPlayerController? _controller;
  XFile? _pickedFile;

  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo(XFile video) async {
    await _controller?.dispose();

    if (kIsWeb) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(video.path));
    } else {
      _controller = VideoPlayerController.file(File(video.path));
    }

    try {
      await _controller!.initialize();
      await _controller!.play();

      setState(() {
        _isLoading = false;
        widget.formProvider.toggleValueVideo();
      });
    } catch (e) {
      debugPrint('Error initializing video: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> getVideo() async {
    setState(() => _isLoading = true);

    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (video != null) {
        _pickedFile = video;
        await _initializeVideo(video);
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error picking video: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isInitialized = _controller != null && _controller!.value.isInitialized;

    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          clipBehavior: Clip.hardEdge,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : isInitialized
                  ? Stack(
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
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.videocam_off_outlined, size: 40, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text(
                          'Nenhum vídeo selecionado',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          height: 45,
          child: OutlinedButton.icon(
            onPressed: getVideo,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              side: BorderSide(color: Theme.of(context).primaryColor),
            ),
            icon: const Icon(Icons.upload_file_rounded),
            label: Text(isInitialized ? 'Trocar Vídeo' : 'Selecionar Vídeo'),
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      color: Colors.black38,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.stop, color: Colors.white),
            onPressed: () {
              _controller!.pause();
              _controller!.seekTo(Duration.zero);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}

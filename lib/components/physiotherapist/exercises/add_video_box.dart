import 'dart:io';

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
  late VideoPlayerController _controller;
  bool _isLoading = false;
  final ImagePicker _picket = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.file(
      File(''),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  Future<void> _playVideo({required XFile? video}) async {
    if (video != null) {
      _controller = VideoPlayerController.file(
        // Uri.parse(_video /* URL do backet que armazenará os videos*/),
        File(video.path),
      );
      // Para salvar o video precisaremos utilizar uma API de algum serviço de bucket

      await _controller.initialize();

      setState(() {
        _isLoading = false;
        _controller.play();
        widget.formProvider.toggleValueVideo();
      });
    }
  }

  Future<void> getVideo() async {
    setState(() => _isLoading = true);
    final video = await _picket.pickVideo(
      source: ImageSource.gallery,
    );

    if (video != null) {
      _playVideo(video: video);
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_controller.value.isInitialized)
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const Text('Nenhum vídeo selecionado'),
        ),
        if (_controller.value.isInitialized)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.stop),
                onPressed: () {
                  _controller.pause();
                  _controller.seekTo(Duration.zero);
                  setState(() {});
                },
              ),
            ],
          ),
        TextButton.icon(
          onPressed: () {
            getVideo();
          },
          label: const Text('Selecionar Vídeo'),
          icon: const Icon(Icons.upload_rounded),
        ),
      ],
    );
  }
}

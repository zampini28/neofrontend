import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/exercises/video_box.dart';
import 'package:physioapp/model/exercises/exercise.dart';
import 'package:physioapp/services/exercises/physio/exercise_controller.dart';
import 'package:physioapp/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ExercisesList extends StatelessWidget {
  final Exercise exercise;
  const ExercisesList({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    final exercisesProvider = Provider.of<ExerciseController>(context);

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        AppRoutes.exercisesDetailPage,
        arguments: exercise,
      ),
      child: Card(
        elevation: 2,
        color: const Color.fromARGB(0, 255, 255, 255),
        child: Container(
          height: 120,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(168, 66, 75, 84),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              // THUMBNAIL WIDGET
              YoutubeThumbnail(
                videoUrl: exercise.videoUrl,
                width: 100,
                height: 100,
                // Passing null to onTap lets the widget use its default
                // behavior (opening the video player), OR you can set
                // onTap: () {} to do nothing and let the Card's onTap handle navigation.
                // Given the layout, usually tapping the row goes to details.
                // Let's pass an empty function so the tap propagates to the parent GestureDetector
                // or you can leave it to open the video directly.
                // Based on standard UX for this list:
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.exercisesDetailPage,
                  arguments: exercise,
                ),
              ),

              Flexible(
                fit: FlexFit.tight,
                child: ListTile(
                  title: Text(
                    exercise.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.fade,
                  ),
                  subtitle: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      spacing: 5,
                      children: [
                        const Icon(
                          Icons.access_time_filled_rounded,
                          size: 24,
                          color: Colors.white,
                        ),
                        Text(
                          '${exercise.videoDuration.ceil()} min',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      exercisesProvider.toggleFavorite(exerciseId: exercise.id);
                    },
                    icon: exercise.isFavorite
                        ? const Icon(
                            Icons.favorite_rounded,
                            color: Colors.white,
                            size: 24,
                          )
                        : const Icon(
                            Icons.favorite_border_rounded,
                            size: 24,
                            color: Colors.white,
                          ),
                  ),
                  const Icon(
                    Icons.play_circle,
                    size: 40,
                    color: Colors.white,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

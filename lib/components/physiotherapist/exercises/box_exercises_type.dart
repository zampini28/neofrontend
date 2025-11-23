import 'package:flutter/material.dart';
import 'package:physioapp/model/exercises/category.dart';
import 'package:physioapp/utils/app_routes.dart';

class BoxExercisesType extends StatelessWidget {
  final Category category;
  const BoxExercisesType({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              height: 164,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 223, 224, 234),
                    Color.fromARGB(255, 233, 235, 240),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRoutes.exercisesListPage,
                      arguments: category,
                    ),
                    title: Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Text(
                          category.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    subtitle: Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 3),
                        height: 80,
                        child: Text(
                          category.subtitle,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).textTheme.labelLarge?.color,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Positioned(
            top: 0,
            child: CircleAvatar(
              maxRadius: 34,
              child: Icon(
                Icons.token_rounded,
                size: 34,
                color: category.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

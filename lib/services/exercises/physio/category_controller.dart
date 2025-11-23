import 'package:physioapp/data/exercises_mock_data.dart';
import 'package:physioapp/model/exercises/category.dart';

class CategoryController {
  final List<Category> _listCategory = ExercisesMockData.categoryList;

  List<Category> get listCategory => [..._listCategory];
  int get itemsCount => _listCategory.length;
}
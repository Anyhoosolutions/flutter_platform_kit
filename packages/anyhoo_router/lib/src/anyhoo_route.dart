import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// enum RouteName {
//   startPage,
//   aboutPage,
//   demoPage,
//   profilePage,
//   editProfilePage,
//   userPreferencesPage,
//   testDataPage,
//   debugPage,
//   loginPage,
//   recipes,
//   recipeDetails,
//   addRecipeChoice,
//   addRecipeManually,
//   addGroup,
//   manageGroups,
//   editRecipe,
//   groupDetails,
//   addStockPhoto,
//   loggingPage,
//   addRecipeYoutube,
//   addRecipeWeb,
//   addRecipeImage,
// }

abstract class AnyhooRoute<T extends Enum> {
  String get path;
  String get title;
  T get routeName;
  Widget? Function(BuildContext, GoRouterState)? get builder;
  bool get requireLogin;
  String? get redirect;
}

import 'package:foodrecipeapp/app/modules/admin/views/loginadmin_view.dart';
import 'package:foodrecipeapp/app/modules/home/views/choose_login.dart';
import 'package:foodrecipeapp/app/modules/member/views/member_view.dart';
import 'package:get/get.dart';

import '../modules/admin/bindings/admin_binding.dart';
import '../modules/admin/views/admin_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/member/bindings/member_binding.dart';
import '../modules/member/views/loginmember_view.dart';
import '../modules/member/views/premiumform_view.dart';
import '../modules/recipeDetail/bindings/recipe_detail_binding.dart';
import '../modules/recipeDetail/views/recipe_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.RECIPE_DETAIL,
      page: () => RecipeDetailView(
        recipeId: 0,
      ),
      binding: RecipeDetailBinding(),
    ),
    GetPage(
      name: _Paths.LOGINMEMBER,
      page: () => const LoginMemberView(),
      binding: MemberBinding(),
    ),
    GetPage(
      name: _Paths.MEMBER,
      page: () => const MemberView(),
      binding: MemberBinding(),
      // middlewares: [AuthMemberMiddleware()]
    ),
    GetPage(
      name: _Paths.PREMIUMFORM,
      page: () => const PremiumformView(),
      binding: MemberBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN,
      page: () => const AdminView(),
      binding: AdminBinding(),
      // middlewares: [AuthAdminMiddleware()]
    ),
    GetPage(
      name: _Paths.CHOOSELOGIN,
      page: () => const ChooseLogin(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGINADMIN,
      page: () => const LoginAdminView(),
      binding: AdminBinding(),
    ),
  ];
}

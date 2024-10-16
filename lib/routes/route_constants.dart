import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:quotation/businessInfo/business_info_screen.dart';
import 'package:quotation/core/localstorage/localstorage.dart';
import 'package:quotation/customer/add_customer.dart';
import 'package:quotation/customer/customer_list_screen.dart';
import 'package:quotation/lc.dart';
import 'package:quotation/login_signup/forget_password_screen.dart';
import 'package:quotation/login_signup/login_screen.dart';
import 'package:quotation/login_signup/sign_up_screen.dart';
import 'package:quotation/product/add_product.dart';
import 'package:quotation/product/product.dart';
import 'package:quotation/quotation/make_quotation.dart';
import 'package:quotation/quotation/quotation_list.dart';
import 'package:quotation/routes/app_service.dart';
import 'package:quotation/routes/my_app_route.dart';
import 'package:quotation/screens/home.dart';
import 'package:quotation/setting/setting.dart';
import 'package:quotation/terms%20conditions/terms_condition_page.dart';

class MyAppRouter {
  late final AppService appService;

  GoRouter get router => _goRouter;
  MyAppRouter(this.appService);

  late final GoRouter _goRouter = GoRouter(
    refreshListenable: appService,
    routes: [
      GoRoute(
        name: RouteConstants.home,
        path: '/',
        builder: (context, state) => const Home(),
        routes: [
          GoRoute(
            name: RouteConstants.termsConditions,
            path: 'termsConditions',
            builder: (context, state) => TermsAndConditionsPage(),
          ),
          GoRoute(
            name: RouteConstants.pdfList,
            path: 'pdfList',
            builder: (context, state) => PDFListScreen(),
          ),
          GoRoute(
            name: RouteConstants.businessInfo,
            path: 'businessInfo',
            builder: (context, state) => BusinessInfoForm(),
          ),
          GoRoute(
            name: RouteConstants.setting,
            path: 'setting',
            builder: (context, state) => SettingsScreen(),
          ),
          GoRoute(
            name: RouteConstants.makeQuotation,
            path: 'makeQuotation',
            builder: (context, state) => MakeQuotationScreen(),
          ),
          GoRoute(
            name: RouteConstants.customer,
            path: 'customer',
            builder: (context, state) => CustomerScreen(),
            routes: [
              GoRoute(
                name: RouteConstants.addCustomer,
                path: 'addCustomer',
                builder: (context, state) => AddCustomerScreen(),
              ),
            ],
          ),
          GoRoute(
            name: RouteConstants.product,
            path: 'product',
            builder: (context, state) => ProductScreen(),
            routes: [
              GoRoute(
                name: RouteConstants.addProduct,
                path: 'addProduct',
                builder: (context, state) => AddProductScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
          name: RouteConstants.login,
          path: '/login',
          builder: (context, state) => LoginScreen(),
          routes: [
            GoRoute(
              name: RouteConstants.forgetPass,
              path: 'forgetPass',
              builder: (context, state) => ForgotPasswordScreen(),
            ),
            GoRoute(
              name: RouteConstants.signup,
              path: 'signup',
              builder: (context, state) => SignupScreen(),
            ),
          ]),
    ],
    redirect: (context, state) async {
      final prefs = lc<LocalStorageRepository>();
      final String uid = await prefs.getUidFuture(); // Asynchronously fetch uid

      // If user is logged in (UID is present) and trying to access login or signup, redirect to home
      if (uid.isNotEmpty &&
          (state.matchedLocation == '/login' ||
              state.matchedLocation == '/login/signup')) {
        return '/'; // Redirect to home if logged in and accessing login or signup
      }

      // If user is not logged in and trying to access any route except login, signup, or forgot password, redirect to login
      if (uid.isEmpty &&
          !['/login', '/login/signup', '/login/forgetPass']
              .contains(state.matchedLocation)) {
        return '/login'; // Redirect to login if not logged in and accessing a protected route
      }

      // No need to redirect, stay on the current route
      return null;
    },
  );
}

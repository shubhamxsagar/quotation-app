import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:quotation/customer/customer_list_screen.dart';
import 'package:quotation/routes/my_app_route.dart';
import '../components/category.dart';
import '../components/discover.dart';
import '../styles/colors.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    // Request permissions for storage and internet
    PermissionStatus storageWriteStatus = await Permission.storage.request();
    PermissionStatus storageReadStatus = await Permission.storage.request();

    // Check the statuses and take appropriate action
    if (storageWriteStatus.isDenied || storageReadStatus.isDenied) {
      // Handle permission denial (optional)
      print("Permission denied.");
    } else if (storageWriteStatus.isGranted && storageReadStatus.isGranted) {
      // All permissions are granted
      print("All permissions granted.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: textTheme.displayMedium?.copyWith(
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        'POOJA PLASTIC PVT LTD',
                        style: textTheme.displayMedium?.copyWith(
                          fontSize: 19,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings_outlined,
                            size: 30, color: Colors.black),
                        onPressed: () {
                          context.pushNamed(RouteConstants.setting);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Manage',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Category(
                    title: 'Business',
                    iconName: Icons.business,
                    routeName: RouteConstants.businessInfo,
                  ),
                  Category(
                    title: 'Customer',
                    iconName: Icons.person,
                    routeName: RouteConstants.customer,
                  ),
                  Category(
                    title: 'Product',
                    iconName: Icons.shopping_bag,
                    routeName: RouteConstants.product,
                  ),
                  Category(
                    title: 'Terms',
                    iconName: Icons.admin_panel_settings,
                    routeName: RouteConstants.termsConditions,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: AppColors.secondaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover',
                      style: textTheme.displayMedium
                          ?.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: [
                          Discover(
                            title: 'Make Quotation',
                            text: 'Create new quotation',
                            routeName: RouteConstants.makeQuotation,
                          ),
                          Discover(
                            title: 'Quotation List',
                            text: 'Manage all quotations',
                            routeName: RouteConstants.pdfList,
                          ),
                          Discover(
                            title: 'Make Invoice',
                            text: 'Create new invoice',
                            routeName: '',
                          ),
                          Discover(
                            title: 'Invoice List',
                            text: 'Manage all invoices',
                            routeName: '',
                          ),
                          Discover(
                            title: 'Make Purchase',
                            text: 'Create new purchase',
                            routeName: '',
                          ),
                          Discover(
                            title: 'Purchase List',
                            text: 'Manage all purchases',
                            routeName: '',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

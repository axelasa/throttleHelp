import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trnk_ice/features/presentation/pages/auth/pages/information_pages/insurance_information.dart';
import 'package:trnk_ice/features/presentation/pages/auth/pages/information_pages/next_of_kin_info.dart';
import 'package:trnk_ice/features/presentation/pages/auth/pages/information_pages/vehicle_information.dart';
import 'package:trnk_ice/features/presentation/pages/landing_page/widgets/add_emergency_information.dart';
import 'package:trnk_ice/features/presentation/pages/landing_page/widgets/emergency_information.dart';
import 'package:trnk_ice/features/presentation/pages/landing_page/widgets/events.dart';
import 'package:trnk_ice/features/presentation/pages/landing_page/widgets/vehicle_data.dart';
import 'package:trnk_ice/features/presentation/pages/profile/presentation/profile.dart';
import 'package:trnk_ice/features/presentation/pages/services/presentation/widgets/accessories.dart';
import 'package:trnk_ice/features/presentation/pages/services/presentation/widgets/gear.dart';
import 'package:trnk_ice/features/presentation/pages/services/presentation/widgets/mechanics.dart';
import 'package:trnk_ice/features/presentation/pages/services/presentation/widgets/service_parts.dart';
import 'package:trnk_ice/home.dart';
import 'package:trnk_ice/provider/user_provider.dart';

import 'features/presentation/pages/auth/pages/presentation/sign_in.dart';
import 'features/presentation/pages/auth/pages/presentation/sign_up.dart';
import 'features/presentation/pages/services/presentation/widgets/garage.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TRNK APP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
        routes: {
          '/sign_up':(context)=> const SignUpPage(),
          '/sign_in':(context)=>const SignInPage(),
          '/home':(context)=>const HomePage(),
          '/insurance_information':(context)=>const InsuranceInformationPage(),
          '/next_of_kin_info':(context)=>const NextOfKinPage(),
          '/vehicle_information':(context)=>const VehicleInformationPage(),
          '/emergency_information':(context) => const EmergencyInformation(),
          '/events':(context) => const EventsPage(),
          '/vehicle_data':(context) => const VehicleData(),
          '/add_emergency_information':(context) => const AddEmergencyInformation(),
          '/profile':(context) => const ProfilePage(),
          '/accessories':(context) => const Accessories(),
          '/garage':(context) => const Garage(),
          '/gear':(context) => const Gear(),
          '/mechanics':(context) => const Mechanics(),
          '/service_parts':(context) => const ServiceParts(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const HomePage();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const SignInPage();
          }),
    );
  }
}

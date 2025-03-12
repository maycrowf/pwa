import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:road_oper_app/app.dart';
import 'package:road_oper_app/core/services/export_services.dart';
import 'package:road_oper_app/presentation/cubit/location_cubit.dart';
import 'package:road_oper_app/presentation/cubit/web_view_cubit.dart';

part 'service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await _initServiceLocator();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const RoadOperApp());
}

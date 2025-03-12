import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:road_oper_app/presentation/cubit/location_cubit.dart';
import 'package:road_oper_app/presentation/cubit/web_view_cubit.dart';
import 'package:road_oper_app/presentation/view/oper_web_screen.dart';

class RoadOperApp extends StatelessWidget {
  const RoadOperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetIt.I<WebViewCubit>()),
        BlocProvider(create: (context) => GetIt.I<LocationCubit>()),
      ],
      child: MaterialApp(
        title: 'O.P.E.R.',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const OperWebScreen(),
      ),
    );
  }
}

import 'package:finfresh_test/controller/local_storage/local_storage_bloc.dart';
import 'package:finfresh_test/controller/profile/profile_bloc.dart';
import 'package:finfresh_test/controller/theme/theme_bloc.dart';
import 'package:finfresh_test/controller/todo/todo_bloc.dart';
import 'package:finfresh_test/data/shared_preference/shared_preference.dart';
import 'package:finfresh_test/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref.instance.initStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TodoBloc(LocalStorageBloc())),
        BlocProvider(create: (context) => LocalStorageBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: state,
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

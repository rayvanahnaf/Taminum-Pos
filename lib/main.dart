import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/datasource/auth_local_datasource.dart';
import 'package:flutter_pos/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_pos/data/datasource/product_remote_datasource.dart';
import 'package:flutter_pos/presentation/checkout/auth/bloc/login/login_bloc.dart';
import 'package:flutter_pos/presentation/checkout/auth/bloc/logout/logout_bloc.dart';
import 'package:flutter_pos/presentation/pos/bloc/product/product_bloc.dart';
import 'package:flutter_pos/providers/theme_providers.dart';
import 'package:provider/provider.dart';
import 'presentation/checkout/auth/pages/login_page.dart';
import 'presentation/pos/pages/pos_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MultiBlocProvider(
      providers: [
      BlocProvider(
        create: (context) => LoginBloc(AuthRemoteDataSource()),
      ),
      BlocProvider(
        create: (context) => LogoutBloc(authRemoteDatasource: AuthRemoteDataSource()),
      ),
        BlocProvider(
          create: (context) => ProductBloc(ProductRemoteDatasource())..add(ProductFetched()), // Add ProductBloc
        ),
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter POS',
        themeMode: themeProvider.themeMode,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: const AppBarTheme(backgroundColor: Colors.orange),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF111315),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        ),
        home: FutureBuilder<bool>(
          future: AuthLocalDatasource().isAuthData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasData && snapshot.data == true) {
              return const PosPage();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}

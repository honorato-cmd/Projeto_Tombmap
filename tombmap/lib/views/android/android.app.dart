// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tombmap/views/android/pages/admin/cadastro.dart';
import 'package:tombmap/views/android/pages/admin/cadastroadmin.dart';
import 'package:tombmap/views/android/pages/admin/cadastrofalecido.dart';
import 'package:tombmap/views/android/pages/admin/listadm.dart';
import 'package:tombmap/views/android/pages/admin/listfalecidos.dart';
import 'package:tombmap/views/android/pages/admin/localizador.dart';
import 'package:tombmap/views/android/pages/admin/login.dart';
import 'package:tombmap/views/android/pages/inicial.dart';
import 'package:tombmap/views/android/pages/users/localizarfalecido.dart';

class AndroidApp extends StatelessWidget {
  const AndroidApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Inicial(),
      routes: {
        '/inicial': (context) => Inicial(),
        '/login': (context) => LoginPage(),
        '/localizador': (context) => Localizador(),
        '/localizadorfalecido': (context) => LocalizadorFalecido(),
        '/cadastrofalecido': (context) => CadastrosFalecidos(),
        '/cadastroadministrador': (context) => CadastroAdministrador(),
        '/listadm': (context) => ListaAdm(),
        '/cadastro': (context) => Cadastro(),
        '/listfalecido': (context) => ListaFalecidos(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tombmap/views/android/pages/admin/cadastroadmin.dart';
import 'package:tombmap/views/android/pages/admin/cadastrofalecido.dart';
import 'package:tombmap/views/android/pages/admin/listadm.dart';
import 'package:tombmap/views/android/pages/admin/listfalecidos.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  int _indiceAtual = 0; // Variável para controlar o índice das telas
  final List<Widget> _telas = [
    ListaAdm(),
    ListaFalecidos(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(
          color: Colors.black,
        ),
        selectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        currentIndex: _indiceAtual, // alterando a posição da lista
        onTap: onTabTapped, // chamando o método para chamar uma das opções

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Lista ADM',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Lista Falecido',
          ),
        ],
      ),
    );
  }
}

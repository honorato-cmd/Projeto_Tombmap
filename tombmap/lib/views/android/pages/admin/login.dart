// ignore_for_file: avoid_web_libraries_in_flutter
// ignore_for_file: unused_import
import 'package:local_auth/local_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tombmap/controllers/admin/admin.controller.dart';
import 'package:tombmap/models/admin.model.dart';
import 'package:getwidget/getwidget.dart';
import 'package:tombmap/views/android/pages/admin/update.admin.dart';
import 'package:tombmap/views/android/pages/admin/Auth.dart';
import 'package:getwidget/getwidget.dart';

const kBackgroundColor = Color(0xFF202020);
const kPrimaryColor = Color(0xFFFFBD73);

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final senha = TextEditingController();
  final adminController = new AdminController();
  bool _passwordVisible = false;

  Widget _Email({
    required TextEditingController controller,
    required String label,
    required String hint,
    required double width,
    required Icon prefixIcon,
    Widget? suffixIcon,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        controller: controller,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

   Widget _Senha({
    required TextEditingController controller,
    required String label,
    required String hint,
    required double width,
    required Icon prefixIcon,
    Widget? suffixIcon,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        obscureText: !_passwordVisible,
        controller: controller,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  @override
  void initState() {
    CriarAdm();
    super.initState();
    _passwordVisible = false;
  }

  void CriarAdm() async {
    var teste = await adminController.read();
    if (teste.length == 0) {
      await adminController.create(CadastroAdmin(
          nome: "Admin", cpf: "1000", email: "admin@admin.com", senha: "123"));
    }
  }

  void VerificarLogin() async {
    var teste = await adminController.read();
    var results = await adminController.atualizacao(email.text);
    final result =
        await adminController.read_Email_Senha(email.text, senha.text);
    if (result.isNotEmpty) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        backgroundColor: Colors.white,
        title: Text('Aviso'),
        content: Text(
            'Você está acessando pela primeira vez o aplicativo, te encaminharemos para a tela de update para que faça a atualização do primeiro Admin. Nota: O pimeiro Admin não é exibido na lista!'),
        actions: [
          GFButton(
            shape: GFButtonShape.pills,
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateAdminPage(results)));
            },
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                'Atualizar'.toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
          ),
        ],
      ),
    );
    } else{
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          backgroundColor: Colors.white,
          title: Text('Acesso Negado'),
          content: Text('Este não é seu primeiro acesso, o usuário Admin já foi alterado!'),
          actions: [
            GFButton(
              shape: GFButtonShape.pills,
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'OK'.toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void Autenticar() async {
    final result =
        await adminController.read_Email_Senha(email.text, senha.text);
    if (result.isNotEmpty) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/localizador', (route) => false);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          backgroundColor: Colors.white,
          title: Text('Acesso Negado'),
          content: Text('O Login ou Senha inserida estão incorretos!'),
          actions: [
            GFButton(
              shape: GFButtonShape.pills,
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'OK'.toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.grey),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: (IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/inicial');
            },
            icon: Icon(Icons.arrow_back_outlined),
          )),
          title: Text('Acesso ADMIN'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Image.asset(
              'images/fundoextra.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Login Administrador',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          SizedBox(height: 10),
                          _Email(
                            label: 'E-Mail',
                            hint: 'Digite o E-Mail cadastrado',
                            prefixIcon: Icon(
                              Icons.alternate_email,
                              color: Colors.black,
                            ),
                            controller: email,
                            width: MediaQuery.of(context).size.width * 0.9,
                          ),
                          SizedBox(height: 10),
                          _Senha(
                            label: 'Senha',
                            hint: 'Digite sua senha',
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            controller: senha,
                            width: MediaQuery.of(context).size.width * 0.9,
                          ),
                          SizedBox(height: 10),
                          GFButton(
                            shape: GFButtonShape.pills,
                            color: Colors.black,
                            onPressed: () async {
                              bool isAuthenticated = await Authentication
                                  .authenticateWithBiometrics();

                              if (isAuthenticated) {
                                if (email.text == "admin@admin.com") {
                                  VerificarLogin();
                                } else {
                                  Autenticar();
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  Authentication.customSnackBar(
                                    content:
                                        'Erro ao utilizar a autenticação por biometria!',
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Entrar".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0),
                              ),
                            ),
                          ),
                          GFButton(
                            type: GFButtonType.outline,
                            shape: GFButtonShape.pills,
                            color: Colors.black,
                            onPressed: () {
                              Navigator.of(context).pushNamed('/confirmaemail');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Esqueceu a senha?'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

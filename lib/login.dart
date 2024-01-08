import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  GoogleSignInAccount? _selectedAccount;

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Iniciando sesión...'),
          duration: Duration(seconds: 2),
        ),
      );

      await _selectGoogleAccount();

      if (_selectedAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await _selectedAccount!.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        UserCredential result = await _auth.signInWithCredential(credential);

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        // Después de iniciar sesión, navega a la pantalla de selección de juegos
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MenuSeleccionJuegos(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error en inicio de sesión con Google: $error'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _selectGoogleAccount() async {
    try {
      // Muestra el menú desplegable
      final GoogleSignInAccount? selectedAccount = await _googleSignIn.signIn();

      if (selectedAccount != null) {
        setState(() {
          _selectedAccount = selectedAccount;
        });
      }
    } catch (error) {
      print('Error al obtener cuenta de Google: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesión'),
        backgroundColor: Color.fromARGB(255, 68, 42, 7),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/fondomenu.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              await _handleSignIn(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 68, 42, 7),
            ),
            child: const Text('Iniciar sesión con Google'),
          ),
        ),
      ),
    );
  }
}

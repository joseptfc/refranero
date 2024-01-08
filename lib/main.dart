import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math';
import 'core_Button.dart';
import 'modo_todo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCN7AEP4guwqf_SuUBLIQh7DYo0tDBE2iQ",
      appId: "1:420229068360:android:5f010082ebc319633d8a7d",
      messagingSenderId: "420229068360",
      projectId: "refranero-5e0b2",
    ),
  );
  runApp(const RefranApp());
}

class RefranApp extends StatelessWidget {
  const RefranApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adivina el Refran',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PantallaInicio(),
    );
  }
}

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children: <Widget>[
          Image.asset(
            'lib/assets/fondomenu.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 310,
                    height: 310,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 68, 42, 7),
                        width: 8.0,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'lib/assets/iconomenu.png',
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuSeleccionJuegos extends StatelessWidget {
  const MenuSeleccionJuegos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un modo de juego'),
        backgroundColor: const Color.fromARGB(255, 68, 42, 7),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'lib/assets/fondomenu.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildCoreButton(
                  text: 'Carrera de Refranero',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdivinaElRefran(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60.0),
                buildCoreButton(
                  text: 'Historia de Refranes',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ModoTodosScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60.0),
                buildCoreButton(
                  text: 'Jugar Refranero Diario',
                  onTap: () {
                    // Muestra el mensaje "Próximamente"
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Próximamente"),
                          content: const Text(
                            "¡El Refranero Diario estará disponible próximamente!",
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cerrar"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 60.0),
                buildCoreButton(
                  text: 'Salir',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Salir de la aplicación"),
                          content: const Text(
                              "¿Estás seguro de que deseas salir de la aplicación?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                SystemChannels.platform
                                    .invokeMethod('SystemNavigator.pop');
                              },
                              child: const Text("Salir"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildCoreButton({
  required String text,
  required VoidCallback onTap,
}) {
  return CoreButton(
    text: text,
    onTap: onTap,
    buttonColor:
        const Color.fromARGB(255, 68, 42, 7), // Color marrón personalizado
    width: 200.0, // Ancho personalizado
    height: 48.0, // Alto personalizado
  );
}

class AdivinaElRefran extends StatefulWidget {
  const AdivinaElRefran({super.key});

  @override
  _AdivinaElRefranState createState() => _AdivinaElRefranState();
}

class _AdivinaElRefranState extends State<AdivinaElRefran> {
  List<String> refranes = [
    "A cada cerdo le llega su San Martín",
    "A caballo regalado, no le mires el diente",
    "No hay mal que cien años dure",
    "Cuando el río suena, agua lleva",
    "Bien, ¿adónde vas? A donde tienen más.",
  ];

  int indiceRefranActual = 0;
  String refranOculto = "";
  List<bool> letrasAdivinadas = [];
  int intentosRestantes = 3;
  Set<String> letrasCorrectas = {};
  Set<String> letrasIncorrectas = {};
  bool juegoTerminado = false;
  bool isKeyboardVisible = false;
  int vidas = 3;
  bool pierdeVida = false;
  bool hasPerdidoTodasLasVidas = false;
  bool mostrandoAnuncio = false;
  List<GlobalKey<FlipCardState>> cardKeys = [];
  bool mostrarAnuncio = true;
  List<Widget> corazones = [
    const Icon(Icons.favorite, color: Colors.red),
    const Icon(Icons.favorite, color: Colors.red),
    const Icon(Icons.favorite, color: Colors.red),
  ];
  List<Widget> corazonesRotos = [
    const Icon(Icons.favorite_border, color: Colors.red),
    const Icon(Icons.favorite_border, color: Colors.red),
    const Icon(Icons.favorite_border, color: Colors.red),
  ];
  List<int> refranesCompletados = [];
  List<int> refranesPorCompletar = [];
  bool mostrarBotonCerrar = false;
  bool mostrarBotonReiniciar = false;
  bool completadosTodosRefranes = false; // Declaración de la variable
  int refranesCompletadosCount = 0;

  @override
  void initState() {
    super.initState();
    refranesPorCompletar = List.generate(refranes.length, (index) => index);
    KeyboardVisibilityController().onChange.listen((bool isVisible) {
      setState(() {
        isKeyboardVisible = isVisible;
      });
    });

    int nuevoIndice;
    do {
      nuevoIndice = Random().nextInt(refranes.length);
    } while (nuevoIndice == indiceRefranActual);

    cambiarRefran(nuevoIndice);
  }

  void cambiarRefran(int indice) {
    setState(() {
      if (refranesPorCompletar.isEmpty) {
        completadosTodosRefranes = true; // Todos los refranes se han completado
        // Todos los refranes se han completado
        _mostrarMensaje(
            context, "¡Felicidades, completaste todos los refranes!");
        return;
      }

      // Verificar si el refrán actual ya está en la lista de completados
      if (refranesCompletados.contains(indiceRefranActual)) {
        // Buscar un nuevo refrán que no esté en la lista de completados
        do {
          indice = Random().nextInt(refranes.length);
        } while (refranesCompletados.contains(indice));
      }

      if (indice >= refranesPorCompletar.length) {
        // Wrap back to the first refrán if we've reached the end.
        indice = 0;
      }

      indiceRefranActual = indice;
      int refranIndex = refranesPorCompletar[indice];
      refranOculto = refranes[refranIndex];
      letrasAdivinadas = List.generate(
        refranOculto.length,
        (index) {
          final character = refranOculto[index];
          if (character == ',' ||
              character == '.' ||
              character == ';' ||
              character == ':' ||
              character == '?' ||
              character == '¿' ||
              character == '‘' ||
              character == '’' ||
              character == ' ') {
            return true;
          } else {
            return false;
          }
        },
      );

      intentosRestantes = 3;
      letrasCorrectas = {};
      letrasIncorrectas = {};
      juegoTerminado = false;
      pierdeVida = false;
    });

    cardKeys = List.generate(
      refranOculto.length,
      (index) => GlobalKey<FlipCardState>(),
    );
  }

  String normalizarLetra(String letra) {
    return letra
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');
  }

  void mostrarAnuncioParaVidaExtra() {
    setState(() {
      vidas++;
    });

    Navigator.of(context).pop();
  }

  void comprobarLetra(String letra) {
    setState(() {
      if (!juegoTerminado &&
          letra.length == 1 &&
          letra.replaceAll(RegExp(r'[,.;]'), '').isNotEmpty) {
        String letraRefran = normalizarLetra(refranOculto.toLowerCase());
        letra = normalizarLetra(letra.toLowerCase());

        bool todasLetrasAdivinadas = true;

        if (letraRefran.contains(letra) && !letrasCorrectas.contains(letra)) {
          for (int i = 0; i < refranOculto.length; i++) {
            if (letraRefran[i] == letra && !letrasAdivinadas[i]) {
              letrasAdivinadas[i] = true;
              cardKeys[i].currentState?.toggleCard();
              letrasCorrectas.add(letra);
            }
            if (!letrasAdivinadas[i]) {
              todasLetrasAdivinadas = false;
            }
          }

          if (todasLetrasAdivinadas) {
            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {
                juegoTerminado = true;
                refranesCompletadosCount++; // Aumenta el contador
                refranesCompletados.add(indiceRefranActual);
                _mostrarMensaje(
                  context,
                  "¡Enhorabuena! ¡Has completado el refrán!",
                  mostrarBotonSiguiente: true,
                );
              });
            });
          }
        } else if (!letrasIncorrectas.contains(letra)) {
          letrasIncorrectas.add(letra);

          if (intentosRestantes > 0) {
            intentosRestantes--;
          } else {
            intentosRestantes = 3; // Reinicia el contador de intentos a 3
            if (vidas > 0) {
              pierdeVida = true;
              vidas--;
              _mostrarMensaje(
                context,
                "Consumiste un corazón!",
                mostrarBotonCerrar: true,
              );
            } else {
              juegoTerminado = true;
              if (vidas < 1) {
                pierdeVida = true;
                _mostrarMensaje(context, "¡Te has quedado sin vidas!");
              } else {
                _mostrarMensaje(
                  context,
                  "¡Has perdido todas tus vidas! ¡Fin del juego!",
                );
              }
            }
          }
        }
      }
    });
  }

  void _mostrarMensaje(
    BuildContext context,
    String mensaje, {
    bool mostrarBotonSiguiente = false,
    bool mostrarAnuncioVida = false,
    bool mostrarBotonCerrar = false,
    bool mostrarBotonReiniciar = false,
    double position =
        0.7, // Ajusta la posición vertical (0.7 representa el 70% desde la parte superior)
  }) {
    if (refranesCompletados.length == refranes.length) {
      // Todos los refranes se han completado
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("¡Felicidades, completaste todos los refranes!"),
            content:
                const Text("¡Has completado todos los refranes disponibles!"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MenuSeleccionJuegos(),
                    ),
                  );
                },
                child: const Text('Volver al menú'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  reiniciarJuego();
                },
                child: const Text("Reiniciar"),
              ),
            ],
          );
        },
      );
      return;
    }

    if (vidas <= 0) {
      mensaje = "¡Te has quedado sin corazones!";
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("¡Te has quedado sin vidas!"),
            content: Text(mensaje),
            actions: [
              if (mostrarAnuncioVida)
                TextButton(
                  onPressed: () {
                    mostrarAnuncioParaVidaExtra();
                  },
                  child: const Row(
                    children: [
                      Text("Ver anuncio"),
                      SizedBox(width: 5),
                      Icon(Icons.favorite, color: Colors.red),
                    ],
                  ),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  reiniciarJuego();
                },
                child: const Text("Reiniciar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MenuSeleccionJuegos(),
                    ),
                  );
                },
                child: const Text("Salir"),
              ),
            ],
          );
        },
      );
      return;
    }
    List<Widget> corazonesAMostrar;
    if (hasPerdidoTodasLasVidas) {
      corazonesAMostrar = [
        corazonesRotos[0],
        corazonesRotos[1],
        corazonesRotos[2]
      ];
    } else {
      if (vidas == 3) {
        corazonesAMostrar = corazones;
      } else if (vidas == 2) {
        corazonesAMostrar = [corazones[0], corazones[1], corazonesRotos[0]];
      } else if (vidas == 1) {
        corazonesAMostrar = [
          corazones[0],
          corazonesRotos[1],
          corazonesRotos[0]
        ];
      } else if (vidas == 0) {
        corazonesAMostrar = [
          corazonesRotos[0],
          corazonesRotos[1],
          corazonesRotos[2]
        ];
      } else {
        corazonesAMostrar = [
          corazonesRotos[0],
          corazonesRotos[1],
          corazonesRotos[2]
        ];
      }
    }

    if (mostrarAnuncioVida && !mostrandoAnuncio) {
      mostrandoAnuncio = true;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Ver anuncio para obtener una vida extra"),
            content: const Text(
                "¿Deseas ver un anuncio para obtener una vida extra?"),
            actions: [
              TextButton(
                onPressed: () {
                  mostrarAnuncioParaVidaExtra();
                },
                child: const Text("Ver Anuncio"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancelar"),
              ),
            ],
          );
        },
      ).then((_) {
        mostrandoAnuncio = false;
        if (hasPerdidoTodasLasVidas) {
          reiniciarJuego();
        }
      });
    } else {
      List<Widget> actions = [];

      if (mostrarBotonCerrar) {
        actions.add(
          TextButton(
            onPressed: () {
              // Cerrar la ventana de diálogo
              Navigator.of(context).pop();
            },
            child: const Text("Cerrar"),
          ),
        );
      } else {
        if (mostrarBotonSiguiente) {
          actions.add(
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                int nuevoIndice;
                do {
                  nuevoIndice = Random().nextInt(refranes.length);
                } while (refranesCompletados.contains(nuevoIndice) ||
                    nuevoIndice == indiceRefranActual);
                cambiarRefran(nuevoIndice);
              },
              child: const Text("Siguiente"),
            ),
          );
        }
        if (mostrarBotonReiniciar) {
          actions.add(
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                reiniciarJuego();
              },
              child: const Text("Reiniciar"),
            ),
          );
        }
      }

      // Ajusta la posición del cuadro de diálogo
      final screenHeight = MediaQuery.of(context).size.height;
      final dialogHeight =
          screenHeight * 0.6; // Personaliza según tus necesidades

      // Calcula la posición vertical basada en la altura de la pantalla
      double dialogPosition = screenHeight * position;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Align(
            alignment: Alignment
                .bottomCenter, // Alinea el diálogo en la parte inferior
            child: FractionallySizedBox(
              heightFactor:
                  0.5, // Ajusta la altura del cuadro de diálogo según sea necesario
              child: AlertDialog(
                title: const Text("Resultado"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(mensaje),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < corazonesAMostrar.length; i++)
                          corazonesAMostrar[i],
                      ],
                    ),
                  ],
                ),
                actions: actions,
                elevation: 24.0,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
            ),
          );
        },
      ).then((_) {
        if (pierdeVida) {
          setState(() {
            corazonesRotos.add(corazones.removeLast());
          });
        }
      });
    }
  }

  void reiniciarJuego() {
    setState(() {
      vidas = 3;
      corazones = [
        const Icon(Icons.favorite, color: Colors.red),
        const Icon(Icons.favorite, color: Colors.red),
        const Icon(Icons.favorite, color: Colors.red),
      ];
      hasPerdidoTodasLasVidas = false;
      refranesCompletadosCount = 0; // Reinicia el contador
      refranesCompletados.clear();
      refranesPorCompletar = List.generate(refranes.length, (index) => index);

      int nuevoIndice;
      do {
        nuevoIndice = Random().nextInt(refranes.length);
      } while (nuevoIndice == indiceRefranActual);

      cambiarRefran(nuevoIndice);
    });
  }

  Widget buildFlipCard(int index) {
    final character = refranOculto[index];

    // Separa el refrán en palabras
    final palabras = refranOculto.split(' ');

    // Calcula el índice de la palabra actual
    int palabraActualIndex = 0;
    int currentIndex = 0;

    for (final palabra in palabras) {
      final palabraLength = palabra.length;
      if (currentIndex + palabraLength > index) {
        break;
      }
      currentIndex += palabraLength;
      palabraActualIndex++;
      if (currentIndex < refranOculto.length) {
        currentIndex++; // Avanza por el espacio
      }
    }

    // Define los dos colores para alternar
    final List<Color> colores = [
      const Color.fromARGB(255, 18, 4, 82),
      const Color.fromARGB(255, 6, 53, 10),
    ];

    // Determina el color actual para el fondo del FlipCard
    final Color colorFondo = colores[palabraActualIndex % 2];

    return FlipCard(
      key: cardKeys[index],
      direction: FlipDirection.HORIZONTAL,
      onFlipDone: (_) {},
      front: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(4),
        color: letrasAdivinadas[index]
            ? const Color.fromARGB(255, 12, 112, 15)
            : colorFondo, // Cambia el color del fondo
        alignment: Alignment.center,
        child: AutoSizeText(
          letrasAdivinadas[index] ||
                  character == ',' ||
                  character == ';' ||
                  character == '.'
              ? character
              : '_', // Mostrar "?" si la carta no está girada
          style: TextStyle(
            fontSize: 16,
            color: letrasAdivinadas[index]
                ? Colors.white
                : Colors.white, // Aplica el color de texto
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      back: letrasAdivinadas[index]
          ? Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.all(4),
              color: colorFondo, // Cambia el color del fondo
              alignment: Alignment.center,
              child: AutoSizeText(
                character,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          : const SizedBox(
              width: 40,
              height: 40,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight =
        MediaQuery.of(context).size.height; // Definimos screenHeight
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(
            255, 68, 42, 7), // Fondo transparente de AppBar
        elevation: 0, // Sin sombra
        title: Row(
          children: [
            const Text(
              'Carrera de refraneros ',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              refranesCompletadosCount.toString().padLeft(2, '0'),
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              for (int i = 0; i < vidas; i++)
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              for (int i = 0; i < 3 - vidas; i++)
                const Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/fondomenu.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                  height: 20), // Añade espacio encima de los FlipCard
              Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(
                  refranOculto.length,
                  (index) {
                    final character = refranOculto[index];
                    final isSpace = character == ' ';
                    if (isSpace) {
                      return const SizedBox(width: 40);
                    }
                    return buildFlipCard(index);
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Spacer(),
              const Spacer(), // Este Spacer empujará el teclado hacia abajo
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                ),
                itemCount: 30,
                itemBuilder: (context, index) {
                  String qwertyLayout = "qwertyuiopasdfghjklñzxcvbnm";
                  String letra =
                      index < qwertyLayout.length ? qwertyLayout[index] : "";
                  final isLetterGuessed = letrasCorrectas.contains(letra) ||
                      letrasIncorrectas.contains(letra);
                  final tileColor = isLetterGuessed
                      ? const Color.fromARGB(183, 83, 83, 83).withOpacity(0.9)
                      : const Color.fromARGB(255, 61, 37, 5);
                  final textColor =
                      isLetterGuessed ? Colors.grey : Colors.white;
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: tileColor,
                      borderRadius:
                          BorderRadius.circular(0), // Elimina el borde
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (!isLetterGuessed &&
                            letrasAdivinadas.contains(false)) {
                          comprobarLetra(letra);
                        }
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(const EdgeInsets.all(
                            0)), // Elimina el espaciado interno
                      ),
                      child: AutoSizeText(
                        letra,
                        style: TextStyle(fontSize: 24, color: textColor),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),

              const Spacer(), // Esto empujará los elementos hacia abajo

              // Mueve los elementos "Intentos restantes," "Correctas," e "Incorrectas" al final
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Intentos restantes: $intentosRestantes',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Correctas: ${letrasCorrectas.join(', ')}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Incorrectas: ${letrasIncorrectas.join(', ')}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight >= 600 ? 20 : 10),
            ],
          ),
        ),
      ),
    );
  }
}

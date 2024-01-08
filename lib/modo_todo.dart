import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MaterialApp(
    home: ModoTodosScreen(),
  ));
}

Future<void> guardarProgreso(
    String jugadorId, List<Refran> refranesCompletados) async {
  try {
    await FirebaseFirestore.instance
        .collection('jugadores')
        .doc(jugadorId)
        .set({
      'refranesCompletados': refranesCompletados
          .where((refran) => refran.completado)
          .map((refran) => refran.id)
          .toList(),
    });
  } catch (e) {
    print('Error al guardar el progreso: $e');
  }
}

final List<Refran> refranesClasicos = [
  Refran(1, 'a', false, const Color.fromARGB(255, 68, 42, 7)),
  Refran(2, 'Más vale estar solo que mal acompañado', false,
      const Color.fromARGB(255, 68, 42, 7)),
  Refran(3, 'Perro ladrador poco mordedor', false,
      const Color.fromARGB(255, 68, 42, 7)),
  Refran(4, 'A caballo regalado no le mires el dentado', false,
      const Color.fromARGB(255, 68, 42, 7)),
  // Agrega los demás refranes aquí
  Refran(5, 'Sarna con gusto no pica', false,
      const Color.fromARGB(255, 68, 42, 7)),
  Refran(6, "Atardecer ‘colorao’, viento ‘asegurao’", false,
      const Color.fromARGB(255, 68, 42, 7)),
];

class Refran {
  final int id;
  final String texto;
  bool completado;
  Color color;

  Refran(this.id, this.texto, this.completado, this.color);
}

class SubmenuRefranesChiste extends StatefulWidget {
  const SubmenuRefranesChiste({super.key});

  @override
  _SubmenuRefranesChisteState createState() => _SubmenuRefranesChisteState();
}

class _SubmenuRefranesChisteState extends State<SubmenuRefranesChiste> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refranes Clasicos'),
        backgroundColor: const Color.fromARGB(
            255, 68, 42, 7), // Cambia el color de fondo de la AppBar
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'lib/assets/fondomenu.jpg'), // Establece la imagen de fondo
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(
                20), // Añade un espacio alrededor de los botones
            child: Wrap(
              spacing: 10, // Espacio horizontal entre botones
              runSpacing: 10, // Espacio vertical entre botones
              children: List.generate(
                refranesClasicos.length,
                (index) {
                  final refran = refranesClasicos[index];
                  return ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JuegoRefran(
                            refran: refran,
                            numeroRefran: (index + 1).toString(),
                            actualizarEstado: () {
                              // Actualiza el estado del botón cuando regreses desde la pantalla de juego
                              setState(() {
                                refran.color = Colors.green;
                              });
                            },
                            refranesCompletados: const [],
                          ),
                        ),
                      );

                      // Verifica si el refrán se ha completado correctamente y actualiza el color del botón
                      if (result != null && result is bool && result) {
                        setState(() {
                          refran.color = Colors.green;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: refran.color,
                      minimumSize: const Size(
                          40, 40), // Tamaño cuadrado más pequeño del botón
                    ),
                    child: Text('${index + 1}'),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class JuegoRefran extends StatefulWidget {
  final Refran refran;
  final String numeroRefran;
  final Function actualizarEstado;
  final List<int> refranesCompletados;

  const JuegoRefran({
    super.key,
    required this.refran,
    required this.numeroRefran,
    required this.actualizarEstado,
    required this.refranesCompletados,
  });

  @override
  _JuegoRefranState createState() => _JuegoRefranState(refranesCompletados);
}

class _JuegoRefranState extends State<JuegoRefran> {
  late String refranOculto;
  List<bool> letrasAdivinadas = [];
  List<int> refranesCompletados; // Declarar la lista refranesCompletados
  int intentosRestantes = 3;
  Set<String> letrasCorrectas = {};
  Set<String> letrasIncorrectas = {};
  bool juegoTerminado = false;
  late List<GlobalKey<FlipCardState>> cardKeys;
  int indiceRefranActual = 0;
  List<bool> cartasGiradas = [];

  bool _verificarRefranCompletado() {
    for (int i = 0; i < refranOculto.length; i++) {
      final character = refranOculto[i];
      final isSpaceOrSpecialChar = (character == ',' ||
          character == '.' ||
          character == ';' ||
          character == '?' ||
          character == '¿' ||
          character == '‘' ||
          character == '’' ||
          character == ' ');
      if (!isSpaceOrSpecialChar && !letrasAdivinadas[i]) {
        return false;
      }
    }

    // Actualiza el estado de los botones aquí para cambiar el color
    setState(() {
      // Marca el refrán actual como completado
      final int indiceRefranActual = refranesClasicos.indexWhere(
        (refran) => refran.texto == refranOculto,
      );

      if (indiceRefranActual != -1) {
        refranesClasicos[indiceRefranActual].completado = true;
        refranesClasicos[indiceRefranActual].color = Colors.green;
      }
    });

    widget.actualizarEstado();

    // Obtén el ID del jugador (puedes obtenerlo según tus necesidades)
    String jugadorId = 'sDP1fMjuWlZrZQXxB3Z1s4sT5m12';

    // Guarda el progreso
    guardarProgreso(jugadorId, refranesClasicos);

    return true;
  }

  _JuegoRefranState(this.refranesCompletados) {
    refranesCompletados =
        refranesCompletados; // Inicializar la lista en el constructor
  }

  bool mostrarBotonReinicio = false;
  int refranesCompletadosCount = 0;

  void actualizarEstado() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    cardKeys = List.generate(
        widget.refran.texto.length,
        (index) => GlobalKey<
            FlipCardState>()); // Usa widget.refran.texto en lugar de widget.refranInicial
    cambiarRefran(widget.refran
        .texto); // Usa widget.refran.texto en lugar de widget.refranInicial
  }

  void cambiarRefran(String nuevoRefran) {
    setState(() {
      refranOculto = nuevoRefran;
      letrasAdivinadas = List.generate(nuevoRefran.length, (index) => false);
      // Inicializar la lista de cartas giradas con falsos
      cartasGiradas = List.generate(nuevoRefran.length, (index) => false);
    });
  }

  String normalizarLetra(String letra) {
    return letra
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');
  }

  void reiniciarJuego() {
    setState(() {
      letrasAdivinadas = List.generate(refranOculto.length, (index) => false);
      intentosRestantes = 3;
      letrasCorrectas.clear();
      letrasIncorrectas.clear();
      juegoTerminado = false;
    });
  }

  void siguienteRefran(BuildContext context, List<int> refranesCompletados) {
    if (refranesCompletados.contains(indiceRefranActual)) {
      // Si el refrán actual se ha completado, busca el siguiente refrán no completado
      int siguienteRefran = indiceRefranActual + 1;
      while (siguienteRefran < refranesClasicos.length &&
          refranesCompletados.contains(siguienteRefran)) {
        siguienteRefran++;
      }
      if (siguienteRefran < refranesClasicos.length) {
        // Si se encontró un siguiente refrán no completado, cámbialo
        setState(() {
          indiceRefranActual = siguienteRefran;
          cambiarRefran(refranesClasicos[indiceRefranActual].texto);
          mostrarBotonReinicio =
              false; // Restablece mostrarBotonReinicio a false
        });
      } else {
        // No se encontraron refranes no completados, muestra un mensaje final
        mostrarMensaje(
          context,
          "¡Enhorabuena! ¡Has completado todos los refranes!",
        );
      }
    } else {
      // Si el refrán actual no se ha completado, muestra un mensaje de confirmación
      mostrarMensaje(
        context,
        "¿Deseas cambiar al siguiente refrán sin completar el actual?",
        onSiguiente: () {
          setState(() {
            int siguienteRefran = indiceRefranActual + 1;
            while (siguienteRefran < refranesClasicos.length &&
                refranesCompletados.contains(siguienteRefran)) {
              siguienteRefran++;
            }
            if (siguienteRefran < refranesClasicos.length) {
              // Si se encontró un siguiente refrán no completado, cámbialo
              indiceRefranActual = siguienteRefran;
              cambiarRefran(refranesClasicos[indiceRefranActual].texto);
              mostrarBotonReinicio =
                  false; // Restablece mostrarBotonReinicio a false
            } else {
              // No se encontraron refranes no completados, muestra un mensaje final
              mostrarMensaje(
                context,
                "¡Enhorabuena! ¡Has completado todos los refranes!",
              );
            }
          });
        },
      );
    }
  }

  void mostrarMensaje(BuildContext context, String mensaje,
      {Function()? onSiguiente}) {
    showDialog(
      context: context,
      barrierDismissible: mensaje !=
          'Has perdido... Vuelve a intentarlo', // Deshabilita el cierre haciendo clic fuera del cuadro de diálogo si no es el mensaje de pérdida
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Resultado"),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                reiniciarJuego();
                Navigator.of(context).pop();
              },
              child: const Text("Reiniciar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: const Text("Siguiente"),
            ),
          ],
        );
      },
    );
  }

  void verificarRefran(BuildContext context) {
    if (juegoTerminado) return;

    if (_verificarRefranCompletado()) {
      // Has completado el refrán correctamente
      setState(() {
        juegoTerminado = true;
        refranesCompletadosCount++;
        refranesCompletados.add(indiceRefranActual);

        if (indiceRefranActual >= refranesClasicos.length - 1) {
          // Has completado todos los refranes, muestra un mensaje final
          mostrarMensaje(
            context,
            "¡Enhorabuena! ¡Has completado todos los refranes!",
          );
          Navigator.pop(context, true);
        } else {
          // Si no has completado todos los refranes, muestra el mensaje con el número del siguiente refrán
          mostrarMensaje(
            context,
            "¡Enhorabuena! ¡Has completado el refrán!",
          );
          Navigator.pop(context, false);
          // Actualiza el color del botón en el widget padre
        }
      });
    } else {
      // No has completado el refrán correctamente
      mostrarMensaje(context, 'Aún no has completado el refrán correctamente');
    }
  }

  void comprobarLetra(BuildContext context, String letra) {
    if (juegoTerminado) return;

    // Normaliza la letra ingresada antes de continuar
    letra = normalizarLetra(letra);

    setState(() {
      bool letraAdivinada = false;
      for (int i = 0; i < refranOculto.length; i++) {
        // Normaliza la letra del refrán antes de compararla
        final refranCharacter = normalizarLetra(refranOculto[i]);
        if (refranCharacter.toLowerCase() == letra.toLowerCase()) {
          letrasAdivinadas[i] = true; // Marcar la letra como adivinada
          letraAdivinada = true;

          // Utiliza la clave global para voltear la carta
          cardKeys[i].currentState!.toggleCard();
        }
      }

      if (letraAdivinada) {
        letrasCorrectas.add(letra);
      } else {
        letrasIncorrectas.add(letra);
        intentosRestantes--;

        if (intentosRestantes == 0) {
          juegoTerminado = true;
          mostrarMensaje(context, 'Has perdido... Vuelve a intentarlo');
          // Implementa la lógica para manejar la derrota aquí
        }
      }

      // Verificar si el refrán actual se ha completado
      if (_verificarRefranCompletado()) {
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            juegoTerminado = true;

            // Verifica si has completado todos los refranes
            if (indiceRefranActual >= refranesClasicos.length - 1) {
              // Has completado todos los refranes, muestra un mensaje final
              mostrarMensaje(
                context,
                "¡Enhorabuena! ¡Has completado todos los refranes!",
              );
            } else {
              // Si no has completado todos los refranes, muestra el mensaje con el número del siguiente refrán
              mostrarMensaje(
                context,
                "¡Enhorabuena! ¡Has completado el refrán!",
              );
            }
          });
        });
      }
    });
  }

  Widget buildFlipCard(int index) {
    final character = refranOculto[index];
    final isSpaceOrSpecialChar = (character == ',' ||
        character == '.' ||
        character == ';' ||
        character == ':' ||
        character == '?' ||
        character == '¿' ||
        character == '‘' ||
        character == '’' ||
        character == ' ');

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

    if (isSpaceOrSpecialChar) {
      // Si es un espacio o un carácter especial, muestra el contenido directamente
      return Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.all(4),
        color: letrasAdivinadas[index]
            ? const Color.fromARGB(255, 12, 112, 15)
            : colorFondo,
        alignment: Alignment.center,
        child: AutoSizeText(
          character,
          style: TextStyle(
            fontSize: 16,
            color: letrasAdivinadas[index] ? Colors.white : Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

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
            : colorFondo,
        alignment: Alignment.center,
        child: AutoSizeText(
          letrasAdivinadas[index] ? character : '_',
          style: TextStyle(
            fontSize: 16,
            color: letrasAdivinadas[index] ? Colors.white : Colors.white,
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
              color: colorFondo,
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
        MediaQuery.of(context).size.height; // Declarar screenHeight aquí
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 68, 42, 7),
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Refrán nº ',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              widget.numeroRefran, // Muestra el número del refrán aquí
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Icono de flecha hacia atrás
          onPressed: () {
            Navigator.pop(context); // Vuelve al menú principal
          },
        ),
        actions: [
          Row(
            children: [
              for (int i = 0; i < intentosRestantes; i++)
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              for (int i = 0; i < 3 - intentosRestantes; i++)
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
              const SizedBox(height: 20),
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
              const Spacer(),
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
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (!isLetterGuessed &&
                            letrasAdivinadas.contains(false)) {
                          comprobarLetra(context, letra);
                        }
                      },
                      style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(0)),
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
              SizedBox(height: screenHeight >= 600 ? 20 : 10),
              const Spacer(),
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

class ModoTodosScreen extends StatelessWidget {
  const ModoTodosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historia de Refranero'),
        backgroundColor: const Color.fromARGB(
            255, 68, 42, 7), // Cambiar el color de fondo de la AppBar
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
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubmenuRefranesChiste(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  shape: const CircleBorder(),
                ),
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(
                          255, 68, 42, 7), // Color del borde marrón
                      width: 2.0, // Ancho del borde delgado
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'lib/assets/refranespopulares.jpg',
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Contenido adicional aquí
            ],
          ),
        ),
      ),
    );
  }
}

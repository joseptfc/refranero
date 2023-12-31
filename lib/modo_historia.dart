import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';

final List<Refran> refranesPopulares = [
  Refran('Más vale estar solo que mal acompañado', false),
  Refran('Perro ladrador poco mordedor', false),
  Refran('A caballo regalado no le mires el dentado', false),
  // Agrega los demás refranes aquí
  // ...
  Refran('. Sarna con gusto no pica', false),
  Refran("Atardecer ‘colorao’, viento ‘asegurao’", false),
];

class Refran {
  final String texto;
  bool completado; // Agrega una propiedad para el estado de completado

  Refran(this.texto, this.completado);
}

List<bool> refranesCompletos =
    List.generate(refranesPopulares.length, (index) => false);
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MaterialApp(
    home: RefraneroHistoria(),
  ));
}

List<int> refranesCompletados = [];

class RefraneroHistoria extends StatelessWidget {
  final Color buttonColor = Color.fromARGB(255, 145, 71, 71);

  @override
  Widget build(BuildContext context) {
    final RefraneroPopularScreen refraneroPopularScreen =
        RefraneroPopularScreen(
      'Refranes Populares',
      refranesPopulares,
      refranesCompletados,
      Color.fromARGB(255, 167, 65, 158),
      TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      0, // Aquí pasa el valor de indiceRefranActual
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Refranero de Historia',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: Stack(
        children: <Widget>[
          // Fondo de imagen
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => refraneroPopularScreen,
                      ),
                    );
                  },
                  child: Container(
                    width: 270,
                    height: 270,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            Color.fromARGB(255, 68, 42, 7), // Color del borde
                        width: 8.0, // Ancho del borde
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RefraneroPopularScreen extends StatefulWidget {
  final String categoria;
  final List<Refran> refranesPopulares;
  final List<int> refranesCompletados;
  final Color titleColor;
  final TextStyle titleTextStyle;
  int indiceRefranActual;
  late Color
      buttonColor; // Usa "late" para indicar que se inicializará más tarde

  RefraneroPopularScreen(
    this.categoria,
    this.refranesPopulares,
    this.refranesCompletados,
    this.titleColor,
    this.titleTextStyle,
    this.indiceRefranActual,
  ) {
    buttonColor = getButtonBackgroundColor(indiceRefranActual);
  }

  Color getButtonBackgroundColor(int index) {
    if (index < refranesPopulares.length) {
      return refranesPopulares[index].completado ? Colors.green : Colors.orange;
    }
    return const Color.fromARGB(255, 104, 99, 92);
  }

  void actualizarEstadoRefranesCompletados() {
    for (int i = 0; i < refranesPopulares.length; i++) {
      final isCompletedRefran = refranesCompletados.contains(i);
      refranesPopulares[i].completado = isCompletedRefran;
    }
  }

  @override
  _RefraneroPopularScreenState createState() =>
      _RefraneroPopularScreenState(indiceRefranActual);
}

class _RefraneroPopularScreenState extends State<RefraneroPopularScreen> {
  int indiceRefranActual;
  Color buttonColor = Color.fromARGB(255, 145, 71, 71); // Color inicial

  _RefraneroPopularScreenState(this.indiceRefranActual);
  void actualizarEstado() {
    setState(() {});
  }

  void _actualizarEstado(int index) {
    setState(() {
      refranesPopulares[index].completado = true;
      refranesCompletos[index] = true;
    });
  }

  bool isRefranCompleto(int index) {
    return widget.refranesPopulares[index].completado;
  }

  void actualizarColorBoton(int index) {
    setState(() {
      if (index < widget.refranesPopulares.length) {
        widget.refranesPopulares[index].completado = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoria,
          style: widget.titleTextStyle,
        ),
        backgroundColor: widget.titleColor,
      ),
      body: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
          widget.refranesPopulares.length,
          (index) {
            final numero = (index + 1).toString();
            final refran = widget.refranesPopulares[index];
            final isCompletedRefran = refranesCompletados.contains(index);

            return GestureDetector(
              onTap: () {
                widget.indiceRefranActual = index;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JuegoRefranesScreen(
                      refranInicial: refran.texto,
                      numeroRefran: numero,
                      onRefranComplete: (refranCompletado) {
                        print('Refrán completado: $refranCompletado');
                        int index = refranesPopulares.indexOf(refran);
                        if (index != -1) {
                          widget
                              .actualizarEstadoRefranesCompletados(); // Llama a la función para actualizar el estado
                        }
                      },
                      refranesCompletados: widget.refranesCompletados,
                      indiceRefranActual: index,
                      actualizarEstado: actualizarEstado,
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isCompletedRefran
                          ? Colors.green
                          : widget.getButtonBackgroundColor(
                              index), // Utiliza getButtonBackgroundColor
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        numero,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  if (isCompletedRefran)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class JuegoRefranesScreen extends StatefulWidget {
  final String refranInicial;
  final String numeroRefran;
  final Function(String) onRefranComplete;
  final List<int> refranesCompletados;
  final int indiceRefranActual;
  final Function actualizarEstado;
  final Color brownColor = Color.fromARGB(255, 85, 48, 0);
  final Color greenColor = Colors.green;

  JuegoRefranesScreen({
    required this.refranInicial,
    required this.numeroRefran,
    required this.onRefranComplete,
    required this.refranesCompletados,
    required this.indiceRefranActual,
    required this.actualizarEstado,
  }) {
    // Restaura el estado de completado de cada refrán basado en la lista de refranesCompletados
    for (int i = 0; i < refranesCompletados.length; i++) {
      final index = refranesCompletados[i];
      if (index >= 0 && index < refranesPopulares.length) {
        refranesPopulares[index].completado = true;
      }
    }
  }

  @override
  _JuegoRefranesScreenState createState() => _JuegoRefranesScreenState();
}

class _JuegoRefranesScreenState extends State<JuegoRefranesScreen> {
  late String refranOculto;
  List<bool> letrasAdivinadas = [];
  int intentosRestantes = 3;
  Set<String> letrasCorrectas = {};
  Set<String> letrasIncorrectas = {};
  bool juegoTerminado = false;
  late List<GlobalKey<FlipCardState>> cardKeys;
  int indiceRefranActual = 0;
  List<bool> cartasGiradas = [];
  Color botonColor = Color.fromARGB(255, 145, 71, 71); // Color inicial
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

    // Cambiar el color del botón a verde cuando se complete el refrán
    widget
        .actualizarEstado(); // Llamar al método para actualizar el estado en el widget padre

    return true;
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
        widget.refranInicial.length, (index) => GlobalKey<FlipCardState>());
    cambiarRefran(widget.refranInicial);
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

  void siguienteRefran(BuildContext context) {
    if (refranesCompletados.contains(indiceRefranActual)) {
      // Si el refrán actual se ha completado, busca el siguiente refrán no completado
      int siguienteRefran = indiceRefranActual + 1;
      while (siguienteRefran < refranesPopulares.length &&
          refranesCompletados.contains(siguienteRefran)) {
        siguienteRefran++;
      }
      if (siguienteRefran < refranesPopulares.length) {
        // Si se encontró un siguiente refrán no completado, cámbialo
        setState(() {
          indiceRefranActual = siguienteRefran;
          cambiarRefran(refranesPopulares[indiceRefranActual].texto);

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
          title: Text("Resultado"),
          content: Text(mensaje),
          actions: [
            TextButton(
              onPressed: () {
                reiniciarJuego();
                Navigator.of(context).pop();
              },
              child: Text("Reiniciar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: Text("Siguiente"),
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

        if (indiceRefranActual >= refranesPopulares.length - 1) {
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
          // Actualiza el color del botón en el widget padre
          botonColor = Colors.green;
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
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            juegoTerminado = true;

            // Verifica si has completado todos los refranes
            if (indiceRefranActual >= refranesPopulares.length - 1) {
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
      Color.fromARGB(255, 18, 4, 82),
      Color.fromARGB(255, 6, 53, 10),
    ];

    // Determina el color actual para el fondo del FlipCard
    final Color colorFondo = colores[palabraActualIndex % 2];

    if (isSpaceOrSpecialChar) {
      // Si es un espacio o un carácter especial, muestra el contenido directamente
      return Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(4),
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
        margin: EdgeInsets.all(4),
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
              margin: EdgeInsets.all(4),
              color: colorFondo,
              alignment: Alignment.center,
              child: AutoSizeText(
                character,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          : Container(
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
        backgroundColor: Color.fromARGB(255, 68, 42, 7),
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Refrán nº ',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '${widget.numeroRefran}', // Muestra el número del refrán aquí
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icono de flecha hacia atrás
          onPressed: () {
            Navigator.pop(context); // Vuelve al menú principal
          },
        ),
        actions: [
          Row(
            children: [
              for (int i = 0; i < intentosRestantes; i++)
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              for (int i = 0; i < 3 - intentosRestantes; i++)
                Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
            ],
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/fondomenu.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(
                  refranOculto.length,
                  (index) {
                    final character = refranOculto[index];
                    final isSpace = character == ' ';
                    if (isSpace) {
                      return SizedBox(width: 40);
                    }
                    return buildFlipCard(index);
                  },
                ),
              ),
              SizedBox(height: 20),
              Spacer(),
              Spacer(),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                      ? Color.fromARGB(183, 83, 83, 83).withOpacity(0.9)
                      : Color.fromARGB(255, 61, 37, 5);
                  final textColor =
                      isLetterGuessed ? Colors.grey : Colors.white;
                  return Container(
                    margin: EdgeInsets.all(4),
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
                        padding: MaterialStateProperty.all(EdgeInsets.all(0)),
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
              Spacer(),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Intentos restantes: $intentosRestantes',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Correctas: ${letrasCorrectas.join(', ')}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Incorrectas: ${letrasIncorrectas.join(', ')}',
                        style: TextStyle(
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

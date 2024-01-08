import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // Importa esta biblioteca para obtener la hora local.
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class RefraneroDiario extends StatefulWidget {
  const RefraneroDiario({super.key});

  @override
  _RefraneroDiarioState createState() => _RefraneroDiarioState();
}

class _RefraneroDiarioState extends State<RefraneroDiario> {
  List<String> refranes = [
    "A cada cerdo le llega su San Martín",
    "A caballo regalado, no le mires el diente",
    "No hay mal que cien años dure",
    "Cuando el río suena, agua lleva",
    "A mal tiempo buena cara",
    "A mal tiempo buena cara",
    "Nadie sabe lo que tiene hasta que ordena su cuarto",
    "El que sabe sabe; y el que no, a empresariales",
    "No por mucho madrugar amanece más temprano",
    "Más vale estar solo que mal acompañado",
    "Perro ladrador poco mordedor",
    "A caballo regalado no le mires el dentado",
    "A lo hecho, pecho.",
    "Al mal tiempo, buena cara.",
    "Cada loco con su tema.",
    "De tal palo, tal astilla.",
    "El que la hace, la paga.",
    "Dinero llama dinero.",
    "El mundo es un pañuelo.",
    "A la tercera va la vencida.",
    "Cada oveja con su pareja.",
    "Más vale prevenir que lamentar.",
    "Más vale tarde que nunca.",
    "En boca cerrada no entran moscas.",
    "Al que madruga, Dios lo ayuda.",
    "El que calla otorga.",
    "Amor con hambre no dura.",
    "Tira la piedra y esconde la mano.",
    "El que ríe el último, ríe mejor.",
    "El hábito no hace al monje.",
    "A palabras necias, oídos sordos.",
    "Crea fama y acuéstate a dormir.",
    "Del dicho al hecho, hay mucho trecho.",
    "Dios aprieta pero no ahorca.",
    "Donde fueres, haz lo que vieres.",
    "Quien mucho abarca, poco aprieta.",
    "Hombre precavido vale por dos.",
    "Preguntando se llega a Roma.",
    "Zapatero a sus zapatos.",
    "Una golondrina no hace verano.",
    "Obras son amores y no buenas razones.",
    "Mucho ruido y pocas nueces.",
    "En la variedad está el gusto.",
    "Tanto tienes, tanto vales.",
    "Nadie es profeta en su tierra.",
    "¿Dónde va Vicente? Donde va la gente.",
    "Dios los cría y ellos se juntan.",
    "El que espera desespera.",
    "Escoba nueva barre bien.",
    "No hay mal que dure cien años.",
    "Guerra avisada no mata soldados.",
    "La fe mueve montañas.",
    "El que no la debe, no la teme.",
    "Perro que ladra, no muerde.",
    "Si te he visto, no me acuerdo.",
    "No hay mal que por bien no venga.",
    "Si así llueve, que no escampe.",
    "Querer es poder.",
    "Loro viejo no aprende a hablar.",
    "Más vale maña que fuerza.",
    "El papel aguanta todo.",
    "Barriga llena, corazón contento.",
    "Casa de herrero, cuchillo de palo.",
    "Poco a poco se anda lejos.",
    "Malos ojos son cariño.",
    "Lo cortés no quita lo valiente.",
    "A otro perro con ese hueso.",
    "Contigo pan y cebolla.",
    "Jaula nueva, pájaro muerto.",
    "Nunca es tarde si la dicha es buena.",
    "Sarna con gusto no pica.",
    "Quien tiene boca se equivoca",
    "El poeta nace, no se hace",
    "Haz bien y no mires a quien",
    "El que se excusa, se acusa",
    "El pez grande se come al chico",
    "Lo barato sale caro",
    "A rey muerto, rey puesto",
    "Para muestra, un botón",
    "Se dice el pecado, más no el pecador",
    "Mucho donaire, causa desaire",
    "Hoy por ti, mañana por mí",
    "No hay rosa sin espinas",
    "El que busca, encuentra",
    "Quien se pica, ajos come",
    "Gota a gota, la mar se agota",
    "Hierba mala nunca muere",
    "El tiempo es oro",
    "Ojo por ojo, diente por diente",
    "Quien canta, su mal espanta",
    "Del árbol caído, todos hacen leña",
    "El que a hierro mata, a hierro muere",
    "Piensa mal y acertarás",
    "Por la boca muere el pez",
    "Ojos que no ven, corazón que no siente",
    "La excepción hace la regla",
    "Como se vive, se muere",
    "Un clavo saca otro clavo",
    "Mañana será otro día",
    "Decir refranes, es decir verdades",
    "No hay quinto malo",
    "La intención es lo que cuenta",
    "La música amansa las fieras",
    "Más claro no canta un gallo",
    "El casado, casa quiere",
    "A mala vida, mala muerte",
    "Caras vemos, corazones no sabemos",
    "Al pan, pan, y al vino, vino",
    "Cría cuervos y te sacarán los ojos",
    "Matar pulgas a balazos",
    "Más sabe el diablo por viejo, que por diablo",
    "Agua que no has de beber, déjala correr",
    "No es oro todo lo que reluce",
    "A falta de pan, buenas son tortas",
    "A llorar al valle",
    "La cabra siempre tira al monte",
    "Vísteme despacio, que tengo prisa",
    "Unos tienen la fama y otros cardan la lana",
    "Siempre pagan justos por pecadores",
    "Primero es la obligación que la devoción",
    "Por un perro que maté, mataperros me llamaron",
    "Nunca digas de este agua no beberé",
    "No se hizo la mil para la boca del asno",
    "No vengas la piel antes de cazar al oso",
    "El que roba a un ladrón tiene cien años de perdón",
    "El que se pica ajos come",
    "Castellano fino, el pan pan y el vino vino",
    "Cada maestrillo tiene su librillo",
    "A grandes males, grandes remedios",
    "Agua que no has de beber, déjala correr",
    "A la chita callando, hay quien se va aprovechando",
    "A las diez en la cama estés y mejor antes que después",
    "Cree el ladrón que todos son de su condición",
    "Cuando el gato está ausente, los ratones se divierten",
    "Cuando el río suena, agua lleva",
    "Tropezar y no caer, adelantar camino es",
    "Hay dos palabras que te abrirán muchas puertas: tire y empuje",
    "No dejes para mañana lo que puedas hacer la semana que viene",
    "A caballo regalado... ¡gracias!",
    "Bienaventurados los borrachos, que verán a Dios dos veces",
    "Lo importante no es ganar, sino hacer perder al otro",
    "La voz del culo no tiene remedio ni disimulo",
    "Por más vueltas que das, el culo siempre te queda atrás",
    "Si el mundo te da la espalda, tócale el trasero",
    "A mal tiempo, usa tu paraguas",
    "Limpia tu moco y no harás poco",
    "Ojos que no ven, Facebook que te lo cuenta",
    "Más vale tarde porque por la mañana me duermo",
    "El que ríe el último es el que no ha entendido el chiste",
    "Cuando el río suena...se ahogó una orquesta",
    "A cena de vino, desayuno de agua",
    "Cada día que amanece, el número de tontos crece",
    "Nunca renuncies a tus sueños...duerme cinco minutos más",
    "El que esté libre de pecado no sabe lo que se pierde",
    "La excepción de la regla dura 9 meses",
    "El eco siempre tiene la última palabra",
    "El que madruga encuentra todo cerrado",
    "El que sabe, sabe; y el que no, es jefe",
    "Hay un mundo mejor, pero es carísimo",
    "Abogado, juez y doctor, cuanto más lejos, mejor",
    "No por mucho madrugar pasa ante el autobús",
    "Nadie sabe lo que tiene hasta que ordena su cuarto",
    "No bebas mientras conduces, podrías derramar la bebida",
    "No por mucho vigilar se descarga más temprano",
    "No renuncies a tu sueño, sigue durmiendo",
    "Naces libre, luego pagas impuestos hasta morir",
    "El eco siempre tiene la última palabra",
    "A la luz de la vela, no hay mujer fea",
    "Más vale prevenir que formatear",
    "La excepción de la regla dura 9 meses",
    "No está de más tenerla presente, por si las dudas",
    "A cada minuto nace un idiota",
    "A cada minuto nace un tonto",
    "Nadie sabe lo que tiene hasta que ordena su cuarto",
    "Carne y pescado en la misma comida, acorta la vida",
    "Cartas de ausentes, cédulas son de vida",
    "Celos y envidia, quitan al hombre la vida",
    "Come pan, bebe agua y vivirás larga vida",
    "Come para vivir y no vivas para comer",
    "Come poco y cena más, duerme en alto y vivirás",
    "Come y bebe que la vida es breve",
    "Como se vive, se muere",
    "Confiesa y restituye, que la vida se te huye",
    "Con orden y medida, pasarás bien la vida",
    "Con vino y vida tranquila la vejez llega de maravilla",
    "Cual la vida, tal la muerte",
    "Cuando empezaste a vivir empezaste a morir",
    "Cuando termina la vida de la escuela, comienza la escuela de la vida",
    "De esta vida sacarás lo que disfrutes nada más",
    "De la vida lo único que me queda es la porfía",
    "De oportunidades perdidas se encuentra llena la vida",
    "A mal vivir, mal morir. A mis años llegarás o la vida te costará",
    "A quien por sufrir deja la vida, vida por sufrir deja a la muerte",
    "Al enfermo que es de vida, el agua es medicina",
    "Al que le falta ventura, la vida le sobra",
    "Ama, perdona y olvida. Hoy te lo dice tu amiga. Mañana te lo dira la vida",
    "Amor con casada, vida arriesgada",
    "Anda abrigado, come poco y duerme alto si quieres vivir sano",
    "Año nuevo, vida nueva",
    "Asi sucede en la vida: cuando son los caballos que trabajaron, es el cochero el que recibe la propina",
    "Baila y bebe, que la vida es breve. Bebe poco y come asaz; duerme en alto y vivirás",
    "Beber con medida, alarga la vida",
    "Bendita la muerte cuando viene después del buen vivir",
    "Bicho malo nunca muere",
    "Bien predica quien bien vive",
    "Buen vino y sopas hervidas, le alargan al viejo la vida",
    "Buena es la vida de aldea por un rato, mas no por un año",
    "Buena vida me paso, buena hambre me rasco",
    "A juventud ociosa, vejez trabajosa",
    "Al que madruga Dios le ayuda",
    "Al trabajo por su vejez, no le engañan ni una vez",
    "A mocedad ociosa, vejez trabajosa",
    "Aquel es tu hermano que te quita el trabajo",
    "A quien trabaja, el día nunca le parece largo",
    "Aunque no sea más que por el mísero afán de descansar, debemos trabajar",
    "Aunque sólo fuese por el gusto de descansar, todos los hombres deberían trabajar",
    "Bien cena, quien bien trabaja",
    "Bien cena, quien bien trabaja",
    "Como el comer es diariamente es necesario, trabajar",
    "Criada trabajadora, hace perezosa a su señora",
    "De Dios para abajo, cada cual vive de su trabajo",
    "De tejas para abajo, todo el mundo vive de su trabajo",
    "Después del trabajo viene la alegría",
    "Dudoso es heredar y seguro trabajar",
    "Echar por el atajo no siempre ahorra trabajo",
    "El brazo a trabajar, la cabeza a gobernar",
    "El buen cirujano opera temprano",
    "El hombre a trabajar y la mujer a gastar",
    "El propósito de trabajar, es llegar a descansar",
    "El que algo quiere, algo le cuesta",
    "El que de joven no trabaja, de viejo duerme en la paja",
    "El que de mañana se levanta en su trabajo adelanta",
    "Como el gazapo, que huyendo del perro dio en el lazo",
    "A perro flaco todo son pulgas",
    "Por interés ladra el perro",
    "Castigar al perro cuando tiene el rabo tieso",
    "El perro viejo, si ladra, da consejo",
    "A cada cerdo le llega su San Martín",
    "No echéis margaritas a los cerdos",
    "A quien no mata puerco, no le dan morcilla: el beneficio llega a quien se esfuerza",
    "Al más ruin puerco, la mejor bellota",
    "En tierra ajena, la vaca al buey acornea",
    "Más valen dos bocados de vaca que siete de patata",
    "Por eso se vende la vaca; porque uno come la pierna, y otro la falda",
    "Quien come la vaca del rey, a cien años paga los huesos",
    "Hasta el rabo, todo es toro",
    "Los toros se ven mejor desde la barrera",
    "Cada oveja con su pareja",
    "A caballero nuevo, jinete viejo",
    "A caballo regalado, no le mires el diente",
    "Al amigo y al caballo, no cansallo",
    "Caballo grande, ande o no ande",
    "Caballo que vuela, no quiere espuela",
    "De potro sarnoso, caballo hermoso",
    "El ojo del amo engorda el caballo",
    "El que solo come su gallo, solo ensilla su caballo",
    "No hay caballo, por bueno que sea, que no tropiece",
    "Hasta el 40 de mayo no visites al yayo",
    "En abril, contagios mil",
    "Aunque la mona se vista de seda, en casa se queda",
    "Allá donde fueres, multa te lleves",
    "Nadie sabe lo que tiene hasta que se lo detectan",
    "No es mas rico el que más tiene, sí el que menos papel higiénico necesita",
    "La primavera, la fiebre altera",
    "Dios los cría y ellos se contagian",
    "Amor mal correspondido, ausencia y olvido",
    "Amor y fortuna, resistencia ninguna",
    "A batallas de campo de plumas",
    "A la mujer, ni todo el amor, ni todo el dinero",
    "A la mujer, ni todo el dinero ni todo el querer",
    "A mucho amor, mucho perdón",
    "Adonde el corazón se inclina, el pie camina",
    "Afortunado en el juego, desgraciado en el amor",
    "Al buen amar, nunca le falta qué dar",
    "Al bueno por amor y al malo por temor",
    "Al mal amor, puñaladas",
    "A los quince el que quise, a los veinte el que quiso mi gente y a los treinta el que se presenta",
    "Ama al grado que quieras ser amado",
    "Ama a quien no te ama; responde a quien no te llama; andarás carrera vana",
    "Ama y guarda",
    "Ama y te amarán, odia y te odiarán",
    "Amar sin ser correspondido es tiempo perdido",
    "Amar no es solamente querer, es sobre todo comprender",
    "Amar sin padecer, no puede ser",
    "Amar y no ser amado es tiempo mal empleado",
    "Amar y saber, todo no puede ser",
    "Amor, amor, malo el principio y el fin peor",
    "Amor con amor se cura",
    "Amor con hambre, no dura",
    "Amor con amor se paga y lo demás, con dinero",
    "Amor con casada, solo de pasada",
    "Amor con casada, vida arriesgada",
    "Amor con celos causa desvelos",
    "Amor de madre, que todo lo demás es aire",
    "Amor de madre, es incomparable",
    "Amor de niño, agua en cestillo",
    "Amor es demencia, y su médico, la ausencia",
    "Amor grande, vence mil dificultades",
    "Amor loco, yo por vos, y vos por otro",
    "Amor no correspondido, tiempo perdido",
    "Amor nuevo, olvida el primero",
    "Amor osado, nunca fue desdichado",
    "Amor por cartas son promesas falsas",
    "Amor por interés, se acaba en un dos por tres",
    "Amor que como entra sale, nada vale",
    "Amor que del alma nace, al pie de la tumba muere",
    "Atardecer ‘colorao’, viento ‘asegurao’",
    "El ignorante afirma, el sabio duda y reflexiona",
    "Si quieres sardina y mujer fina, santanderina",
    "El melón y el casamiento, ha de ser con tiento",
    "Quien compra lo que no puede, vende lo que le duele",
    "Día de agua, taberna o fragua",
    "Dos caminos tiene el dinero",
    "El necio es atrevido y el sabio, comedido",
    "Hasta la Virgen de Begoña, quitarse el refajo ni de coña",
    "Si en noviembre oyes que truena, la cosecha siguiente será buena",
    "Abre las ventanas al cierzo y al oriente y ciérralas al mediodía y poniente",
    "Abril, aguas mil, cernidas por un mandil",
    "Agosto, frío al rostro",
    "Agua de San Juan, quita vino y no da pan",
    "A la noche arreboles; a la mañana habrá soles",
    "Al invierno lluvioso, verano abundoso",
    "Año de nieves, año de bienes",
    "Arco al poniente, deja el arado y vente",
    "Arreboles al oriente, agua amaneciente",
    "Arreboles de la tarde, a la mañana aire",
    "Aurora rubia, o viento o lluvia",
    "Barba roja, mucho viento porta",
    "Buena es la nieve que en su tiempo viene",
    "Cielo aguado, hierba en prado",
    "Cielo empedrado, suelo mojado",
    "Cuando amanece, para todo el mundo amanece",
    "Cuando con solano llueve, todas las piedras mueve",
    "Cuando marzo mayea, mayo marcea",
    "Cuando no llueve en febrero, no hay buen prado ni buen centeno",
    "El día de San Bernabé, dijo el sol: aquí estaré",
    "Día de Santa Lucía, mengua la noche y crece el día",
    "Boca española no se abre sola.",
    "Cada gallo canta en su gallinero y el español en el suyo y en el mundo entero.",
    "Cuando el español canta, o rabia o no tiene blanca.",
    "De España, ni viento ni casamiento.",
    "Desde Cádiz a Torino, en Italia la pasta y en España el vino.",
    "El español da tiza después que pifia.",
    "El español fino, con todo bebe vino.",
    "El español valiente después de comer, frío siente.",
    "En España pasa por tonto el que no apaña.",
    "En España, el que apaña, apaña.",
    "En España, amigos de hoy, enemigos de mañana.",
    "En todos los pueblos de España hay más badajos que campanas.",
    "España mi natura, Italia mi ventura.",
    "Fraile de España y monja de Italia.",
    "Gánalo en España, gástalo en Italia, y vivirás vida larga y descansada.",
    "La coz de la yegua, no hace mal al potro.",
    "La ropa sucia, en casa se lava.",
    "Todos de un vientre y cada uno de su miente.",
    "Hijo de ruin padre, apellido de su madre.",
    "Hijo eres y padre serás; cual hicieres tal habrás.",
    "A padre guardador, hijo gastador.",
    "Al escarabajo sus hijos le parecen granos de oro fino.",
    "Al gato goloso y a la moza ventanera, tapallos la gatera.",
    "Al hijo de tu vecina, quítale el moco y cásale con tu hija.",
    "Al hijo querido, el mayor regalo es el castigo.",
    "Al hombre venturero, la hija le nace primero.",
    "Al niño, mientras crece, y al enfermo, mientras adolece.",
    "Al niño y al mulo, en el culo.",
    "De casta le viene al galgo el ser rabilargo.",
    "De tal palo, tal astilla.",
    "Dijo el escarabajo a sus hijos: Venid acá, mis flores.",
    "El diablo a los suyos quiere.",
    "El que a los suyos se parece, honra merece.",
    "Entre padres y hermanos, no metas tus manos.",
    "Hijo sin dolor, madre sin amor.",
    "La buena madre no dice quieres.",
    "La hija de la cabra qué ha de ser sino cabrita.",
    "La hija y la heredad, para la ancianidad.",
    "La riña de hermanos es agua de manos.",
    "Los dedos de la mano no son iguales.",
    "Mi hija venturosa y la tuya hermosa.",
    "Mi hijo vendrá barbado, mas no parido ni preñado.",
    "Si el hijo sale al padre, de duda saca a la madre.",
    "Todos de un vientre y cada uno de su miente. Se dice de los hermanos desiguales.",
    "A rico no debas, y a pobre no prometas.",
    "Al pobre no es provechoso acompañarse con el poderoso.",
    "Al puerco gordo, untarle el rabo.",
    "Asno con oro, alcánzalo todo.",
    "Bien, ¿adónde vas? A donde tienen más.",
    "Blanca a blanca, hizo la vieja, de oro una teja. Encarece el ahorro.",
    "Dádivas y buenas razones, ablandan piedras y corazones.",
    "Dinero gana dinero.",
    "El dinero es caballero.",
    "Hombre pobre, con poco se alegra y socorre.",
    "La pobreza hace al hombre estar en tristeza.",
    "La pobreza no es vileza, más deslustra la nobleza.",
    "La riqueza, vecina es de la soberbia.",
    "Lo que abunda no daña.",
    "Más ablanda el dinero que palabras de caballero.",
    "Más vale algo que nada.",
    "Más vale din de moneda que don sin renta.",
    "Más vale poco y bueno que mucho y malo.",
    "Mejor es ser envidiado que apiadado.",
    "Nada tiene el que nada le basta.",
    "Ningún perro lamiendo engorda.",
    "No crece el río con agua limpia.",
    "No hay virtud y nobleza que no abata la pobreza.",
    "Pobreza nunca alza cabeza.",
    "Poderoso caballero es don dinero.",
    "Quien dice que la pobreza no es vileza, no tiene seso en la cabeza.",
    "Quien tiene din, tiene don.",
    "Tanto tienes, tanto vales.",
    "Al andaluz, muéstrale la cruz; al extremeño, el leño.",
    "Andaluz fulero, ni mentarlo quiero.",
    "Caballeros de la Andalucía, mueren ricos y viven pobre vida.",
    "Catalán con bota, gallego con dinero y andaluz con mando ¡ya estoy temblando!",
    "Del andaluz guarda tu capuz. Frailes de Castilla y monjas de Andalucía.",
    "Fuera de la Corte, gente del norte, que la de Andalucía para tu tía.",
    "Gente de Andalucía ¿quién la fía? Tanero.",
    "Los perezosos andaluces no hacen obras sino chapuces.",
    "A fuer de Aragón, a buen servicio, mal galardón.",
    "Aire de Monzón, agua en Aragón.",
    "Aragonés tozudo, mete el clavo en la peña, y dale con el puño.",
    "Aragonés vuelve la puerta como la ves.",
    "Aragonés, falso y cortés.",
    "Aragonés, por excusar deja de gastar.",
    "Aragoneses y navarros, en cuanto a tercos, primos hermanos.",
    "Aragoneses, navarros y riojanos, en lo bruto son primos hermanos.",
    "Cuando mea un aragonés, mean dos o tres.",
    "De Aragón, ni buen viento ni buen varón.",
    "De Aragón, ni buen vino ni buen varón.",
    "Ebro traidor; naces en Castilla y riegas Aragón.",
    "El aragonés fino después de comer tiene frío.",
    "El cierzo y la contribución tienen perdido a Aragón.",
    "¡Caray con los castellanos, que al frío le llaman fresco!",
    "Aire castellano, malo en invierno y peor en verano.",
    "Ancha es Castilla.",
    "Carnero castellano, vaca gallega, arroz valenciano.",
    "Castellano fino, el pan, pan y el vino, vino.",
    "De Castilla el trigo, pero no el amigo.",
    "Ebro traidor que naces en Castilla y riegas Aragón.",
    "En Castilla, el caballo lleva la silla.",
    "En Castilla, el caballo lleva la silla; y en Portugal, el caballo la ha de llevar.",
    "Frailes de Castilla y monjas de Andalucía. Gente castellana, gente sana.",
    "Asturiano loco y vano, poco fiel y mal cristiano.",
    "Asturias es España y lo demás, tierra conquistada.",
    "Asturias, montes verdes, negros valles de minerales.",
    "El asturiano es loco y vano, poco fiel y mal cristiano.",
    "Gallegos y asturianos, primos hermanos.",
    "Hombre asturiano, vino puro, y lanza en la mano.",
    "La mujer como la manzana, asturiana.",
    "Los enemigos del alma son tres: gallego, asturiano y montañés.",
    "Al montañés, ni le fíes ni le des.",
    "Al montañesuco, con un trabuco.",
    "Con gente de la Montaña, no basta maña.",
    "De Burgos al mar, todo es necedad.",
    "El montañés y el los más tunos de la nación.",
    "El montañés, por defender una necedad dice tres.",
    "Gente de la Montaña, al mismo diablo engaña.",
    "Alcalá me da voces, Madrid me llama, Guadalajara me dice que no me vaya.",
    "A quien Dios quiso bien, en Madrid le dio de comer.",
    "Aquí y en Madrid, desnudan a un santo para otro vestir.",
    "A Sevilla me he de ir a buscar un sevillano, que los mozos de Madrid mucha paja y poco grano.",
    "Cuando salí de Madrid hasta las piedras lloraban, porque me dejaba allí lo que yo más adoraba.",
    "De Madrid a Getafe ponen dos leguas, una ya llevo andada y otra me queda.",
    "De Madrid al cielo, y un agujerito para verlo.",
    "De Madrid, los extremos, de Valladolid, los medios.",
    "El aire de Madrid es tan sutil que mata a un buey y no apaga un candil.",
    "En Humanes no te pares, en Fuenlabrada, poco o nada, en Leganés un mes, y en Madrid, entrar y salir.",
    "En Madrid, como en Linares, veinte mulas son diez pares.",
    "En Madrid como en Sevilla, quien pilla, pilla.",
    "De una puta y un gitano, nació el primer murciano.",
    "Octubre de llucias, Murcia cubre.",
    "A Navarra volveré por el canto de la jota, por el juego de la pelota; a Navarra volveré, volveré.",
    "Carnero castellano, vaca gallega, arroz valenciano.",
    "De levante, el más bobo es un tunante.",
    "De gente de levante, no fiarse.",
    "De levante, ni aire.",
    "De Valencia son las flores, de Sevilla los toreros, y de Hellín las chicas guapas y los ricos caramelos.",
    "Dios te guarde de moza navarra, de viuda aragonesa, de monja catalana y de casada valenciana.",
    "En Valencia, medicina; en Salamanca, eruditos; teólogos, Alcalá; y en Valladolid, jurisperitos.",
    "Gente de levante ¡fuera al instante!",
    "Gente levantina, traidora y fina.",
    "La espada valenciana, el broquel barcelonés, la puta toleda cordobés.",
    "Los arrozales valencianos alimentan a muchos humanos."
  ];

  int indiceRefranActual = 0;
  String refranOculto = "";
  List<bool> letrasAdivinadas = [];
  int intentosRestantes = 3;
  Set<String> letrasCorrectas = {};
  Set<String> letrasIncorrectas = {};
  bool juegoTerminado = false;
  bool isKeyboardVisible = false;
  int vidas = 1;
  bool pierdeVida = false;
  bool hasPerdidoTodasLasVidas = false;
  bool mostrandoAnuncio = false;
  List<GlobalKey<FlipCardState>> cardKeys = [];
  int refranesCompletados = 0;
  bool mostrarAnuncio = true; // Agrega esta línea junto con otras variables
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
  final int horaDeReinicio = 0; // 0 representa la medianoche (12:00 AM)
  bool refranDiarioCompletado =
      false; // Variable para rastrear el refrán diario completado

  DateTime?
      lastPlayedTime; // Variable para almacenar la última vez que se jugó.
  bool canPlayRefran =
      true; // Variable para verificar si se puede jugar un refrán.

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _loadRefranActualIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      indiceRefranActual = prefs.getInt('indiceRefranActual') ?? 0;
    });
  }

  Future<void> _loadLastCompletionDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastCompletionDateMillis = prefs.getInt('last_completion_date') ?? 0;
    if (lastCompletionDateMillis == 0) {
      return;
    }

    final lastCompletionDate =
        DateTime.fromMillisecondsSinceEpoch(lastCompletionDateMillis);

    // Verifica si ha pasado al menos un día desde la última completación
    final currentTime = DateTime.now();
    final difference = currentTime.difference(lastCompletionDate);
    if (difference.inHours < 24) {
      // Aún no ha pasado suficiente tiempo, no se permite jugar de nuevo.
      setState(() {
        canPlayRefran = false;
      });
    }
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload == 'daily_notification') {
      // La notificación diaria ha sido seleccionada
      // Aquí puedes mostrar un mensaje o realizar alguna acción
      // Por ejemplo, puedes mostrar un diálogo con un mensaje
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Refrán Diario'),
            content: const Text('Es hora de hacer el refrán diario.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _scheduleDailyNotification() async {
    const time = Time(8, 0,
        0); // Hora en la que deseas mostrar la notificación (por ejemplo, 8:00 AM)

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Refranero Diario',
      'Notificación diaria del Refranero',
      importance: Importance.defaultImportance,
    );
    const iOSPlatformChannelSpecifics = IOSNotificationDetails();

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Configura la zona horaria para la notificación diaria
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // ID de la notificación (debe ser único)
      'Preparado para hacer el refrán diario?',
      '👀', // Emoticono de dos ojos
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload:
          'daily_notification', // Carga un identificador único para la notificación
    );
  }

  Widget buildFlipCard(int index) {
    final character = refranOculto[index];
    final isSpace = character == ' ';

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

  void asignarRefranParaDiaActual() {
    final DateTime now = DateTime.now();
    final DateTime firstDayOfYear = DateTime(now.year, 1, 1);
    final Duration difference = now.difference(firstDayOfYear);

    // Calculate the day of the year by adding 1 to the difference
    final int dayOfYear = difference.inDays + 1;

    // Calculate the index of the refran for the current day
    indiceRefranActual = dayOfYear - 1;

    // Check if it's necessary to wrap around to the next year
    if (indiceRefranActual >= refranes.length) {
      // Wrap around to the next year
      indiceRefranActual %= refranes.length;
    }

    // Verifica si el refrán diario ya se ha completado para el día actual
    if (!refranDiarioCompletado) {
      // Display the refran for the current day
      print("Refrán del día: ${refranes[indiceRefranActual]}");
      // Marca el refrán diario como completado para evitar cambios repetidos en el mismo día
      refranDiarioCompletado = true;
    }
  }

  @override
  void initState() {
    super.initState();
    asignarRefranParaDiaActual();
    // Inicializa la zona horaria
    tz.initializeTimeZones();
    // Llama a la función para cargar el índice del refrán actual
    _loadRefranActualIndex();
    // Obtiene la última vez que se jugó desde SharedPreferences.
    _loadLastCompletionDate(); // Carga la fecha de la última completación.
    getLastPlayedTime().then((time) {
      setState(() {
        lastPlayedTime = time;
        // Verifica si ya pasaron 24 horas desde la última vez que se jugó.
        if (lastPlayedTime != null) {
          final currentTime = DateTime.now();
          final difference = currentTime.difference(lastPlayedTime!);
          if (difference.inHours < 24) {
            canPlayRefran = false;
          }
        }
      });
    });

    KeyboardVisibilityController().onChange.listen((bool isVisible) {
      setState(() {
        isKeyboardVisible = isVisible;
      });
    });

    // Establece el refrán inicial que deseas mostrar
    cambiarRefran(
        0); // Cambia 0 por el índice del refrán que desees mostrar inicialmente

    // Configura las notificaciones y programa la notificación diaria
    const settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) =>
          onSelectNotification(payload),
    );
    final initializationSettings =
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Programa la notificación diaria a una hora específica, por ejemplo, a las 8:00 AM.
    _scheduleDailyNotification();
  }

  Future<DateTime?> getLastPlayedTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastPlayedTimeMillis = prefs.getInt('last_played_time') ?? 0;
    if (lastPlayedTimeMillis == 0) {
      return null;
    }

    // Obtén la fecha y hora actual
    final currentTime = DateTime.now();
    // Convierte la marca de tiempo almacenada en una fecha y hora
    final lastPlayedTime =
        DateTime.fromMillisecondsSinceEpoch(lastPlayedTimeMillis);

    // Ajusta la hora de la última vez que se jugó a la medianoche
    final adjustedLastPlayedTime = DateTime(
      lastPlayedTime.year,
      lastPlayedTime.month,
      lastPlayedTime.day,
      horaDeReinicio, // Establece la hora de reinicio a las 12:00 AM
      0, // Minutos
      0, // Segundos
      0, // Milisegundos
      0, // Microsegundos
    );

    // Si la hora actual es anterior a la hora de reinicio, ajusta la fecha un día atrás
    if (currentTime.isBefore(adjustedLastPlayedTime)) {
      adjustedLastPlayedTime.subtract(const Duration(days: 1));
    }

    return adjustedLastPlayedTime;
  }

  Future<void> _setLastCompletionDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now();
    prefs.setInt('last_completion_date', currentTime.millisecondsSinceEpoch);
  }

  Future<void> setLastPlayedTime(DateTime time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('last_played_time', time.millisecondsSinceEpoch);
  }

  String calcularTiempoRestante() {
    if (lastPlayedTime != null) {
      final currentTime = DateTime.now();
      final nextPlayTime = lastPlayedTime!.add(const Duration(days: 1));
      final timeDifference = nextPlayTime.difference(currentTime);

      if (timeDifference.isNegative) {
        canPlayRefran = true; // Habilita jugar un nuevo refrán
        return "Puedes jugar otro refrán ahora";
      } else {
        final hours = timeDifference.inHours;
        final minutes = timeDifference.inMinutes % 60;
        final formattedTime =
            DateFormat.Hm().format(nextPlayTime); // Formatea la hora

        return "Próximo refrán disponible a las $formattedTime ($hours horas y $minutes minutos)";
      }
    } else {
      canPlayRefran = true; // Si no hay un tiempo almacenado, permite jugar
      return "Puedes jugar un refrán ahora";
    }
  }

  void cambiarRefranDiario() {
    final currentTime = DateTime.now();
    if (currentTime.hour == 0 && currentTime.minute == 0) {
      // Es medianoche, cambia el refrán diario.
      int nuevoIndice;
      do {
        nuevoIndice = Random().nextInt(refranes.length);
      } while (nuevoIndice == indiceRefranActual);

      cambiarRefran(nuevoIndice);
    }
  }

  void _mostrarTiempoRestanteDialog(BuildContext context, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tiempo Restante'),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void mostrarTiempoRestante(BuildContext context) {
    if (lastPlayedTime != null) {
      final currentTime = DateTime.now();
      final nextPlayTime = lastPlayedTime!.add(const Duration(days: 1));
      final timeDifference = nextPlayTime.difference(currentTime);

      if (timeDifference.isNegative) {
        canPlayRefran = true; // Habilita jugar un nuevo refrán
        _mostrarTiempoRestanteDialog(context, "Puedes jugar otro refrán ahora");
      } else {
        final hours = timeDifference.inHours;
        final minutes = timeDifference.inMinutes % 60;
        final formattedTime =
            DateFormat.Hm().format(nextPlayTime); // Formatea la hora

        String mensaje =
            "Próximo refrán disponible a las $formattedTime ($hours horas y $minutes minutos)";

        // Muestra un showDialog con el mensaje de tiempo restante
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Tiempo Restante'),
              content: Text(mensaje),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el diálogo
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      }
    } else {
      canPlayRefran = true; // Si no hay un tiempo almacenado, permite jugar
      _mostrarTiempoRestanteDialog(context, "Puedes jugar otro refrán ahora");
    }
  }

  String normalizarLetra(String letra) {
    return letra
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');
  }

  void _mostrarMensaje(BuildContext context, String mensaje,
      {bool mostrarBotonSiguiente = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(juegoTerminado ? "Juego Terminado" : "Mensaje"),
          content: Text(mensaje),
          actions: <Widget>[
            if (juegoTerminado && mostrarBotonSiguiente)
              TextButton(
                onPressed: () {
                  if (indiceRefranActual < refranes.length - 1) {
                    cambiarRefran(indiceRefranActual + 1);
                  } else {
                    _mostrarMensaje(
                        context, "¡Has completado todos los refranes!");
                  }
                },
                child: const Text('Siguiente Refrán'),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
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
                mostrarMensajeFelicitacion(); // Llama a la función de felicitación
                refranesCompletados++;
              });
            });
          }
        } else if (!letrasIncorrectas.contains(letra)) {
          letrasIncorrectas.add(letra);
          intentosRestantes--;

          if (intentosRestantes == 0) {
            if (vidas > 0) {
              pierdeVida = true;
              vidas--;
              _mostrarMensaje(
                context,
                "Consumiste un corazón, te quedan $vidas de 3 ",
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

  void mostrarMensajeFelicitacion() {
    final mensajeFelicitacion =
        "¡Enhorabuena! ¡Has completado el refrán diario!\n\n${calcularTiempoRestante()}";

    _mostrarMensaje(
      context,
      mensajeFelicitacion,
      mostrarBotonSiguiente: true,
    );

    // Establece la fecha de la última completación del refrán diario
    _setLastCompletionDate();
    // Actualiza la variable canPlayRefran a false
    setState(() {
      canPlayRefran = false;
    });

    // Establece refranDiarioCompletado en true cuando se completa el refrán diario
    refranDiarioCompletado = true;
  }

  void cambiarRefran(int indice) {
    setState(() {
      if (!canPlayRefran) {
        _mostrarMensaje(
          context,
          "Debes esperar hasta mañana para jugar otro refrán.",
        );
        return;
      }

      final currentTime = DateTime.now();

      if (lastPlayedTime == null ||
          currentTime.difference(lastPlayedTime!) >= const Duration(hours: 24)) {
        indiceRefranActual = indice;
        refranOculto = refranes[indiceRefranActual];
        letrasAdivinadas = List.generate(
          refranOculto.length,
          (index) {
            final character = refranOculto[index];
            if (character == ',' ||
                character == '.' ||
                character == ';' ||
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

        setLastPlayedTime(currentTime);
        canPlayRefran = false;
        _setLastCompletionDate(); // Establece la fecha de completación del refrán diario.
      }
    });

    cardKeys = List.generate(
      refranOculto.length,
      (index) => GlobalKey<FlipCardState>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 68, 42, 7), // Fondo transparente de AppBar
        elevation: 0, // Sin sombra
        title: const Text(
          'Carrera de refraneros',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          Row(
            children: [
              for (int i = 0; i < vidas; i++)
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              for (int i = 0; i < 1 - vidas; i++)
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
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (!isLetterGuessed &&
                            letrasAdivinadas.contains(false)) {
                          comprobarLetra(letra);
                        }
                      },
                      child: AutoSizeText(
                        letra,
                        style: TextStyle(fontSize: 18, color: textColor),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
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
            ],
          ),
        ),
      ),
    );
  }
}

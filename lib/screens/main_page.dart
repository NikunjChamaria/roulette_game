import 'dart:async';
import 'dart:developer';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:just_audio/just_audio.dart';
import 'package:roulette_game/screens/history.dart';
import 'package:roulette_game/utils/textstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  StreamController<int> selected = StreamController<int>();
  StreamController<int> selected1 = StreamController<int>();
  bool isPressed = false;
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer audioPlayer1 = AudioPlayer();

  late ConfettiController _controllerCenter;

  @override
  void initState() {
    //playintromusin();
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  void playintromusin() async {
    await audioPlayer.setAsset("assets/intro.mp3");
    audioPlayer.seek(const Duration(seconds: 12));
    audioPlayer.play();
  }

  void _handleIndicatorTap() {
    setState(() {
      isPressed = true;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        isPressed = false;
      });
    });
  }

  Path drawConfetti(Size size) {
    final path = Path();
    final halfWidth = size.width / 2;
    final rectWidth = size.width / 2.5;
    final rectHeight = size.width / 10;

    // Move to the top-left corner of the rectangle
    path.moveTo(halfWidth - rectWidth / 2, 0);

    // Draw the rectangle
    path.lineTo(halfWidth + rectWidth / 2, 0);
    path.lineTo(halfWidth + rectWidth / 2, rectHeight);
    path.lineTo(halfWidth - rectWidth / 2, rectHeight);

    // Close the path to form a rectangle
    path.close();

    return path;
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = <String>[
      'Short walk would be a nice on this Sunny day',
      'Call a friend, maybe its time to check on them',
      '10-minute reading of any book you like',
      'Write a gratitude journal',
      'Do 15 push-ups, I know you are not going to the gym',
      'Listen to a favorite song and dive into the melody',
      '5-minute meditation is what you need',
      'Drink a glass of water, its good to take care of yourself',
      'Relax and take a deep breath, you are doing amazing',
      'Compliment someone around the room',
    ];
    final items2 = <String>[
      'Short walk',
      'Call a friend',
      'Reading Time',
      'Thank you Journal',
      'Exercise!!',
      'Feel the Music',
      'Meditate!!',
      'Drink Water',
      'Relax!!',
      'Compliment',
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00796B),
              Color(0xFF004D40)
            ], // Adjust color codes as needed
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo.png",
                    height: 80,
                    width: 80,
                  ),
                  Column(
                    children: [
                      Text(
                        "PocketRoulette",
                        style: lobster(Colors.white, 32, FontWeight.w900),
                      )
                    ],
                  )
                ],
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 73, 49, 40),
                          radius: 200,
                          backgroundImage: const AssetImage(
                            "assets/wooden.png",
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              selected1 = StreamController<int>();
                              audioPlayer.stop();
                              audioPlayer.setAsset("assets/spinning.mp3");
                              audioPlayer.play();
                              int i = -1;

                              setState(() {
                                i = Fortune.randomInt(0, items.length);
                                selected.add(i);
                                selected1.add(i);
                              });
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              List<String> data =
                                  sharedPreferences.getStringList("data") ?? [];
                              data.add(items2[i]);
                              log(data.length.toString());
                              sharedPreferences.setStringList("data", data);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: FortuneWheel(
                                duration: const Duration(milliseconds: 9500),
                                styleStrategy: const AlternatingStyleStrategy(),
                                animateFirst: false,
                                indicators: [
                                  FortuneIndicator(
                                    alignment: Alignment
                                        .center, // <-- changing the position of the indicator
                                    child: MyWheelIndicator(
                                      onTap: () {
                                        _handleIndicatorTap();
                                      },
                                      isPressed: isPressed,
                                    ),
                                  )
                                ],
                                rotationCount: 40,
                                onAnimationEnd: () {
                                  _controllerCenter.play();
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return WillPopScope(
                                        onWillPop: () async {
                                          return false;
                                        },
                                        child: AlertDialog(
                                          contentPadding: EdgeInsets.zero,
                                          content: Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: ShapeDecoration(
                                              gradient: const LinearGradient(
                                                begin: Alignment(0.00, -1.00),
                                                end: Alignment(0, 1),
                                                colors: [
                                                  Color(0xFFF0AE5E),
                                                  Color(0xFFD68522)
                                                ],
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              shadows: const [
                                                BoxShadow(
                                                  color: Color(0xFF864A00),
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                  spreadRadius: 0,
                                                )
                                              ],
                                            ),
                                            height: 250,
                                            child: Center(
                                              child: Stack(
                                                children: [
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: StreamBuilder<int>(
                                                      stream: selected1.stream,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "Your Task",
                                                                style: lobster(
                                                                    Colors
                                                                        .black,
                                                                    30,
                                                                    FontWeight
                                                                        .w900),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              Text(
                                                                items[snapshot
                                                                    .data!],
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: spacegrotesk(
                                                                    Colors
                                                                        .white,
                                                                    16,
                                                                    FontWeight
                                                                        .w700),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  _controllerCenter
                                                                      .stop();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          30),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: Colors
                                                                          .black),
                                                                  child: Text(
                                                                    "OK",
                                                                    style: lobster(
                                                                        Colors
                                                                            .white,
                                                                        20,
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        } else {
                                                          return const Text(
                                                              'No selection');
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: ConfettiWidget(
                                                      confettiController:
                                                          _controllerCenter,
                                                      blastDirectionality:
                                                          BlastDirectionality
                                                              .explosive, // don't specify a direction, blast randomly
                                                      shouldLoop:
                                                          true, // start again as soon as the animation is finished
                                                      colors: const [
                                                        Colors.green,
                                                        Colors.blue,
                                                        Colors.pink,
                                                        Colors.orange,
                                                        Colors.purple
                                                      ], // manually specify the colors to be used
                                                      createParticlePath:
                                                          drawConfetti, // define a custom shape/path.
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: ConfettiWidget(
                                                      confettiController:
                                                          _controllerCenter,
                                                      blastDirectionality:
                                                          BlastDirectionality
                                                              .explosive, // don't specify a direction, blast randomly
                                                      shouldLoop:
                                                          true, // start again as soon as the animation is finished
                                                      colors: const [
                                                        Colors.green,
                                                        Colors.blue,
                                                        Colors.pink,
                                                        Colors.orange,
                                                        Colors.purple
                                                      ], // manually specify the colors to be used
                                                      createParticlePath:
                                                          drawConfetti, // define a custom shape/path.
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                physics: CircularPanPhysics(
                                  duration: const Duration(milliseconds: 50),
                                  curve: Curves.easeInCirc,
                                ),
                                selected: selected.stream,
                                items: [
                                  for (int i = 0; i < items2.length; i++)
                                    FortuneItem(
                                        child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: i % 2 == 0
                                                  ? const Color(0xFFAE1318)
                                                  : Colors.black,
                                            ),
                                            child: Center(
                                              child: Container(
                                                height: 100,
                                                width: 50,
                                                color: i % 2 != 0
                                                    ? const Color(0xFFAE1318)
                                                    : Colors.black,
                                                child: Center(
                                                  child: RotatedBox(
                                                    quarterTurns: 1,
                                                    child: Text(
                                                      i.toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              audioPlayer1.setUrl("assets/spinning.mp3");
                              audioPlayer1.play();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HistoryPage()));
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 50),
                                decoration: ShapeDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment(0.00, -1.00),
                                    end: Alignment(0, 1),
                                    colors: [
                                      Color(0xFFF0AE5E),
                                      Color(0xFFD68522)
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0xFF864A00),
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Text(
                                  "HISTORY",
                                  style: spacegrotesk(
                                      Colors.black, 24, FontWeight.bold),
                                )),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyWheelIndicator extends StatelessWidget {
  final VoidCallback onTap;
  final bool isPressed;

  const MyWheelIndicator(
      {super.key, required this.onTap, required this.isPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isPressed ? 8.0 : 0.0),
        child: CircleAvatar(
          radius: 30.0,
          backgroundColor: const Color(0xFFF0AE5E),
          child: Text(
            "SPIN",
            style: lobster(Colors.black, 18, FontWeight.w900),
          ),
        ),
      ),
    );
  }
}

class MyInkRippleFactory extends InteractiveInkFeatureFactory {
  const MyInkRippleFactory();

  @override
  InteractiveInkFeature create(
      {required MaterialInkController controller,
      required RenderBox referenceBox,
      required Offset position,
      required Color color,
      TextDirection? textDirection,
      bool containedInkWell = false,
      rectCallback,
      BorderRadius? borderRadius,
      ShapeBorder? customBorder,
      double? radius,
      onRemoved}) {
    return InkRipple(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      textDirection: textDirection ?? TextDirection.ltr,
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      borderRadius: borderRadius,
      customBorder: customBorder,
      radius: radius,
      onRemoved: onRemoved,
    );
  }
}

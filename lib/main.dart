import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'dart:math';

// FEN EXAMPLES FOR TESTING:
// rnbqkbnr/1p1ppp1p/p3b3/8/3NPP2/2N5/PPP3PP/R1BQKB1R w KQkq - 0 6
// rnbqkb1r/pppp1ppp/4pn2/8/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 0 3
// r1bqkbnr/pppp1ppp/2n5/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4
// 2kr3r/Bp2bp2/2pp2pp/n2Np3/2B1PP2/3P1q2/PPP2P2/R4RK1 w - - 1 17
// Qn3rk1/p1p1p3/4qp1p/2pN2p1/4P1n1/1P3N2/P4PPP/R3KB1R w KQ - 1 16

// zablokowana mozliwosc przesówania pionów ręcznie
// brak zabespieczen na niepoprawne sekwencje fen
// problemy ze skalowaniem horyzontalnym

class ChessDataController extends GetxController {
  RxString fen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'
      .obs; //game start fen

  void updateFen(String newFen) {
    fen.value = newFen;
    debugPrint('C: updated fen: $fen');
  }

  RxString getFen() {
    return fen;
  }
}

void main() {
  runApp(GetMaterialApp(
    home: HomePage(),
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
  });
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChessDataController ChessDataController1 =
      Get.put(ChessDataController(), tag: '1');
  final ChessDataController ChessDataController2 =
      Get.put(ChessDataController(), tag: '2');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home page'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Obx(
                        () => ChessBoard(
                            enableUserMoves: false,
                            controller: ChessBoardController.fromFEN(
                                ChessDataController1.getFen().toString()),
                            boardColor: BoardColor.darkBrown,
                            boardOrientation: PlayerColor.white),
                      ),
                    ),
                    Obx(
                      () => Text(
                        '${ChessDataController1.fen}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await Get.to(() => Menu(
                              player: '1',
                            ));
                      },
                      child: Text('Edit your Fen'),
                    ),
                  ],
                ),
                VerticalDivider(
                  thickness: 3,
                  color: Colors.black,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Obx(
                        () => ChessBoard(
                            enableUserMoves: false,
                            controller: ChessBoardController.fromFEN(
                                ChessDataController2.getFen().toString()),
                            boardColor: BoardColor.brown,
                            boardOrientation: PlayerColor.white),
                      ),
                    ),
                    Obx(
                      () => Text(
                        '${ChessDataController2.fen}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await Get.to(() => Menu(
                              player: '2',
                            ));
                      },
                      child: Text('Edit your Fen'),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ));
  }
}

class Menu extends StatelessWidget {
  final String player;
  Menu({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final ChessDataController chessDataController =
        Get.find<ChessDataController>(tag: player);

    TextEditingController _textEditingController = TextEditingController();
    _textEditingController.text = chessDataController.getFen().toString();

    List<String> fenList = [
      'rnbqkbnr/1p1ppp1p/p3b3/8/3NPP2/2N5/PPP3PP/R1BQKB1R w KQkq - 0 6',
      'rnbqkb1r/pppp1ppp/4pn2/8/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 0 3',
      'r1bqkbnr/pppp1ppp/2n5/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
      '2kr3r/Bp2bp2/2pp2pp/n2Np3/2B1PP2/3P1q2/PPP2P2/R4RK1 w - - 1 17',
      'Qn3rk1/p1p1p3/4qp1p/2pN2p1/4P1n1/1P3N2/P4PPP/R3KB1R w KQ - 1 16',
      '3r3r/qpk1bp2/2pp2pp/2P1P3/8/8/PPP2P2/R4RK1 w - - 0 22',
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text('Edit FEN player: $player'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 600,
                    child: TextField(
                      decoration:
                          InputDecoration(labelText: 'edit fen player $player'),
                      controller: _textEditingController,
                    ),
                  ),
                  Container(
                    width: 150,
                    margin: EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () {
                          debugPrint('update');
                          chessDataController
                              .updateFen(_textEditingController.text);
                        },
                        child: Text('update')),
                  ),
                  Container(
                    width: 150,
                    margin: EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () {
                          chessDataController
                              .updateFen(fenList[Random().nextInt(5).toInt()]);
                        },
                        child: Text('Random Fen')),
                  ),
                  Text(
                      'po uzyciu random fen stan TextField bez zmiany, zmiana w kontrlolerze \n NIE NALEZY UZYWAC UPDATE'),
                  Container(
                    width: 150,
                    margin: EdgeInsets.all(10),
                    child: ElevatedButton(
                        onPressed: () {
                          // debugPrint('go back');
                          Get.back();
                        },
                        child: Text('Go back')),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

Widget test() {
  return const Column(
    children: [
      Text("test", style: TextStyle(color: Colors.red)),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bingo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int?> bingoNumbers = List.generate(25, (index) => index + 1);
  List<bool> selected = List.generate(25, (index) => false);
  bool hasBingo = false;

  @override
  void initState() {
    super.initState();

    randomizeBingo();
    bingoNumbers[12] = null;
    selected[12] = true;
  }

  void randomizeBingo() {
    bingoNumbers = List.generate(25, (index) => index + 1)..shuffle();
    selected = List.generate(25, (index) => false);
    bingoNumbers[12] = null;
    selected[12] = true;
    setState(() => hasBingo = false);
  }

  void onBingoButtonPressed(int index) {
    setState(() {
      selected[index] = !selected[index];
      checkForBingo();
    });
  }

  void checkForBingo() {
    for (int row = 0; row < 5; row++) {
      if (selected
          .sublist(row * 5, (row * 5) + 5)
          .every((element) => element)) {
        setState(() => hasBingo = true);
        return;
      }
    }

    // Verifica colunas
    for (int col = 0; col < 5; col++) {
      if ([0, 1, 2, 3, 4]
          .map((row) => selected[row * 5 + col])
          .every((element) => element)) {
        setState(() => hasBingo = true);
        return;
      }
    }

    // Verifica diagonal (da esquerda superior para a direita inferior)
    if ([0, 6, 12, 18, 24]
        .map((index) => selected[index])
        .every((element) => element)) {
      setState(() => hasBingo = true);
      return;
    }

    // Verifica diagonal (da direita superior para a esquerda inferior)
    if ([4, 8, 12, 16, 20]
        .map((index) => selected[index])
        .every((element) => element)) {
      setState(() => hasBingo = true);
      return;
    }
  }

  Widget _body(int index) {
    return GestureDetector(
      onTap: () => onBingoButtonPressed(index),
      child: Container(
        margin: const EdgeInsets.all(4.0),
        color: selected[index] ? Colors.purple : Colors.blue,
        child: Center(
          child: Text(
            bingoNumbers[index] != null ? bingoNumbers[index].toString() : '',
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            onPressed: randomizeBingo,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasBingo)
              const Text(
                'Bingo!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemCount: 25,
                itemBuilder: (context, index) {
                  return _body(index);
                  // return test();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

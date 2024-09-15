// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/deck_screen.dart';
import 'state/flashcard_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final flashcardState = FlashcardState();
  await flashcardState.loadDecks();

  runApp(MyApp(flashcardState: flashcardState));
}

class MyApp extends StatelessWidget {
  final FlashcardState flashcardState;

  MyApp({required this.flashcardState});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DeckScreen(), // Tela inicial para mostrar os baralhos
    );
  }
}

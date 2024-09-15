// lib/screens/deck_screen.dart
import 'package:flutter/material.dart';
import '../models/deck_model.dart';
import '../state/flashcard_state.dart';
import 'flashcard_screen.dart';

class DeckScreen extends StatefulWidget {
  @override
  _DeckScreenState createState() => _DeckScreenState();
}

class _DeckScreenState extends State<DeckScreen> {
  final FlashcardState _flashcardState = FlashcardState();

  @override
  void initState() {
    super.initState();
    _loadDecks();
  }

  Future<void> _loadDecks() async {
    await _flashcardState.loadDecks();
    setState(() {});
  }

  void _addDeck() async {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar Novo Baralho'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: 'Nome do Baralho'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                _flashcardState.addDeck(name).then((_) => _loadDecks());
              }
            },
            child: Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  void _renameDeck(int index) async {
    final nameController =
        TextEditingController(text: _flashcardState.decks[index].name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Renomear Baralho'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(hintText: 'Novo Nome'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              final newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                _flashcardState
                    .renameDeck(index, newName)
                    .then((_) => _loadDecks());
              }
            },
            child: Text('Renomear'),
          ),
        ],
      ),
    );
  }

  void _deleteDeck(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir Baralho'),
        content: Text('Tem certeza que deseja excluir este baralho?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _flashcardState.deleteDeck(index).then((_) => _loadDecks());
            },
            child: Text('Excluir'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Baralhos')),
      body: ListView.builder(
        itemCount: _flashcardState.decks.length,
        itemBuilder: (context, index) {
          final deck = _flashcardState.decks[index];
          return ListTile(
            title: Text(deck.name),
            subtitle: Text('${deck.flashcardCount} Cards'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardScreen(deckIndex: index),
                ),
              );
            },
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'rename') {
                  _renameDeck(index);
                } else if (value == 'delete') {
                  _deleteDeck(index);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'rename',
                  child: Text('Renomear'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Excluir'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDeck,
        child: Icon(Icons.add),
      ),
    );
  }
}

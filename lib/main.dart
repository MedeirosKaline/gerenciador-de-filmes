import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Filmes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ListaFilmes(),
    );
  }
}

class ListaFilmes extends StatefulWidget {
  @override
  _ListaFilmesState createState() => _ListaFilmesState();
}

class _ListaFilmesState extends State<ListaFilmes> {
  final String grupo = "Kaline, M. Gabrielle, Felipe";

  List<Map<String, dynamic>> filmes = [
    {
      'id': 1,
      'titulo': 'O Senhor dos Anéis',
      'urlImagem': '',
      'pontuacao': 4.8,
    },
    {
      'id': 2,
      'titulo': 'Harry Potter',
      'urlImagem': '',
      'pontuacao': 4.5,
    },
    {
      'id': 3,
      'titulo': 'Star Wars',
      'urlImagem': '',
      'pontuacao': 4.7,
    },
    {
      'id': 4,
      'titulo': 'Matrix',
      'urlImagem': '',
      'pontuacao': 4.6,
    },
    {
      'id': 5,
      'titulo': 'Barbie',
      'urlImagem': '',
      'pontuacao': 4.9,
    },
  ];

  List<Map<String, dynamic>> filmesFiltrados = [];

  @override
  void initState() {
    super.initState();
    filmesFiltrados = List.from(filmes);
  }

  void _filtrarFilmes(String query) {
    final resultados = filmes.where((filme) {
      final tituloFilme = filme['titulo'].toLowerCase();
      final input = query.toLowerCase();
      return tituloFilme.contains(input);
    }).toList();
    setState(() {
      filmesFiltrados = resultados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, 
        title: Text(
          'Lista de Filmes',
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Nome do Grupo'),
                    content: Text(grupo),
                    actions: [
                      TextButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar filmes...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _filtrarFilmes,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filmesFiltrados.length,
              itemBuilder: (context, index) {
                final filme = filmesFiltrados[index];
                return Dismissible(
                  key: Key(filme['id'].toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      filmesFiltrados.removeAt(index);
                      filmes.removeWhere((f) => f['id'] == filme['id']);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${filme['titulo']} removido')),
                    );
                  },
                  background: Container(
                    color: const Color.fromARGB(255, 244, 54, 54),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Image.network(
                        filme['urlImagem'], 
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(filme['titulo']),
                      subtitle: RatingBar.builder(
                        initialRating: filme['pontuacao'],
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalhesFilme(filme: filme),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cadastrar filme novo')),
          );
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class DetalhesFilme extends StatelessWidget {
  final Map<String, dynamic> filme;

  DetalhesFilme({required this.filme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filme['titulo']),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              filme['urlImagem'], 
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              filme['titulo'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Pontuação: ${filme['pontuacao']}'),
          ],
        ),
      ),
    );
  }
}
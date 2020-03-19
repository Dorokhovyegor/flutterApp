import "dart:async";
import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myfirstflutterup/answer.dart';
import 'package:myfirstflutterup/question.dart';

/*void main() {
  runApp(MyApp());
}*/

void main() => runApp(MaterialApp(
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map data;
  List userData;

  Future getData() async {
    http.Response response =
        await http.get("https://reqres.in/api/users?page=1");
    data = json.decode(response.body);
    setState(() {
      userData = data["data"];
    });
    debugPrint("То, что я могу вывести " + userData.toString());
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fake friends"),
      ),
      body: ListView.builder(
        itemCount: userData == null ? 0 : userData.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.white,
            margin: EdgeInsets.only(left: 16, right: 16, top: 8),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(userData[index]["avatar"]),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          "${userData[index]["first_name"]} ${userData[index]["last_name"]}", style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 0.4,
                      ),),
                      Text(userData[index]["email"], textAlign: TextAlign.start, style: TextStyle(
                        color: Colors.black54,
                        letterSpacing: 0.2,
                        fontSize: 12
                      ),),

                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  var questionIndex = 0;

  var questions = [
    {
      "questionText": "What is your favorite colors?",
      "answers": ["Black", "Red", "Green", "White"]
    },
    {
      "questionText": "What is your favorite animal?",
      "answers": ["Rabbit", "Snake", "Elephant", "Lion"]
    },
    {
      "questionText": "What is your favorite instructor?",
      "answers": ["Yegor", "Mitch", "CodingInFlow"]
    },
  ];

  // мы что-то изменили и просим установить это состояние
  void answerQuestion() {
    setState(() {
      questionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text("Questionnaire"),
            elevation: 10,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.accessible_forward, color: Colors.white),
                onPressed: displayDialog,
              )
            ],
            bottomOpacity: 0.4,
            toolbarOpacity: 0.6,
            backgroundColor: Colors.deepPurple),
        body: questionIndex < questions.length
            ? Column(
                children: <Widget>[
                  // Это очень тупо, как можно за это платить деньги?
                  Question(questions[questionIndex]["questionText"]),
                  ...(questions[questionIndex]["answers"] as List<String>)
                      .map((answer) {
                    return Answer(answerQuestion, answer);
                  }).toList()
                ],
              )
            : Center(
                child: Question("You did it!!!"),
              ),
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          child: Text(
            "¯\\_(ツ)_/¯",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18.0, color: Colors.white, letterSpacing: 5),
          ),
          color: Colors.brown,
        ),
      ),
    );
  }

  void displayDialog() {}
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordState createState() => RandomWordState();
}

class RandomWordState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("some random changes for testing"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _saved.map((WordPair pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final List<Widget> divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text("Saved suggestions"),
        ),
        body: ListView(children: divided),
      );
    }));
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}

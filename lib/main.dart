import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        title: 'Number Trivia',
        home: Scaffold(
            appBar: AppBar(title: Text('Number Trivia'), centerTitle: true),
            body: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: TriviaWidget())));
  }
}

class TriviaWidget extends StatefulWidget {
  @override
  _TriviaWidgetState createState() => _TriviaWidgetState();
}

class _TriviaWidgetState extends State<TriviaWidget> {
  final userInputController = new TextEditingController();

  Widget textHolder = Text(
      '"Here will be the interesting fact from your search or random number"',
      style: TextStyle(fontSize: 20));

  void showTrivia([number = 'random']) {
    if (number != 'random' && int.tryParse(number) == null) {
      setState(() {
        textHolder = Text('Please write a number or use a Random Trivia button',
            style: TextStyle(fontSize: 20, color: Colors.red));
      });
    } else {
      getTrivia(number).then((trivia) {
        setState(() {
          textHolder = Text('"' + trivia + '"', style: TextStyle(fontSize: 20));
        });
      });
    }
  }

  Future<String> getTrivia(number) async {
    final response = await http
        .get(Uri.parse('http://numbersapi.com/' + number + '/trivia'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Failed to load trivia.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Start Searching!', style: TextStyle(fontSize: 20)),
        SizedBox(height: 40),
        textHolder,
        SizedBox(height: 45),
        TextField(
          controller: userInputController,
          decoration: InputDecoration(
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        SizedBox(height: 40),
        Row(children: [
          Expanded(
              child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Text('Search', style: TextStyle(fontSize: 20))),
            onPressed: () {
              if (userInputController.text != '')
                showTrivia(userInputController.text);
            },
          )),
          SizedBox(width: 10),
          Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.grey[600]),
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Get Random Trivia',
                          style: TextStyle(fontSize: 20))),
                  onPressed: () {
                    showTrivia();
                  }))
        ])
      ],
    );
  }
}

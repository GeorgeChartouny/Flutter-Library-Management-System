import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lmsproject/BookModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Django-Flutter LMS'),
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
  // to make http requests
  http.Client client = http.Client();
  List<Book> books = [];
// whenever this part gets rendered, this function will be called
  @override
  void initState() {
    fetchBooks();
    super.initState();
  }

// retrieving all the books we have
  Future<List<Book>> fetchBooks() async {
    String url = "http://127.0.0.1:8000/books";

// get all books request
    final response = await http.get(Uri.parse(url));

    var responseData = json.decode(response.body);

// List to store books data
    List<Book> books = [];
    //looing over data and adding them to the list declared
    for (var singleBook in responseData) {
      Book book = Book(
          id: singleBook["id"],
          title: singleBook["title"],
          author: singleBook["author"],
          pub_year: singleBook["pub_year"],
          category: singleBook["category"],
          additional_details: singleBook["additional_details"]);
      books.add(book);
    }
    // setState(() {});
    return books;
  }

  void _addBook() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchBooks(),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (ctx, index) => ListTile(
                  title: Text(
                    snapshot.data[index].title,
                    style: const TextStyle(fontSize: 25, color: Colors.grey),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'By: ${snapshot.data[index].author}',
                        style: const TextStyle(
                            fontSize: 17, fontStyle: FontStyle.italic),
                      ),
                      Text(
                        'Publication Year: ${snapshot.data[index].pub_year}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Category: ${snapshot.data[index].category}',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      Text(
                        'Additional Details: ${snapshot.data[index].additional_details}',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  contentPadding: const EdgeInsets.only(bottom: 20.0),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBook,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'dart:convert';
import 'dart:html';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lmsproject/BookModel.dart';
import 'package:lmsproject/addBook.dart';
import 'package:lmsproject/updateBook.dart';

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
  // variable gets set when the user types in the search bar, otherwise empty string
  String searchWord = '';

  // filtered list books by searchWord
  List<Book> filteredBooks = [];

  // list of all books
  List<Book> books = [];

// whenever this part gets rendered, this function will be called
  @override
  void initState() {
    fetchBooks();
    super.initState();
  }

  String url = "http://127.0.0.1:8000";
// retrieving all the books we have
  Future<List<Book>> fetchBooks() async {
// get all books request
    final response = await http.get(Uri.parse("$url/books"));

    var responseData = json.decode(response.body);

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
    // return books;
    setState(() {
      filteredBooks = books;
    });
    return filteredBooks;
  }

  // delete function tha calls the delete http request with the appropriate id
  void deleteBook(int id) {
    http.delete(Uri.parse("$url/book/$id/delete"));
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyApp()));
  }
// Rest of the code...

  @override
  Widget build(BuildContext context) {
    filteredBooks = searchWord.isEmpty
        ? books
        : books.where((book) {
            final lowerCaseSearchWord = searchWord.toLowerCase();
            return book.title!.toLowerCase().contains(lowerCaseSearchWord) ||
                book.author!.toLowerCase().contains(lowerCaseSearchWord) ||
                book.category!.toLowerCase().contains(lowerCaseSearchWord) ||
                book.pub_year!.contains(searchWord) ||
                jsonEncode(book.additional_details)
                    .toLowerCase()
                    .contains(lowerCaseSearchWord);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchWord = value;
                  });
                },
                decoration: const InputDecoration(
                  label: Text('Search'),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: filteredBooks.isEmpty
                  ? const Center(child: Text('No books found'))
                  : ListView.builder(
                      itemCount: filteredBooks.length,
                      itemBuilder: (ctx, index) => ListTile(
                        title: Text(
                          filteredBooks[index].title!.toUpperCase(),
                          style:
                              const TextStyle(fontSize: 25, color: Colors.grey),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UpdateBookPage(
                                title: filteredBooks[index].title!,
                                author: filteredBooks[index].author!,
                                category: filteredBooks[index].category!,
                                pub_year: filteredBooks[index].pub_year!,
                                additional_details:
                                    filteredBooks[index].additional_details,
                                id: filteredBooks[index].id!,
                              ),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteBook(filteredBooks[index].id!),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'By: ${filteredBooks[index].author}',
                              style: const TextStyle(
                                  fontSize: 17, fontStyle: FontStyle.italic),
                            ),
                            Text(
                              'Publication Year: ${filteredBooks[index].pub_year}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Category: ${filteredBooks[index].category}',
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                            // display this field only when additional_details has data
                            if (filteredBooks[index].additional_details != null)
                              Text(
                                'Additional Details: ${filteredBooks[index].additional_details}',
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic),
                              ),
                          ],
                        ),
                        contentPadding: const EdgeInsets.only(bottom: 20.0),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddBookPage()),
        ),
        tooltip: 'AddBook',
        child: const Icon(Icons.add),
      ),
    );
  }
}

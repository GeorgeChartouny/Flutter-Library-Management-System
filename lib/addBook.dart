import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lmsproject/main.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({Key? key}) : super(key: key);

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  DateTime? pubYear;
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController additionalDetailsController =
      TextEditingController();

// addBook Function, check if required fields are not empty before calling the post api
  Future<void> addBook() async {
    if (titleController.text.isEmpty ||
        authorController.text.isEmpty ||
        pubYear == null ||
        categoryController.text.isEmpty) {
      // add error message
      return;
    }
    // foramting the pubYear to the desired format
    String formattedPubYear = DateFormat("yyyy-MM-dd").format(pubYear!);

    // map the values added into an object
    Map<String, dynamic> requestBody = {
      "title": titleController.text,
      "author": authorController.text,
      "pub_year": formattedPubYear,
      "category": categoryController.text,
      "additional_details": additionalDetailsController.text,
    };
    await http.post(Uri.parse("http://127.0.0.1:8000/book/create"),
        body: requestBody);
    //recall the fetch all books function to display the added data
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MyApp(),
      ),
    );
  }

  // show a date picker when pressing on the field of pub_year
  Future<void> selectPubYear() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: pubYear ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    // checking if pubYear is not empty, get the year,month,day
    if (selectedDate != null) {
      setState(() {
        pubYear = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add a new Book")),
      body: Column(children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(label: Text("Title *")),
        ),
        TextField(
          controller: authorController,
          decoration: const InputDecoration(label: Text("Author *")),
        ),
        TextButton(
          onPressed: () {
            print(pubYear);
            selectPubYear();
          },
          child: ListTile(
            title: Text(
              pubYear != null
                  ? "Publication Year: ${pubYear!.year}"
                  : "Select Publication Year *",
            ),
            trailing: const Icon(Icons.calendar_today),
          ),
        ),
        TextField(
          controller: categoryController,
          decoration: const InputDecoration(label: Text("Category *")),
        ),
        TextField(
          controller: additionalDetailsController,
          decoration: const InputDecoration(label: Text("More Information")),
        ),
        Container(
          margin: const EdgeInsets.only(top: 16.0),
          child: ElevatedButton(
              onPressed: () {
                print('Add Book button pressed');
                addBook();
              },
              child: const Text("Add Book")),
        ),
      ]),
    );
  }
}

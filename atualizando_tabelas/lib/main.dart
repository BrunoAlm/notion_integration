import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// imports
import 'package:notion_api/notion.dart';
import 'package:notion_api/notion/blocks/bulleted_list_item.dart';
import 'package:notion_api/notion/blocks/heading.dart';
import 'package:notion_api/notion/blocks/numbered_list_item.dart';
import 'package:notion_api/notion/blocks/paragraph.dart';
import 'package:notion_api/notion/blocks/todo.dart';
import 'package:notion_api/notion/blocks/toggle.dart';
import 'package:notion_api/notion/general/lists/children.dart';
import 'package:notion_api/notion/general/rich_text.dart' as notion_text;

import 'package:notion_api/notion/general/types/notion_types.dart';
import 'package:notion_api/notion/objects/pages.dart' as notion_page;
import 'package:notion_api/notion/objects/parent.dart';

void main() async {
  final dbId = dotenv.env['NOTION_DATABASE_ID'];
  final secret = dotenv.env['NOTION_API_KEY'];
  // final url = '$_baseUrl/databases/$dbId/query';
// Initialize the main Notion client
  final NotionClient notion = NotionClient(token: secret!);

// Create the instance of the page
  final notion_page.Page page = notion_page.Page(
    parent: Parent.database(id: dbId!),
    title: notion_text.Text('notion_api example'),
  );

// Send the instance to Notion API
  var newPage = await notion.pages.create(page);

// Get the new id generated for the created page
  String newPageId = newPage.page!.id;

// Create the instance of the content of the page
  Children fullContent = Children.withBlocks([
    Heading(text: notion_text.Text('This the title')),
    Paragraph(texts: [
      notion_text.Text(
        'Here you can write all the content of the paragraph but if you want to have another style for a single word you will have to do ',
      ),
      notion_text.Text(
        'this. ',
        annotations: notion_text.TextAnnotations(
          color: ColorsTypes.Green,
          bold: true,
          italic: true,
        ),
      ),
      notion_text.Text(
        'Then you can continue writing all your content. See that if you separate the paragraph to stylized some parts you have to take in count the spaces because the ',
      ),
      notion_text.Text('textSeparator',
          annotations: notion_text.TextAnnotations(code: true)),
      notion_text.Text(
          ' will be deprecated. Maybe you will see this with extra spaces because the separator but soon will be remove.')
    ], children: [
      Heading(
        text: notion_text.Text('This is a subtitle for the paragraph'),
        type: 2,
      ),
      Paragraph(texts: [
        notion_text.Text(
          'You can also have children for some blocks like ',
        ),
        notion_text.Text(
          'Paragraph',
          annotations: notion_text.TextAnnotations(code: true),
        ),
        notion_text.Text(', '),
        notion_text.Text(
          'ToDo',
          annotations: notion_text.TextAnnotations(code: true),
        ),
        notion_text.Text(', '),
        notion_text.Text(
          'BulletedListItems',
          annotations: notion_text.TextAnnotations(code: true),
        ),
        notion_text.Text(' or '),
        notion_text.Text(
          'NumberedListItems',
          annotations: notion_text.TextAnnotations(code: true),
        ),
        notion_text.Text('.'),
      ]),
      Paragraph(
        text: notion_text.Text(
          'Also, if your paragraph will have the same style you can write all your text directly like this to avoid using a list.',
        ),
      ),
    ]),
    Heading(text: notion_text.Text('Blocks'), type: 2),
    Heading(text: notion_text.Text('ToDo'), type: 3),
    ToDo(text: notion_text.Text('Daily meeting'), checked: true),
    ToDo(text: notion_text.Text('Clean the house')),
    ToDo(text: notion_text.Text('Do the laundry')),
    ToDo(text: notion_text.Text('Call mom'), children: [
      Paragraph(texts: [
        notion_text.Text('Note: ',
            annotations: notion_text.TextAnnotations(bold: true)),
        notion_text.Text('Remember to call her before 20:00'),
      ]),
    ]),
    Heading(text: notion_text.Text('Lists'), type: 3),
    BulletedListItem(text: notion_text.Text('Milk')),
    BulletedListItem(text: notion_text.Text('Cereal')),
    BulletedListItem(text: notion_text.Text('Eggs')),
    BulletedListItem(text: notion_text.Text('Tortillas of course')),
    Paragraph(
      text: notion_text.Text(
          'The numbered list are ordered by default by notion.'),
    ),
    NumberedListItem(text: notion_text.Text('Notion')),
    NumberedListItem(text: notion_text.Text('Keep by Google')),
    NumberedListItem(text: notion_text.Text('Evernote')),
    Heading(text: notion_text.Text('Toggle'), type: 3),
    Toggle(text: notion_text.Text('Toogle items'), children: [
      Paragraph(
        text: notion_text.Text(
          'Toogle items are blocks that can show or hide their children, and their children can be any other block.',
        ),
      ),
    ])
  ]);

// Append the content to the page
  var res = await notion.blocks.append(
    to: newPageId,
    children: fullContent,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

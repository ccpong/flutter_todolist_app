import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // 用於JSON轉換

class Todo {
  String title; // 待辦事項標題
  bool isCompleted; // 是否已完成
  DateTime createdAt; // 建立時間

  Todo({required this.title, this.isCompleted = false, DateTime? createdAt})
    : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // 新增：從JSON建立Todo
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      isCompleted: json['isCompleted'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.light,),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      home: const MyHomePage(title: '我的待辦事項'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
  final List<Todo> _todos = []; // 待辦事項列表
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadTodos();
  });
  }

  void _addTodo(String title) {
    setState(() {
      _todos.add(Todo(title: title));
    });
    _saveTodos();
  }

  void _editTodoTitle(Todo todo, String newTitle) {
    setState(() {
      todo.title = newTitle;
    });
    _saveTodos();
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = _todos.map((todo) => todo.toJson()).toList();
    await prefs.setString('todos', jsonEncode(todosJson));
  }// 從本地載入待辦事項

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosString = prefs.getString('todos');
    
    if (todosString != null && mounted) {
      final List<dynamic> todosJson = jsonDecode(todosString);
      setState(() {
        _todos.clear();
        _todos.addAll(todosJson.map((json) => Todo.fromJson(json)).toList());
      });
    }
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('新增待辦事項'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: '請輸入待辦事項...',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                final title = _textController.text.trim();
                if (title.isNotEmpty) {
                  _addTodo(title);
                  _textController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('新增'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTodoDialog(Todo todo) {
    _textController.text = todo.title;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('編輯待辦事項'),
          content: TextField(
            controller: _textController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                final newTitle = _textController.text.trim();
                if (newTitle.isNotEmpty) {
                  _editTodoTitle(todo, newTitle);
                  _textController.clear(); // 清空輸入框
                  Navigator.of(context).pop();
                }
              },
              child: const Text('儲存'),
            )
          ]
        );
      }
    );
  }

  Widget _buildTodoItem(Todo todo) {
    final listTitle = ListTile(
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      subtitle: Text('建立於：${_formatDate(todo.createdAt)}'),
      trailing: Icon(
        todo.isCompleted ? Icons.check_circle : Icons.circle_outlined,
        color: todo.isCompleted ? Colors.green : Colors.grey,
      ),
      onTap: () {
        setState(() {
          todo.isCompleted = !todo.isCompleted;
        });
        _saveTodos();
      },
      onLongPress: () {
        _showEditTodoDialog(todo);
      },
    );
    final card = Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      child: listTitle,
      
    );
    return card;
  }

  String _formatDate(DateTime date) {
    return date.toString().split('.')[0];
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '總共 ${_todos.length} 個待辦事項',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: _todos.isEmpty
                ? const Center(child: Text('還沒有待辦事項\n點擊 + 按鈕新增一個吧！'))
                : ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];

                      final dismissibleBackground = Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20.0),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 28,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '刪除',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );

                      return Dismissible(
                        key: Key(todo.createdAt.toString()),
                        direction: DismissDirection.endToStart,
                        background: dismissibleBackground,
                        onDismissed: (direction) {
                          setState(() {
                            _todos.removeAt(index);
                          });
                          _saveTodos();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('已刪除：${todo.title}'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: _buildTodoItem(todo),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        tooltip: '新增待辦事項',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

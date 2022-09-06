// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.red);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New Post'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _inputController,
              decoration: const InputDecoration(hintText: "Post Title"),
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    _handleNewItem(_inputController.text);
                    Navigator.pop(context);
                  });
                },
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("CancelButton"),
                    style: noStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              // _handleNewItem(valueText);
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('Cancel'),
                  );
                },
              ),
            ],
          );
        });
  }

  String valueText = "";

  final List<Item> items = [const Item(name: "Create A New Blog")];

  final _itemSet = <Item>{};

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      if (!completed) {
        print("Completing");
        _itemSet.add(item);
      } else {
        print("Making Undone");
        _itemSet.remove(item);
      }
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting post");
      items.remove(item);
      _itemSet.remove(item);
    });
  }

  void _handleNewItem(String itemText) {
    setState(() {
      print("Adding new post");
      Item item = Item(name: itemText);
      items.insert(0, item);
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: items.map((item) {
              return ToDoListItem(
                item: item,
                completed: _itemSet.contains(item),
                onListChanged: _handleListChanged,
                onDeleteItem: _handleDeleteItem,
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: ElevatedButton.icon(
                  icon: const Text('-'),
                  label: const Text("Delete Post"),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () {
                    _displayTextInputDialog(context);
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  icon: const Text('+'),
                  label: const Text("New Post"),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    _displayTextInputDialog(context);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Blog',
    home: ToDoList(),
  ));
}

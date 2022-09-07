// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Dialog with text fields from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputControllerTitle = TextEditingController();
  final TextEditingController _inputControllerDesc = TextEditingController();
  final TextEditingController _inputControllerLink = TextEditingController();

  // OK and CANCEL Buttons
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.red);

  // Text input window when creating a new post
  Future<void> _displayTextInputDialogNewPost(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Post'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // position
            mainAxisSize: MainAxisSize.min,
            // wrap content in flutter
            // Post Title
            children: <Widget>[
              TextField(
                onChanged: (valueTitle) {
                  setState(
                    () {
                      valueText = valueTitle;
                    },
                  );
                },
                controller: _inputControllerTitle,
                decoration: const InputDecoration(hintText: "Title"),
              ),
              // Post Description
              TextField(
                onChanged: (valueDesc) {
                  setState(
                    () {
                      valueText = valueDesc;
                    },
                  );
                },
                controller: _inputControllerDesc,
                decoration: const InputDecoration(hintText: "Description"),
              ),
              // Post Links or Images
              TextField(
                onChanged: (value) {
                  setState(
                    () {
                      valueText = value;
                    },
                  );
                },
                controller: _inputControllerLink,
                decoration: const InputDecoration(hintText: "Images/Links"),
              ),
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                child: const Text('OK'),
                onPressed: () {
                  setState(
                    () {
                      _handleNewItem(_inputControllerTitle.text);
                      Navigator.pop(context);
                    },
                  );
                },
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputControllerTitle,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("CancelButton"),
                    style: noStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          }
                        : null,
                    child: const Text('Cancel'),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String valueText = "";

  final List<Item> items = [];
  var indexOfItem = 0;

  final _itemSet = <Item>{};

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      if (!completed) {
        print("Loading Dialog");
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(item.name.toString()),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // position
                mainAxisSize: MainAxisSize.min,
                // wrap content in flutter
                // Post Title
                // children: const <Widget>[
                //   Text('widgets')
                // ]
              ),
            );
          },
        );
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
      _inputControllerTitle.clear();
      _inputControllerDesc.clear();
      _inputControllerLink.clear();
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
                  child: DropdownButton(
                    value: indexOfItem,
                    items: <int>[for (var i = 0; i < items.length; i++) i]
                        .map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      setState(() {
                        indexOfItem = value!;
                        _handleDeleteItem(items.elementAt(indexOfItem));
                      });
                    },
                  )),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  icon: const Text('+'),
                  label: const Text("New Post"),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    _displayTextInputDialogNewPost(context);
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

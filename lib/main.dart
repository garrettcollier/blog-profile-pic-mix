// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';
import 'package:image_picker/image_picker.dart';

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
  //distinguish between controllers
  int controllerCounter = 0;

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
                decoration: const InputDecoration(hintText: "Links"),
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

  final List<Item> items = [const Item(name: 'Add New Blog Posts')];
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
                children: [
                  Text(_inputControllerTitle.text),
                  Text(_inputControllerDesc.text),
                  Text(_inputControllerLink.text),
                ],
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
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Blog Posts'),
            ),
            ListTile(
              title: const Text('Comments'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => PageTwo())),
            ),
            ListTile(
              title: const Text('Upload Profile Picture'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => PageThree())),
            ),
          ],
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
            child: ListView(
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
          ),
          Column(
            children: [
              const Text(
                'Number of current Blog posts',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              const Text(
                'Delete Post using index based on list order',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              DropdownButton(
                alignment: Alignment.bottomLeft,
                value: indexOfItem,
                items: <int>[for (var i = 0; i <= items.length; i++) i]
                    .map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? value) {
                  setState(
                    () {
                      indexOfItem = value!;
                      _handleDeleteItem(items.elementAt(indexOfItem));
                    },
                  );
                },
              ),
            ],
          ),
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
      )),
    );
  }
}

class Comment extends StatefulWidget {
  const Comment({super.key});

  @override
  State createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final TextEditingController _inputControllerComment = TextEditingController();

  String valueText = "";

  final List<Item> comments = [const Item(name: 'Add Comments!')];
  var indexOfItem = 0;

  final _itemSet = <Item>{};

  // Text input window when creating a new post
  Future<void> _displayTextInputDialogNewComment(BuildContext context) async {
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
                controller: _inputControllerComment,
                decoration: const InputDecoration(hintText: "Title"),
              )
            ],
          ),
        );
      },
    );
  }

  void _handleCommentListChanged(Item item, bool completed) {
    setState(
      () {
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
                  children: [
                    Text(_inputControllerComment.text),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  void _handleDeleteComment(Item item) {
    setState(() {
      print("Deleting comment");
      comments.remove(item);
      _itemSet.remove(item);
    });
  }

  void _handleNewComment(String itemText) {
    setState(() {
      print("Adding new comment");
      Item item = Item(name: itemText);
      comments.insert(0, item);
      _inputControllerComment.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: ElevatedButton.icon(
          icon: const Text('+'),
          label: const Text("New Comment"),
          style: ElevatedButton.styleFrom(primary: Colors.green),
          onPressed: () {
            _displayTextInputDialogNewComment(context);
          },
        ),
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  var context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
    );
  }
}

class ImageFromGallery extends StatefulWidget {
  final type;
  const ImageFromGallery(this.type);

  @override
  ImageFromGalleryState createState() => ImageFromGalleryState(type);
}

class ImageFromGalleryState extends State<ImageFromGallery> {
  var _image;
  ImagePicker _picker = ImagePicker();
  var type;

  ImageFromGalleryState(this.type);

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(type == ImageSourceType.camera
              ? "Image from Camera"
              : "Image from Gallery")),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 52,
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                var source = type == ImageSourceType.camera
                    ? ImageSource.camera
                    : ImageSource.gallery;
                XFile? image = await _picker.pickImage(
                    source: source,
                    imageQuality: 50,
                    preferredCameraDevice: CameraDevice.front);
                setState(() {
                  _image = File(image!.path);
                });
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.blue[200]),
                child: _image != null
                    ? Image.file(
                        _image,
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.fitHeight,
                      )
                    : Container(
                        decoration: BoxDecoration(color: Colors.blue[200]),
                        width: 200,
                        height: 200,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

enum ImageSourceType { gallery, camera }

class PageThree extends StatelessWidget {
  void _handleURLButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageFromGallery(type)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile Picture for Blog"),
        ),
        body: Center(
          child: Column(
            children: [
              MaterialButton(
                color: Colors.blue,
                child: const Text(
                  "Pick Image from Gallery",
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _handleURLButtonPress(context, ImageSourceType.gallery);
                },
              ),
              MaterialButton(
                color: Colors.blue,
                child: const Text(
                  "Pick Image from Camera",
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _handleURLButtonPress(context, ImageSourceType.camera);
                },
              ),
            ],
          ),
        ));
  }
}

void main() {
  runApp(
    const MaterialApp(
      title: 'Blog',
      home: ToDoList(),
    ),
  );
}

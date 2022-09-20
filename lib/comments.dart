//Comment class to add comments
import 'package:flutter/material.dart';

class Comment {
  const Comment({required this.content});

  final String content;
}

typedef CommentListChangedCallback = Function(Comment comment, bool completed);
typedef CommentListRemovedCallback = Function(Comment comment);

class CommentList extends StatelessWidget {
  CommentList(
      {required this.comment,
      required this.completed,
      required this.onComListChanged,
      required this.onDeleteComment})
      : super(key: ObjectKey(comment));

  final Comment comment;
  final bool completed;
  final CommentListChangedCallback onComListChanged;
  final CommentListRemovedCallback onDeleteComment;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return completed //
        ? Colors.black
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!completed) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onComListChanged(comment, completed);
      },
      onLongPress: completed
          ? () {
              onDeleteComment(comment);
            }
          : null,
      leading: const CircleAvatar(
        backgroundColor: Colors.yellow,
      ),
      title: Text(
        comment.content,
        style: _getTextStyle(context),
      ),
    );
  }
}

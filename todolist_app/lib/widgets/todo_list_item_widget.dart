import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist_app/models/todo_model.dart';
import 'package:todolist_app/providers/all_providers.dart';

class TodoListItemWidget extends ConsumerStatefulWidget {
  TodoModel item;
  TodoListItemWidget({Key? key, required, required TodoModel this.item})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TodoListItemWidgetState();
}

class _TodoListItemWidgetState extends ConsumerState<TodoListItemWidget> {
  late FocusNode _textFocusNode;
  late TextEditingController _textController;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (isFocus) {
        if (!isFocus) {
          setState(() {
            _hasFocus = false;
          });

          ref.read(todoListProvider.notifier).edit(
              id: widget.item.id, newDescription: _textController.text);
        }
      },
      child: ListTile(
          onTap: () {
            setState(() {
              _hasFocus = true;
            });
            _textFocusNode.requestFocus();
            _textController.text = widget.item.description;
          },
          leading: Checkbox(
            value: widget.item.completed,
            onChanged: (value) {
              ref.read(todoListProvider.notifier).toggle(widget.item.id);
            },
          ),
          title: _hasFocus
              ? TextField(
                  controller: _textController,
                  focusNode: _textFocusNode,
                )
              : Text(widget.item.description)),
    );
  }
}

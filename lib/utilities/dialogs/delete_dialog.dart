import 'package:diplomski/utilities/dialogs/generic_idalog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericdialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this item?',
    optionBuilder: () => {
      'Yes': true,
      'Cancel': false,
    },
    contentIcon: const Icon(
      Icons.disabled_by_default_sharp,
      color: Colors.red,
    ),
  ).then(
    (value) => value ?? false,
  );
}

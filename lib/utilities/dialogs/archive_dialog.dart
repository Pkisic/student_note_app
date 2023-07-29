import 'package:diplomski/utilities/dialogs/generic_idalog.dart';
import 'package:flutter/material.dart';

Future<bool> showArchiveDialog(BuildContext context) {
  return showGenericdialog<bool>(
    context: context,
    title: 'Archive',
    content: 'Are you sure you want to archive this item?',
    optionBuilder: () => {
      'Yes': true,
      'Cancel': false,
    },
    contentIcon: const Icon(
      Icons.archive_rounded,
      color: Colors.blueGrey,
    ),
  ).then(
    (value) => value ?? false,
  );
}

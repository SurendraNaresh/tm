import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {
  final String value;
  final Function(String) onChanged;
  final String selectedValue;

  const ChoiceButton({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.selectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    IconData iconData;
    switch (value) {
      case 'Yes':
        backgroundColor = Colors.green;
        iconData = Icons.check;
        break;
      case 'No':
        backgroundColor = Colors.red;
        iconData = Icons.close;
        break;
      case 'Abstain':
        backgroundColor = Colors.grey;
        iconData = Icons.remove;
        break;
      default:
        backgroundColor = Colors.grey;
        iconData = Icons.help;
    }

    return TextButton.icon(
      onPressed: () => onChanged(value),
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      icon: Icon(
        iconData,
        color: Colors.white,
      ),
      label: Text(
        value,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

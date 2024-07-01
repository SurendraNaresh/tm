import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChoiceButton extends StatefulWidget {
  final String value;
  final String text;
  final IconData iconData;

  const ChoiceButton({
    Key? key,
    required this.value,
    required this.text,
    required this.iconData,
  }) : super(key: key);

  @override
  _ChoiceButtonState createState() => _ChoiceButtonState();

  static Widget createChoiceItem(String value) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: getColor(value),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(
            getIcon(value),
            color: Colors.white,
          ),
          const SizedBox(width: 5.0),
          Text(
            value == 'Yes' ? 'Yes (pro) vote' : (value == 'No' ? 'Against vote' : 'Abstain vote'),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  static List<DropdownMenuItem<String>> createChoiceButtons(List<String> values) {
    return values.map((value) => DropdownMenuItem<String>(
      value: value,
      child: Container(
        padding: const EdgeInsets.only(top: 5.0, bottom:16),
        decoration: BoxDecoration(
          color: getColor(value),
          borderRadius: BorderRadius.circular(10.0),
          //border: Border(right: BorderSide(width:20)),
        ),
        child: Row(
          children: [
            Icon(
              getIcon(value),
              color: Colors.white,
            ),
            const SizedBox(width: 5.0),
            Text(
              value == 'Yes' ? 'Yes (pro) vote' : (value == 'No' ? 'Against vote' : 'Abstain vote'),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    )).toList();
  }

  static IconData getIcon(String value) {
    switch (value) {
      case 'Yes':
        return Icons.check;
      case 'No':
        return Icons.close;
      case 'Abstain':
        return Icons.remove;
      default:
        return Icons.help;
    }
  }

  static Color getColor(String value) {
    switch (value) {
      case 'Yes':
        return Colors.blueAccent;
      case 'No':
        return Colors.red;
      case 'Abstain':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}

class _ChoiceButtonState extends State<ChoiceButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => Navigator.pop(context, widget.value), // Return value on press
      style: TextButton.styleFrom(
        backgroundColor: ChoiceButton.getColor(widget.value), // Helper function for color selection
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      icon: Icon(
        widget.iconData,
        color: Colors.white,
      ),
      label: Text(
        widget.text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class CampaignManager extends StatefulWidget {
  @override
  _CampaignManagerState createState() => _CampaignManagerState();
}

class _CampaignManagerState extends State<CampaignManager> {
  String _selectedValue = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: ChoiceButton.createChoiceButtons(['Yes', 'No', 'Abstain']),
        ),
        Text('Selected: $_selectedValue'),
      ],
    );
  }
}

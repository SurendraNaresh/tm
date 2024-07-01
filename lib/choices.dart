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
        backgroundColor = Colors.blue;
        iconData = Icons.check;
        break;
      case 'No':
        backgroundColor = Colors.red;
        iconData = Icons.close;
        break;
      case 'Abstain':
        backgroundColor = Colors.amber;
        iconData = Icons.remove;
        break;
      default:
        backgroundColor = Colors.grey;
        iconData = Icons.help;
    }

    return TextButton.icon(
      onPressed: () => onChanged(value),
      style: TextButton.styleFrom(
        backgroundColor: selectedValue == value ? backgroundColor : Colors.grey[300],
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

class VoteSelector extends StatefulWidget {
  final String initialVote;
  final Function(String) onVoteChanged;

  const VoteSelector({
    Key? key,
    required this.initialVote,
    required this.onVoteChanged,
  }) : super(key: key);

  @override
  _VoteSelectorState createState() => _VoteSelectorState();
}

class _VoteSelectorState extends State<VoteSelector> {
  String selectedValue = '';

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialVote;
  }

  void handleVoteChange(String value) {
    setState(() {
      selectedValue = value;
    });
    widget.onVoteChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ChoiceButton(
          value: 'Yes',
          selectedValue: selectedValue,
          onChanged: handleVoteChange,
        ),
        ChoiceButton(
          value: 'No',
          selectedValue: selectedValue,
          onChanged: handleVoteChange,
        ),
        ChoiceButton(
          value: 'Abstain',
          selectedValue: selectedValue,
          onChanged: handleVoteChange,
        ),
      ],
    );
  }
}

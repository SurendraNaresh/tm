import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeHomePage(),
    );
  }
}

class TicTacToeHomePage extends StatefulWidget {
  @override
  _TicTacToeHomePageState createState() => _TicTacToeHomePageState();
}

class _TicTacToeHomePageState extends State<TicTacToeHomePage> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late bool _isSinglePlayer;
  int _playerXScore = 0;
  int _playerOScore = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _board = List.generate(3, (_) => List.generate(3, (_) => ''));
    _currentPlayer = 'X';
    _isSinglePlayer = true; // Default to single-player mode
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  void _makeMove(int row, int col) {
    List<int> moveto  = [0,0];
    if (_board[row][col] == '') {
      setState(() {
        _board[row][col] = _currentPlayer;
        if (_checkWinner()) {
          _showDialog('Player $_currentPlayer Wins!');
          if (_currentPlayer == 'X') {
            _playerXScore++;
          } else {
            _playerOScore++;
          }
        } else if (_isBoardFull()) {
          _showDialog('It\'s a Draw!');
        } else {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
          if (_isSinglePlayer && _currentPlayer == 'O') {
            _makeComputerMove();
          }
        }
      });
    }
  }

void printMove(int i, int j) {
  // Part 1: Print the ith row and jth column move
  print("Computer moved at row ${i + 1}, column ${j + 1}");

  // Part 2 (Optional): Print bottom label message
  String bottomLabel = "Move made at position: ($i, $j)";
  print(bottomLabel); // You can modify this label as needed
}

  void _makeComputerMove() {
    List<Point<int>> Cells = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == '') {
          Cells.add(Point(i, j));
        }
      }
    }
    if (Cells.isNotEmpty) {
      Point<int> move = Cells[Random().nextInt(Cells.length)];
      _makeMove(move.x, move.y);
	}
	else {  
	  Point<int> move = doComputedMove();
	  _makeMove(move.x, move.y);
	  printMove(move.x, move.y);
    }
  }

  bool _isBoardFull() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == '') {
          return false;
        }
      }
    }
    return true;
  }


Point<int>  doComputedMove() {
  // Try to place 'O' in center if available
  if (_board[1][1] == ' ') {
    _board[1][1] = 'O';
    return Point(1,1);
  }

  // Block the player if they have two 'X's in any row, column, or diagonal
  // Check rows
  for (int i = 0; i < 3; i++) {
    if (_board[i][0] == 'X' && _board[i][1] == 'X' && _board[i][2] == ' ') {
      _board[i][2] = 'O'; // Block row
      return Point (i, 2);
    }
    if (_board[i][1] == 'X' && _board[i][2] == 'X' && _board[i][0] == ' ') {
      _board[i][0] = 'O'; // Block row
      return Point(i, 0);
    }
    if (_board[i][0] == 'X' && _board[i][2] == 'X' && _board[i][1] == ' ') {
      _board[i][1] = 'O'; // Block row
      return Point(i, 1);
    }
  }

  // Check columns
  for (int i = 0; i < 3; i++) {
    if (_board[0][i] == 'X' && _board[1][i] == 'X' && _board[2][i] == ' ') {
      _board[2][i] = 'O'; // Block column
      return Point(2,i) ;
    }
    if (_board[1][i] == 'X' && _board[2][i] == 'X' && _board[0][i] == ' ') {
      _board[0][i] = 'O'; // Block column
      return Point(0, i);
    }
    if (_board[0][i] == 'X' && _board[2][i] == 'X' && _board[1][i] == ' ') {
      _board[1][i] = 'O'; // Block column
      return Point(1, i);
    }
  }

  // Check diagonals
  if (_board[0][0] == 'X' && _board[1][1] == 'X' && _board[2][2] == ' ') {
    _board[2][2] = 'O'; // Block diagonal
    return Point(2, 2);
  }
  if (_board[2][2] == 'X' && _board[1][1] == 'X' && _board[0][0] == ' ') {
    _board[0][0] = 'O'; // Block diagonal
    return Point(0, 0);
  }
  if (_board[0][2] == 'X' && _board[1][1] == 'X' && _board[2][0] == ' ') {
    _board[2][0] = 'O'; // Block diagonal
    return Point(2, 0);
  }
  if (_board[2][0] == 'X' && _board[1][1] == 'X' && _board[0][2] == ' ') {
    _board[0][2] = 'O'; // Block diagonal
    return Point(0, 2);
  }

  // If no blocking or winning move is possible, place 'O' in any empty spot
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (_board[i][j] == ' ') {
        _board[i][j] = 'O';
        return Point(i, j);
      }
    }
  }
  return Point(0,  0);  // Fallback if no move was found (change as per your logic)
 
}




  bool _checkWinner() {
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] == _currentPlayer &&
          _board[i][1] == _currentPlayer &&
          _board[i][2] == _currentPlayer) {
        return true;
      }
      if (_board[0][i] == _currentPlayer &&
          _board[1][i] == _currentPlayer &&
          _board[2][i] == _currentPlayer) {
        return true;
      }
    }
    if (_board[0][0] == _currentPlayer &&
        _board[1][1] == _currentPlayer &&
        _board[2][2] == _currentPlayer) {
      return true;
    }
    if (_board[0][2] == _currentPlayer &&
        _board[1][1] == _currentPlayer &&
        _board[2][0] == _currentPlayer) {
      return true;
    }
    return false;
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Restart'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _setSinglePlayerMode(bool isSinglePlayer) {
    setState(() {
      _isSinglePlayer = isSinglePlayer;
      _resetGame();
    });
  }

  Widget _buildBoard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (col) {
            return GestureDetector(
              onTap: () => _makeMove(row, col),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    _board[row][col],
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Player $_currentPlayer\'s turn',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 20),
              _buildBoard(),
              SizedBox(height: 20),
              Text(
                'Score - X: $_playerXScore  O: $_playerOScore',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _setSinglePlayerMode(true),
                child: Text('Play Against Computer'),
                //style: ElevatedButton.styleFrom(primary: Colors.orangeAccent),
              ),
              ElevatedButton(
                onPressed: () => _setSinglePlayerMode(false),
                child: Text('Play Against Another Player'),
                //style: ElevatedButton.styleFrom(primary: Colors.tealAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

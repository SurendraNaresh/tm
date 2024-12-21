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

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _board = List.generate(3, (_) => List.generate(3, (_) => ''));
    _currentPlayer = 'X';
    _isSinglePlayer = true; // Default to single player mode
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] == '') {
      setState(() {
        _board[row][col] = _currentPlayer;
        if (_checkWinner()) {
          _showDialog('Player $_currentPlayer Wins!');
        } else if (_isBoardFull()) {
          _showDialog('It\'s a Draw!');
        } else {
          _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
          if (_isSinglePlayer && _currentPlayer == 'O') {
            return _makeComputerMove();
			//printMove(move);
          }
        }
      });
    }
  }

  void printMove(Point<int> point) {
    // Print the move at the specific point (x, y)
	setState(() {
		_board[point.x][point.y] = _currentPlayer;
	    print("Computer moved at row ${point.x + 1}, column ${point.y + 1}");
		_currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
		});
	}

  void _makeComputerMove() {
    List<Point<int>> emptyCells = [];
	Point <int> mv = Point(1,1);
  // Block the player if they have two 'X's in any row, column, or diagonal
	  // Check rows
	  for (int i = 0; i < 3; i++) {
		if (_board[i][0] == 'X' && _board[i][1] == 'X' && _board[i][2] == ' ') {
			mv=Point(i, 2);
			printMove(mv);
			return ; // Block row
		}
		if (_board[i][1] == 'X' && _board[i][2] == 'X' && _board[i][0] == ' ') {
			mv=Point(i, 0);
			printMove(mv);
			return ; // Block row
		}
		if (_board[i][0] == 'X' && _board[i][2] == 'X' && _board[i][1] == ' ') {
		   mv=Point(i, 1);
			 printMove(mv);
  			 return ; // Block row
		}
	  }

	  // Check columns
	  for (int i = 0; i < 3; i++) {
		if (_board[0][i] == 'X' && _board[1][i] == 'X' && _board[2][i] == ' ') {
			mv=Point(2, i);
			 printMove(mv);
			return ; // Block column
		}
		if (_board[1][i] == 'X' && _board[2][i] == 'X' && _board[0][i] == ' ') {
		  mv=Point(0, i);
			 printMove(mv);
			return ; // Block column
		}
		if (_board[0][i] == 'X' && _board[2][i] == 'X' && _board[1][i] == ' ') {
			mv=Point(1, i);
			 printMove(mv);
			return ; // Block column
		}
	  }

	  // Check diagonals
	  if (_board[0][0] == 'X' && _board[1][1] == 'X' && _board[2][2] == ' ') {
			mv=Point(2, 2);
			 printMove(mv);
			return ; // Block diagonal
	  }
	  if (_board[2][2] == 'X' && _board[1][1] == 'X' && _board[0][0] == ' ') {
		   mv=Point(0, 0);
			 printMove(mv);
			return ; // Block diagonal
	  }
	  if (_board[0][2] == 'X' && _board[1][1] == 'X' && _board[2][0] == ' ') {
		  mv=Point(2, 0);
			 printMove(mv);
			return ; // Block diagonal
	  }
	  if (_board[2][0] == 'X' && _board[1][1] == 'X' && _board[0][2] == ' ') {
			mv=Point(0, 2);
			printMove(mv);
			return ; // Block diagonal
	  }

	  // If no blocking or winning move is possible, place 'O' in any empty spot
	  for (int i = 0; i < 3; i++) {
		for (int j = 0; j < 3; j++) {
		  if (_board[i][j] == ' ') {
			mv=Point(i, j);
			 printMove(mv);
     		 return ;
		  }
		}
	  }
	//=================
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == '') {
          emptyCells.add(Point(i, j));
        }
      }
    }
    if (emptyCells.isNotEmpty && _currentPlayer != '0' ) {
      Point<int> move = emptyCells[Random().nextInt(emptyCells.length)];
	  printMove(move);
    }
	_currentPlayer = 'X' ; // default to Player 1
	return ; // Fallback if no move was found (change as per your logic)
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Player $_currentPlayer\'s turn',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            _buildBoard(),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => _setSinglePlayerMode(true),
              child: Text('Play Against Computer'),
            ),
            TextButton(
              onPressed: () => _setSinglePlayerMode(false),
              child: Text('Play Against Another Player'),
            ),
          ],
        ),
      ),
    );
  }
}

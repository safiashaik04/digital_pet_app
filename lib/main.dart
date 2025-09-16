import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: DigitalPetApp()));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  TextEditingController _nameController = TextEditingController();

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _checkWinLossConditions();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _checkWinLossConditions();
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
  }

  // Get pet color based on happiness level
  Color _getPetColor() {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  // Get pet mood based on happiness level
  String _getMood() {
    if (happinessLevel > 70) {
      return '😊 Happy';
    } else if (happinessLevel >= 30) {
      return '😐 Neutral';
    } else {
      return '😞 Unhappy';
    }
  }

  // Check win/loss conditions
  void _checkWinLossConditions() {
    if (happinessLevel > 80) {
      Timer(Duration(minutes: 3), () {
        if (happinessLevel > 80) {
          _showDialog('You Win!', 'Your pet has been happy for 3 minutes.');
        }
      });
    }
    if (hungerLevel == 100 && happinessLevel <= 10) {
      _showDialog('Game Over', 'Your pet is too hungry and unhappy.');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 30), (Timer timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        _checkWinLossConditions();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Name Input
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Enter Pet Name'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  petName = _nameController.text;
                });
              },
              child: Text('Set Pet Name'),
            ),
            SizedBox(height: 16.0),
            // Pet container with dynamic color
            Container(
              width: 100,
              height: 100,
              color: _getPetColor(),
              child: Center(
                  child: Text('$petName', style: TextStyle(fontSize: 20))),
            ),
            SizedBox(height: 16.0),
            // Display mood
            Text(
              'Mood: ${_getMood()}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}

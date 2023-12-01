import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class BMIModel {
  bool isMale = false;
  double height = 0.0;
  double weight = 0.0;
  int age = 0;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BMIInputScreen(),
    );
  }
}

class BMIInputScreen extends StatefulWidget {
  @override
  _BMIInputScreenState createState() => _BMIInputScreenState();
}

class _BMIInputScreenState extends State<BMIInputScreen> {
  final BMIModel model = BMIModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GenderIcon(
                  icon: Icons.male,
                  isSelected: model.isMale,
                  onTap: () {
                    setState(() {
                      model.isMale = true;
                    });
                  },
                  text: 'Male',
                ),
                SizedBox(width: 30),
                GenderIcon(
                  icon: Icons.female,
                  isSelected: !model.isMale,
                  onTap: () {
                    setState(() {
                      model.isMale = false;
                    });
                  },
                  text: 'Female',
                ),
              ],
            ),
            InputField(
              label: 'Height (cm)',
              onChanged: (value) {
                setState(() {
                  model.height = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            InputField(
              label: 'Weight (kg)',
              onChanged: (value) {
                setState(() {
                  model.weight = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            InputField(
              label: 'Age',
              onChanged: (value) {
                setState(() {
                  model.age = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (model.height > 0 && model.weight > 0 && model.age > 0) {
                  double bmi = calculateBMI(model.height, model.weight);
                  _navigateToBMIResult(context, bmi);
                } else {
                  // Handle invalid input
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Invalid Input'),
                      content: Text('Please enter valid height, weight, and age values.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text(
                'Calculate BMI',
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.orangeAccent,
                onPrimary: Colors.black,
                minimumSize: Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToBMIResult(BuildContext context, double bmi) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BMIResultScreen(bmi: bmi),
      ),
    );
  }

  double calculateBMI(double height, double weight) {
    return weight / ((height / 100) * (height / 100));
  }
}

class BMIResultScreen extends StatelessWidget {
  final double bmi;

  BMIResultScreen({required this.bmi});

  @override
  Widget build(BuildContext context) {
    String result = getBMIResult(bmi);
    String advice = getBMIAdvice(result);

    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Result'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.deepPurple],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite,
                  size: 50,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Your BMI',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                bmi.toStringAsFixed(2),
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Result',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                result,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Tips',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                advice,
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getBMIResult(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }

  String getBMIAdvice(String result) {
    switch (result) {
      case 'Underweight':
        return 'You are below the normal body weight. Consider consulting a nutritionist for a balanced diet.';
      case 'Normal weight':
        return 'Congratulations! You are at a healthy weight. Keep up the good work with a balanced diet and regular exercise.';
      case 'Overweight':
        return 'You are above the normal body weight. Consider incorporating more physical activity and a balanced diet into your routine.';
      case 'Obesity':
        return 'You are in the obesity range. Consult a healthcare professional for guidance on improving your health.';
      default:
        return '';
    }
  }
}

class GenderIcon extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final Function onTap;
  final String text;

  GenderIcon({required this.icon, required this.isSelected, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected ? Colors.pinkAccent : Colors.indigoAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ],
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final Function(String) onChanged;

  InputField({required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        onChanged(value);
      },
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: '',
        border: OutlineInputBorder(),
        labelStyle: TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }
}


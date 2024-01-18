
# Refactor TotalPerPerson widget

``
class TotalPerPerson extends StatelessWidget {
  final double totalPerPerson;

  const TotalPerPerson({Key? key, required this.totalPerPerson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Total Per Person\n\$${totalPerPerson.toStringAsFixed(2)}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

``

# PersonCounter Widget
``
class PersonCounter extends StatelessWidget {
  final int personCount;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const PersonCounter({
    Key? key,
    required this.personCount,
    required this.onDecrement,
    required this.onIncrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Split', style: TextStyle(fontSize: 18)),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: onDecrement,
            ),
            Text('$personCount', style: TextStyle(fontSize: 18)),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }
}
``

# Extract the TipSelector
``
class TipSelector extends StatelessWidget {
  final double tipPercentage;
  final ValueChanged<double> onTipChanged;

  const TipSelector({
    Key? key,
    required this.tipPercentage,
    required this.onTipChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tip', style: TextStyle(fontSize: 18)),
            Text('${(tipPercentage * 100).toStringAsFixed(0)}%', style: TextStyle(fontSize: 18)),
          ],
        ),
        Slider(
          min: 0,
          max: 100,
          divisions: 20,
          value: tipPercentage * 100,
          label: '${(tipPercentage * 100).round()}%',
          onChanged: (double newValue) {
            onTipChanged(newValue / 100);
          },
        ),
      ],
    );
  }
}

``

# Use extracted widgets in the Main Screen

``
class TipCalculatorScreen extends StatefulWidget {
  // ...

  @override
  Widget build(BuildContext context) {
    // ...

    return Scaffold(
      appBar: AppBar(
        title: Text('Tip Calculator'),
        actions: [ /* Theme switch code */ ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TotalPerPerson(totalPerPerson: totalPerPerson),
            SizedBox(height: 20),
            // ... Bill input field ...
            SizedBox(height: 20),
            PersonCounter(
              personCount: _personCount,
              onDecrement: () {
                setState(() {
                  if (_personCount > 1) _personCount--;
                });
              },
              onIncrement: () {
                setState(() {
                  _personCount++;
                });
              },
            ),
            TipSelector(
              tipPercentage: _tipPercentage,
              onTipChanged: (newTipPercentage) {
                setState(() {
                  _tipPercentage = newTipPercentage;
                });
              },
            ),
            // ... Rest of your UI ...
          ],
        ),
      ),
    );
  }
}

``
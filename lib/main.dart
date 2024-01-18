import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
        //home: const UTip());
        home: UTip(
          onThemeChanged: (isDarkModeEnabled) {
            setState(() {
              _isDarkMode = isDarkModeEnabled;
            });
          },
        ));
  }
}

class UTip extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const UTip({super.key, required this.onThemeChanged});

  @override
  State<UTip> createState() => _UTipState();
}

class _UTipState extends State<UTip> {
  double _billTotal = 100.00;
  int _personCount = 1;
  double _tipPercentage = 0.00;

  double _totalPerPerson(double billAmount, int splitBy, double tipPercentage) {
    var totalTip = billAmount * tipPercentage;
    var total = billAmount + totalTip;
    return total / splitBy;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Add style
    final style = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('UTip'),
        actions: [
          Switch(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
              widget.onThemeChanged(
                  value); // Notify the parent widget about the theme change
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //total per person display
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withAlpha(150),
                  // color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                //TODO:  ==== REFACTOR: at the end of the video, refactor this into its own widget!
                // === Use VScode refactor shortcut - cmd + . refactor into its own widget ===
                child: Column(
                  children: [
                    Text(
                      'Total Per Person',
                      textAlign: TextAlign.center,
                      style: style,
                    ),
                    Text(
                      '\$${(_billTotal * _tipPercentage).toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: style.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontSize: theme.textTheme.displaySmall!.fontSize! * 0.8,
                      ),
                    ) //theme.textTheme.titleMedium,
                  ],
                ),
                // === refactor into its own widget ===
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  //color: theme.colorScheme.primary.withAlpha(150),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                        labelText: 'Bill Amount',
                      ),
                      // keyboardAppearance: Brightness.dark,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        try {
                          setState(() {
                            _billTotal = double.parse(value);
                          });
                        } catch (e) {
                          // handle error for invalid input
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // Split Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Split',
                          style: theme.textTheme.titleMedium,
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_personCount > 1) {
                                    _personCount--;
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.remove,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              '$_personCount',
                              style: theme.textTheme.titleMedium,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _personCount++;
                                });
                              },
                              icon: Icon(
                                Icons.add,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Tip Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tip',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          '\$${(_billTotal * _tipPercentage).toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Slider
                    Text('${_tipPercentage * 100}%'),
                    Slider(
                      value: _tipPercentage,
                      onChanged: (value) {
                        setState(() {
                          _tipPercentage = value;
                        });
                      },
                      min: 0,
                      max: 0.5,
                      divisions: 5,
                      label: '${(_tipPercentage * 100).round()}%',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

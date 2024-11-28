import 'package:flutter/material.dart';
import 'dart:math';
// Import to add a save to clipboard function
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 175, 108, 135),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Art Studio'),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Define the widget options for each tab
  // Idealy, there will be three pages
  static const List<Widget> _widgetOptions = <Widget>[
    ColorMixer(),
    PaletteGenerator(),
    Text(
      'Art Showcase Screen',
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.color_lens),
            label: 'Color Mixer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.palette),
            label: 'Palette Generator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.art_track),
            label: 'Art Showcase',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PaletteGenerator extends StatefulWidget {
  const PaletteGenerator({super.key});

  @override
  State<PaletteGenerator> createState() => _PaletteGeneratorState();
}

class _PaletteGeneratorState extends State<PaletteGenerator> {
  List<Color> palette = [];

  @override
  void initState() {
    super.initState();
    generatePalette();
  }

  // Function to generate random colors for the palette
  void generatePalette() {
    final random = Random();
    setState(() {
      palette = List.generate(5, (_) {
        return Color.fromARGB(
          255, // Always fully opaque
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0), // Add top padding
      child: Column(
        children: [
          // Display the palette colors
          Expanded(
            child: ListView.builder(
              itemCount: palette.length,
              itemBuilder: (context, index) {
                final color = palette[index];
                final hexCode = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  title: Text(
                    hexCode,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy, color: Colors.blue),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: hexCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copied $hexCode to clipboard!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Button to generate a new palette
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: generatePalette,
              icon: const Icon(Icons.refresh),
              label: const Text('Generate New Palette'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ),
        ],
      )
    );
  }
}

class ColorMixer extends StatefulWidget {
  const ColorMixer({super.key});

  @override
  State<ColorMixer> createState() => _ColorMixerState();
}

class _ColorMixerState extends State<ColorMixer> {
  // List to store the liked colors
  List<String> likedColors = []; 

  // initializing the color vars
  double red = 0;
  double green = 0;
  double blue = 0;

  // Function to convert RGB to HEX since I want to save the HEX values from the RGB sliders
  String rgbToHex(double red, double green, double blue) {
    String redHex = red.toInt().toRadixString(16).padLeft(2, '0');
    String greenHex = green.toInt().toRadixString(16).padLeft(2, '0');
    String blueHex = blue.toInt().toRadixString(16).padLeft(2, '0');
    return redHex + greenHex + blueHex; // Return the HEX string
  }

  // Function to like the current color
  void likeColor() {
    String hex = rgbToHex(red, green, blue);
    // Check is a color has been previously liked to not get duplicates
    if (!likedColors.contains(hex)) {
      setState(() {
        likedColors.add(hex);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hexColor = rgbToHex(red, green, blue);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Color Display
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
                color:
                Color.fromRGBO(red.toInt(), green.toInt(), blue.toInt(), 1),
                borderRadius: BorderRadius.circular(15)),
          ),
          const SizedBox(height: 16),

          // Red Slider
          Text('Red: ${red.toInt()}'),
          Slider(
            value: red,
            min: 0,
            max: 255,
            activeColor: Colors.red,
            onChanged: (value) {
              setState(() {
                red = value;
              });
            },
          ),

          // Green Slider
          Text('Green: ${green.toInt()}'),
          Slider(
            value: green,
            min: 0,
            max: 255,
            activeColor: Colors.green,
            onChanged: (value) {
              setState(() {
                green = value;
              });
            },
          ),

          // Blue Slider
          Text('Blue: ${blue.toInt()}'),
          Slider(
            value: blue,
            min: 0,
            max: 255,
            activeColor: Colors.blue,
            onChanged: (value) {
              setState(() {
                blue = value;
              });
            },
          ),

          const SizedBox(height: 16),

          // Display HEX Values
          Text(
            'HEX: #$hexColor',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Like button container to add styles inapplicable to the button itself
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton.icon(
              onPressed: likeColor,
              icon: const Icon(Icons.favorite, color: Colors.red),
              label: const Text('Like Color'),
            ),
          ),

          const Text(
            'Liked Colors:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

         Expanded(
          child: ListView.builder(
              itemCount: likedColors.length,
              itemBuilder: (context, index) {
                final colorHex = likedColors[index];
                return ListTile(
                  leading: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(int.parse('0xFF$colorHex')),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  title: Text(
                    '#$colorHex',
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy, color: Colors.blue),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: '#$colorHex'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copied #$colorHex to clipboard!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

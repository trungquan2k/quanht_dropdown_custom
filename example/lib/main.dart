import 'package:flutter/material.dart';
import 'package:quanht_dropdown_custom/droplist_overlap/droplist.item.dart';
import 'package:quanht_dropdown_custom/droplist_overlap/droplist.overlay.dart';
import 'package:quanht_dropdown_custom/quanht_dropdown_custom.dart';

import 'extension.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropdown custom',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Dropdown custom'),
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
  Format _formatSelect = Format.UNKNOWN;
  ScrollController scrollController = ScrollController();
  final _itemsFormat =
      Format.values.where((v) => v != Format.UNKNOWN).map((element) {
    final index = Format.values.indexOf(element);
    return DroplistItem(
        id: index, nameSelected: element.name, index: index, data: element);
  }).toList();

  void _selectDropdown(DroplistItem item) {
    _formatSelect = item.data;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'You just select :',
                    ),
                    Text(
                      _formatSelect.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    AppDropList(
                      onChange: (output) => _selectDropdown(output),
                      items: _itemsFormat,
                      label: 'Format',
                      parentScrollController: scrollController,
                      colorLabel: Colors.black,
                      hintText: 'Select format',
                      enabled: true,
                      dropdownButtonStyle: const DropdownButtonStyle(
                        height: 48,
                      ),
                      dropdownStyle: const DropdownStyle(elevation: 2),
                    ),
                    const SizedBox(height: 1000.0)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

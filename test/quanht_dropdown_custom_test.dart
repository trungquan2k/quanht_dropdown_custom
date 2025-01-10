import 'package:flutter_test/flutter_test.dart';
import 'package:quanht_dropdown_custom/droplist_overlap/droplist.item.dart';

import 'package:quanht_dropdown_custom/quanht_dropdown_custom.dart';

enum Element { a, b, c }

void main() {
  test('adds one to input values', () {
    final calculator = AppDropList(
        onChange: (output) {},
        items: <DroplistItem>[
          DroplistItem(id: 1, nameSelected: 'name', index: 0, data: Element)
        ],
        hintText: '');

    expect(calculator, isNotNull);
  });
}

## I need help to update this package because I'm not playing with dart anymore

## Droplist  - yet another Droplist !!

Dropdown_custom can control space of list data when not enough space


### Simple use

### If you want to control auto close dropdown when scroll need to add parentScrollController in widget
### scrollController is a scrollController of screen
  AppDropList(
    onChange: (output) {},
    items: <DropListItem>[],
    label: '@label',
    parentScrollController: scrollController,
    colorLabel: Colors.black,
    hintText: '@hintxt',
    enabled: true,
    dropdownButtonStyle: const DropdownButtonStyle(
        height: 48,
      ),
    dropdownStyle: const DropdownStyle(elevation: 2),
  ),


### Use with controls
```
import 'package:quanht_dropdown_custom/quanht_dropdown_custom.dart';
   AppDropList(
    onChange: (output) {},
    items: <DropListItem>[],
    label: '@label',
    colorLabel: Colors.black,
    hintText: '@hintxt',
    enabled: true,
    dropdownButtonStyle: const DropdownButtonStyle(
        height: 48,
      ),
    dropdownStyle: const DropdownStyle(elevation: 2),
  ),
```
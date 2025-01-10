## I need help to update this package because I'm not playing with dart anymore

## Breaking Changes in v3.0.0

- The `AppDropList` widget support data list for not enough space.
- The `parentScrollController` this is ScrollController of screen when scroll auto close dropdown.
- The `DropListItem` class has replaced the `DropdownItem` class.
- `onChange` has been replaced with `onChange`. The `onChange` callback is called whenever the selection changes in the dropdown, whether it is selected or deselected.
- A lot of parameters have been renamed and updated. Please check the documentation for the updated parameters.

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
## Preview

[<img src="https://github.com/trungquan2k/quanht_dropdown_custom/blob/develop/assest/images/image1.png" width="250" alt=""/>](screenshot_1.png)
[<img src="https://github.com/trungquan2k/quanht_dropdown_custom/blob/develop/assest/images/image2.png.png" width="250" alt=""/>](screenshot_2.png)
[<img src="https://github.com/trungquan2k/quanht_dropdown_custom/blob/develop/assest/images/image3.png" width="250" alt="">](screenshot_3.png)
[<img src="https://github.com/trungquan2k/quanht_dropdown_custom/blob/develop/assest/images/image4.png" width="250" alt=""/>](screenshot_4.png)


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
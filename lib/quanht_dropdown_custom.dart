library quanht_dropdown_custom;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quanht_dropdown_custom/constants/app_colors.dart';
import 'package:quanht_dropdown_custom/constants/extension.dart';
import 'package:quanht_dropdown_custom/constants/utils.dart';

import 'droplist_overlap/droplist.overlay.dart';
import 'droplist_overlap/droplist.item.dart';

class AppDropList extends StatefulWidget {
  final ScrollController? parentScrollController;

  /// onChange is called when the selected option is changed.;
  /// It will pass back the value and the index of the option.
  final void Function(DropListItem) onChange;

  /// list of DropdownItems
  final List<DropListItem> items;

  /// dropdownButtonStyles passes styles to OutlineButton.styleFrom()
  final DropdownButtonStyle dropdownButtonStyle;

  /// dropdown button icon defaults to caret
  final Widget? icon;
  final bool hideIcon;

  final Color? colorItem;
  final Color? colorLabel;

  final Color? bgColorDropDown;

  // highligh color item
  final bool isHighLightColor;

  // value display
  final Color? colorActiveItem;
  final TextStyle? itemStyle;

  // hint text
  final String hintText;
  final TextStyle? hintTextStyle;

  final String? label;

  // enable select
  final bool enabled;

  /// if true the dropdown icon will as a leading icon, default to false
  final bool leadingIcon;
  final DropdownStyle dropdownStyle;

  final bool thumbVisibility;

  final bool isShowFlagCountry;
  final String flag;

  final Border? border;

  final bool isShowIconCheck;

  final String? initialValue;
  const AppDropList({
    super.key,
    this.parentScrollController,
    required this.onChange,
    required this.items,
    this.dropdownStyle = const DropdownStyle(),
    this.dropdownButtonStyle = const DropdownButtonStyle(),
    this.icon,
    this.hideIcon = false,
    this.enabled = true,
    required this.hintText,
    this.isHighLightColor = true,
    this.thumbVisibility = true,
    this.itemStyle,
    this.hintTextStyle,
    this.bgColorDropDown,
    this.leadingIcon = false,
    this.isShowFlagCountry = false,
    this.flag = '',
    this.colorItem,
    this.colorActiveItem,
    this.border,
    this.initialValue,
    this.label,
    this.colorLabel,
    this.isShowIconCheck = true,
  });

  @override
  State<AppDropList> createState() => _AppDropListState();
}

class _AppDropListState extends State<AppDropList> {
  Color get colorIcon => widget.enabled
      ? (_selectedValue.nameSelected.isEmpty)
          ? AppColor.primary
          : AppColor.primary
      : AppColor.primary.toOpacity(.9);

  bool get emptyValueSelect => _selectedValue.nameSelected.isNotEmpty;
  DropListItem _selectedValue = DropListItem(nameSelected: '', id: 0);

  _onChanged(DropListItem output) {
    widget.onChange(output);
    _selectedValue = output;
    setState(() {});
  }

  int? get initValue =>
      (parseToNull(widget.initialValue) == null && widget.items.isNotEmpty)
          ? null
          : int.parse(widget.initialValue ?? '0');

  @override
  void initState() {
    _sync();
    super.initState();
  }

  _sync() {
    if (parseToNull(widget.initialValue) != null && widget.items.isNotEmpty) {
      _selectedValue = widget.items.elementAt(initValue ?? 0);
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant AppDropList oldWidget) {
    _sync();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Color titleColor = widget.enabled
        ? (widget.colorLabel ?? AppColor.primary)
        : AppColor.primary.toOpacity(.6);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label ?? '',
            style: TextStyle(fontWeight: FontWeight.w500, color: titleColor),
          ),
        const SizedBox(height: 8.0),
        DroplistOverlay<DropListItem>(
          onChange: _onChanged,
          isEnable: widget.enabled,
          parentScrollController: widget.parentScrollController,
          dropdownButtonStyle: widget.dropdownButtonStyle,
          dropdownStyle: widget.dropdownStyle,
          items: widget.items.asMap().entries.map(
            (item) {
              return DropdownItem<DropListItem>(
                value: item.value,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: (item.key + 1) % 2 != 0
                          ? AppColor.primary.toOpacity(0.2)
                          : AppColor.transparent),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.value.nameSelected,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: TextStyle(
                              color: AppColor.primary.toOpacity(0.7),
                              fontSize: 14.0),
                        ),
                      ),
                      const SizedBox(width: 2.0),
                      if (_selectedValue.id == item.value.id &&
                          widget.isShowIconCheck) ...[
                        Icon(Icons.check),
                      ],
                    ],
                  ),
                ),
              );
            },
          ).toList(),
          child: Expanded(
            child: _selectedValue.nameSelected.isEmpty
                ? _buildHintText()
                : _buidHasValue(),
          ),
        ),
      ],
    );
  }

  Widget _buildCountryFlag() {
    return Row(
      children: [
        if (widget.isShowFlagCountry)
          widget.flag != ''
              ? SvgPicture.asset(
                  widget.flag,
                  width: 24,
                )
              : const SizedBox.shrink(),
        if (widget.isShowFlagCountry) const SizedBox(width: 8.0)
      ],
    );
  }

  Widget _buidHasValue() {
    return Row(
      children: [
        _buildCountryFlag(),
        Expanded(
          child: Text(
            _selectedValue.nameSelected,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: widget.itemStyle ??
                TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                    color: (widget.colorActiveItem ?? AppColor.primary)
                        .toOpacity(widget.enabled ? 1 : .6)),
          ),
        ),
      ],
    );
  }

  Widget _buildHintText() {
    return Row(
      children: [
        _buildCountryFlag(),
        Text(
          widget.hintText,
          style: widget.hintTextStyle ??
              Theme.of(context).inputDecorationTheme.hintStyle,
        ),
      ],
    );
  }
}

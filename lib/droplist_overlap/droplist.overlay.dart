import 'package:flutter/material.dart';
import 'package:quanht_dropdown_custom/constants/app_colors.dart';
import 'package:quanht_dropdown_custom/constants/extension.dart';
import 'package:quanht_dropdown_custom/constants/screens.dart';

import 'droplist.item.dart';

class DroplistOverlay<T> extends StatefulWidget {
  /// the child widget for the button, this will be ignored if text is supplied
  final Widget child;

  final ScrollController? parentScrollController;

  /// onChange is called when the selected option is changed.;
  /// It will pass back the value and the index of the option.
  final void Function(DropListItem)? onChange;

  /// list of DropdownItems
  final List<DropdownItem<T>> items;
  final DropdownStyle dropdownStyle;

  /// dropdownButtonStyles passes styles to OutlineButton.styleFrom()
  final DropdownButtonStyle dropdownButtonStyle;

  /// dropdown button icon defaults to caret
  final Icon? icon;
  final bool hideIcon;

  /// if true the dropdown icon will as a leading icon, default to false
  final bool leadingIcon;

  /// [is enable button]///
  final bool isEnable;

  // Widget nodata
  final Widget? nodata;

  const DroplistOverlay({
    super.key,
    this.hideIcon = false,
    required this.child,
    required this.items,
    this.parentScrollController,
    this.dropdownStyle = const DropdownStyle(),
    this.dropdownButtonStyle = const DropdownButtonStyle(),
    this.icon,
    this.leadingIcon = false,
    this.isEnable = true,
    this.onChange,
    this.nodata,
  });

  @override
  State<DroplistOverlay> createState() => _DroplistOverlayState();
}

class _DroplistOverlayState<T> extends State<DroplistOverlay<T>>
    with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _scrollListener();
  }

  _scrollListener() {
    if (widget.parentScrollController == null) return;
    widget.parentScrollController?.addListener(() {
      if (_isOpen) {
        _toggleDropdown(close: true);
      }
    });
  }

  DropdownButtonStyle get style => widget.dropdownButtonStyle;

  @override
  Widget build(BuildContext context) {
    // link the overlay to the button
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            width: style.width ?? Screens.getWidth(context),
            height: style.height ?? 50,
            padding: style.padding ?? EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                color: (style.backgroundColor),
                boxShadow: widget.isEnable
                    ? style.boxShadow ??
                        [
                          BoxShadow(
                              color: AppColor.boxShadowFocus,
                              blurRadius: 3,
                              offset: const Offset(0, 1)),
                        ]
                    : [],
                border:
                    style.border ?? Border.all(width: 1.5, color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: InkWell(
              onTap: widget.isEnable ? _toggleDropdown : null,
              child: Row(
                mainAxisAlignment:
                    style.mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
                textDirection:
                    widget.leadingIcon ? TextDirection.rtl : TextDirection.ltr,
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.child,
                  if (!widget.hideIcon)
                    Transform.flip(
                      flipY: _isOpen ? true : false,
                      child: widget.icon ??
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: RotatedBox(
                              quarterTurns: 4,
                              child: Icon(
                                Icons.arrow_drop_down,
                                weight: 20.0,
                              ),
                            ),
                          ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  OverlayEntry _createOverlayEntry() {
    // find the size and position of the current widget
    RenderBox renderBox = context.findRenderObject()! as RenderBox;
    var size = renderBox.size;

    var offset = renderBox.localToGlobal(Offset.zero);
    var topOffset = offset.dy + size.height + 5;
    double maxHeightBox =
        (MediaQuery.of(context).size.height - topOffset - 15).isNegative
            ? 100
            : MediaQuery.of(context).size.height - topOffset - 15;

    return OverlayEntry(
      // full screen GestureDetector to register when a
      // user has clicked away from the dropdown
      builder: (context) => GestureDetector(
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        // full screen container to register taps anywhere and close drop down
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: topOffset,
                width: widget.dropdownStyle.width ?? size.width,
                child: CompositedTransformFollower(
                  offset:
                      widget.dropdownStyle.offset ?? Offset(0, size.height + 5),
                  link: _layerLink,
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: widget.dropdownStyle.elevation ?? 0,
                    color: (widget.items.isEmpty
                            ? Color(0xffE7EAEE)
                            : widget.dropdownStyle.color)
                        ?.toOpacity(widget.isEnable ? 1 : 0.6),
                    shape: widget.dropdownStyle.shape,
                    child: widget.items.isEmpty
                        ? Container(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                widget.nodata ?? const Offstage(),
                                const Center(child: Text('No data')),
                              ],
                            ),
                          )
                        : SizeTransition(
                            axisAlignment: 1,
                            sizeFactor: _expandAnimation,
                            child: ConstrainedBox(
                              constraints: widget.dropdownStyle.constraints ??
                                  BoxConstraints(
                                    maxHeight: maxHeightBox,
                                  ),
                              child: RawScrollbar(
                                thumbVisibility: true,
                                thumbColor:
                                    widget.dropdownStyle.scrollbarColor ??
                                        Colors.grey,
                                controller: _scrollController,
                                child: ListView(
                                  padding: widget.dropdownStyle.padding ??
                                      EdgeInsets.zero,
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  children:
                                      widget.items.asMap().entries.map((item) {
                                    final response =
                                        item.value.value as DropListItem;
                                    return InkWell(
                                      onTap: widget.onChange != null
                                          ? () {
                                              widget.onChange!(response);
                                              _toggleDropdown();
                                            }
                                          : null,
                                      child: item.value,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleDropdown({bool close = false}) async {
    if (widget.onChange == null) return;
    if (_isOpen || close) {
      await _animationController.reverse();
      _overlayEntry.remove();
      setState(() {
        _isOpen = false;
      });
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry);
      setState(() => _isOpen = true);
      _animationController.forward();
    }
  }
}

/// DropdownItem is just a wrapper for each child in the dropdown list.\n
/// It holds the value of the item.
class DropdownItem<T> extends StatelessWidget {
  final T? value;
  final Widget child;

  const DropdownItem({super.key, this.value, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class DropdownButtonStyle {
  final MainAxisAlignment? mainAxisAlignment;
  final ShapeBorder? shape;
  final double elevation;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Color? primaryColor;

  const DropdownButtonStyle({
    this.boxShadow = const [
      BoxShadow(
        color: Color(0xFFCDE2FE),
        blurRadius: 3,
        offset: Offset(0, 1),
      ),
    ],
    this.border,
    this.mainAxisAlignment,
    this.backgroundColor = Colors.white,
    this.primaryColor = Colors.black87,
    this.constraints,
    this.height = 50,
    this.width,
    this.elevation = 1,
    this.padding,
    this.shape,
  });
}

class DropdownStyle {
  final double? elevation;
  final Color? color;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final Color? scrollbarColor;

  /// Add shape and border radius of the dropdown from here
  final ShapeBorder? shape;

  /// position of the top left of the dropdown relative to the top left of the button
  final Offset? offset;

  ///button width must be set for this to take effect
  final double? width;

  const DropdownStyle({
    this.constraints,
    this.offset,
    this.width,
    this.elevation,
    this.shape,
    this.color,
    this.padding,
    this.scrollbarColor,
  });
}

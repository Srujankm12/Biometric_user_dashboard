import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatefulWidget {
  final List<String> data;
  final Function(String?) onChanged;
  const CustomDropDownMenu({super.key, required this.data, required this.onChanged});

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  late String dropDownValue;

  @override
  void initState() {
    super.initState();
    // Initialize the default value to the first item in the list or any valid value
    if (widget.data.isNotEmpty) {
      dropDownValue = widget.data.first;
    } else {
      dropDownValue = "Select Machine Below"; // Default value if list is empty
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<String>(
        borderRadius: BorderRadius.circular(10),
        dropdownColor: Colors.white,
        value: dropDownValue,
        decoration: const InputDecoration(
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          fillColor: Colors.white,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
        items: widget.data.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            if (newValue != null) {
              dropDownValue = newValue;
              widget.onChanged(newValue);
            }
          });
        },
      ),
    );
  }
}


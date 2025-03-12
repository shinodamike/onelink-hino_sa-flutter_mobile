import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:iov/model/dropdown.dart';

class DropboxGeneralSearchViewTrip extends StatefulWidget {
  DropboxGeneralSearchViewTrip(
      {Key? key,
      required this.name,
      required this.listData,
      required this.onChanged})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String name;
  List<Dropdown> listData = [];
  final ValueChanged<Dropdown> onChanged;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<DropboxGeneralSearchViewTrip> {
  // List<Dropdown> listData = [];

  @override
  void initState() {
    // if (widget.listData == null) {
    //   listData = [new Dropdown("id", "ทดสอบ")];
    // }
    // if (widget.returnValue == null) {
    //   widget.returnValue = new Dropdown("", "");
    // }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      //FIXME : DropdownSearch options[hint,mode,dropdownSearchDecoration,showAsSuffixIcons,dropdownButtonBuilder,showSelectedItems,searchFieldProps,showSearchBox].
      child: DropdownSearch<Dropdown>(

        validator: (v) => v == null ? "required field" : null,
        // hint: widget.name,
        // mode: Mode.MENU,
        // dropdownSearchDecoration: const InputDecoration(
        //     border: OutlineInputBorder(
        //   borderSide: BorderSide.none,
        // )),
        // showAsSuffixIcons: true,
        // dropdownButtonBuilder: (_) => const Padding(
        //   padding: EdgeInsets.all(8.0),
        //   child: Icon(
        //     Icons.keyboard_arrow_down,
        //     color: Colors.grey,
        //   ),
        // ),
        // showSelectedItems: true,
        items: widget.listData,
        onChanged: (value) {
          widget.onChanged.call(value!);
        },
        // dropdownBuilder: (context, selectedItem) {
        //   return Text(
        //     selectedItem!.name,
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontSize: 12,
        //     ),
        //     textAlign: TextAlign.start,
        //   );
        // },
        // popupItemBuilder: (context, item, isSelected) {
        //   return Text(
        //     item.name,
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontSize: 12,
        //     ),
        //     textAlign: TextAlign.start,
        //   );
        // },
        itemAsString: (item) => item.name!,
        selectedItem: widget.listData[0],
        // searchFieldProps: TextFieldProps(
        //   controller: TextEditingController(text: ''),
        // ),
        compareFn: (item, selectedItem) =>
            item.name == selectedItem.name,
        // showSearchBox: false,
      ),
    );
  }
}

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropboxGeneralSearchViewString extends StatefulWidget {
  DropboxGeneralSearchViewString(
      {Key? key,
      required this.name,
      required this.listData,
      this.dropdownID,
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
  List<String> listData = [];
  final ValueChanged<String> onChanged;
  String? dropdownID = "";

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<DropboxGeneralSearchViewString> {
  // List<Dropdown> listData = [];

  TextEditingController textEditingController = TextEditingController();

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

  // defDropdownGeneral(int? id) {
  //   for (int i = 0; i < widget.listData.length; i++) {
  //     if (id != null && id == widget.listData[i].info!.vehicle_id) {
  //       return widget.listData[i];
  //     }
  //   }
  // }
  var search = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      //FIXME : DropdownSearch options[hint,mode,dropdownSearchDecoration,showAsSuffixIcons,dropdownButtonBuilder,showSelectedItems,searchFieldProps,showSearchBox].
      child: DropdownSearch<String>(
        // validator: (v) => v == null ? "required field" : null,
        validator: (value) {
          value == null ? "required field" : null;
          return null;
        },
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
        itemAsString: (item) {
          return item;
        },
        // selectedItem: defDropdownGeneral(widget.selectItem),
        // searchFieldProps: TextFieldProps(
        //   controller: textEditingController,
        // ),
        compareFn: (item, selectedItem) {
          if (item.contains(selectedItem)) {
            return true;
          } else {
            return false;
          }
        },
        // showSearchBox: true,
      ),
    );
  }
}

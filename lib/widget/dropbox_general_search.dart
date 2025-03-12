import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:iov/model/vehicle.dart';
import 'package:iov/utils/color_custom.dart';

class DropboxGeneralSearchView extends StatefulWidget {
  DropboxGeneralSearchView(
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
  List<Vehicle> listData = [];
  final ValueChanged<Vehicle> onChanged;
  String? dropdownID = "";

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<DropboxGeneralSearchView> {
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

  Widget _customPopupItemBuilderExample2(BuildContext context, Vehicle item, bool isSelected) {
    // print('vehicle_name: ${item.info!.vehicle_name!} isSelected: $isSelected ');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
        // border: Border.all(color: Theme.of(context).primaryColor),
        border: Border.all(color: ColorCustom.primaryColor),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: ListTile(
        selected: isSelected,
        title: Text(
            (widget.dropdownID != null && widget.dropdownID!.isNotEmpty) ?
            ((widget.dropdownID == "1") ? item.info!.licenseplate!:
            ((widget.dropdownID == "2") ? item.info!.vehicle_name!: item.info!.vin_no!))
                : item.info!.licenseplate!
        ),
        // subtitle: Text(item.createdAt.toString()),
        // leading: CircleAvatar(
        //   backgroundImage: NetworkImage(item.avatar),
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //FIXME : DropdownSearch options[hint,mode,dropdownSearchDecoration,showAsSuffixIcons,dropdownButtonBuilder,showSelectedItems,searchFieldProps,showSearchBox].
      child: DropdownSearch<Vehicle>(
        popupProps: PopupPropsMultiSelection.menu(
          // showSelectedItems: true,
          showSearchBox: true,
          itemBuilder: _customPopupItemBuilderExample2,
          favoriteItemProps: FavoriteItemProps(
            showFavoriteItems: true,
            // favoriteItems: (us) {
            //   return us.where((e) => e.info!.vin_no!.contains("x")).toList();
            // },
            favoriteItemBuilder: (context, item, isSelected) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[100]),
                child: Row(
                  children: [
                    Text("${item.info!.vin_no!}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.indigo),
                    ),
                    Padding(padding: EdgeInsets.only(left: 8)),
                    isSelected ? Icon(Icons.check_box_outlined) : SizedBox.shrink(),
                  ],
                ),
              );
            },
          ),
        ),
        // popupProps:PopupPropsMultiSelection.dialog(
        //   validationWidgetBuilder: (ctx, selectedItems) {
        //     return Container(
        //       color: Colors.blue[200],
        //       height: 56,
        //       child: Align(
        //         alignment: Alignment.center,
        //         child: MaterialButton(
        //           child: Text('OK'),
        //           onPressed: () {
        //             print('xxx');
        //             // _popupCustomValidationKey.currentState?.popupOnValidate();
        //           },
        //         ),
        //       ),
        //     );
        //   },
        // ),
        // dropdownDecoratorProps: DropDownDecoratorProps(
        //   dropdownSearchDecoration: InputDecoration(labelText: "User by name"),
        // ),
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
        filterFn: (item, filter) {
          search = filter;
        
          if (item.info!.licenseplate!.contains(filter)) {
            item.searchType = 0;
            return true;
          }
          if (item.info!.vehicle_name!.contains(filter)) {
            item.searchType = 1;
            return true;
          }
          if (item.info!.vin_no!.contains(filter)) {
            item.searchType = 2;
            return true;
          } else {
            return false;
          }
        },
        // showSelectedItems: true,
        items: widget.listData,
        onChanged: (value) {
          widget.onChanged.call(value!);
        },
        itemAsString: (item) {
          if(search.isNotEmpty){
            if (item.searchType == 0) {
              return item.info!.licenseplate!;
            } else  if (item.searchType == 1) {
              return item.info!.vehicle_name!;
            } else {
              return item.info!.vin_no!;
            }
          }else{
            if (widget.dropdownID != null && widget.dropdownID!.isNotEmpty) {
              if (widget.dropdownID == "1") {
                return item.info!.licenseplate!;
              } else if (widget.dropdownID == "2") {
                return item.info!.vehicle_name!;
              } else {
                return item.info!.vin_no!;
              }
            }

            return item.info!.licenseplate!;
          }
        },
        // selectedItem: defDropdownGeneral(widget.selectItem),
        // searchFieldProps: TextFieldProps(
        //   controller: textEditingController,
        // ),
        compareFn: (item, selectedItem) {
          if (item.info!.licenseplate!
                  .contains(selectedItem.info!.licenseplate!) ||
              item.info!.vehicle_name!
                  .contains(selectedItem.info!.vehicle_name!) ||
              item.info!.vin_no!.contains(selectedItem.info!.vin_no!)) {
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

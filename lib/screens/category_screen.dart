import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/models/product.dart';
import 'package:reshop/widgets/product_card.dart';

import '../providers/dummyData.dart';
import '../constants.dart';
import '../size_config.dart';
import '../widgets/bottom_sheet_widget.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = "/CategoryScreen";
  String title = "";
  CategoryScreen({String title, Key key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var subCat;
  var selectedBtn = 0;
  var all;
  var other;
  var selectedItem = "aaa";
  var dropdownValue = 'One';
  SizeConfig _size = SizeConfig();

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context).settings.arguments;
    widget.title = data;
    _size.init(context);
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: _size.getWidth - 20,
                //  height: _size.getHeight,
                child: Column(children: [
                  title(),
                  SizedBox(height: 10),
                  subCategory(),
                  SizedBox(height: 10),
                  myGridView(),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Row(children: [
      Text(
        widget.title,
        style: TextStyle(
          fontSize: 28,
        ),
      ),
      Spacer(),
      IconButton(
          onPressed: () {
            bottomSheet();
          },
          icon: Icon(Icons.filter_alt_outlined)),
      IconButton(onPressed: () {}, icon: Icon(Icons.filter_list))
    ]);
  }

  Widget subCategory() {
    var _dummyData = Provider.of<DummyData>(context, listen: false);
    TextStyle selectedBtnStyle = TextStyle(color: Colors.white);
    TextStyle unselectedBtnStyle = TextStyle(color: Colors.black26);
    subCat = _dummyData.subCategories[widget.title];
    return Container(
      height: 45,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(5),
        children: List.generate(subCat.length, (index) {
          return Padding(
            padding: EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: index != selectedBtn
                      ? MaterialStateProperty.all(
                          Color.fromRGBO(208, 208, 208, 1))
                      : null,
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              child: Text(
                subCat[index],
                style: TextStyle(
                    color: index != selectedBtn
                        ? mySecondTextColor
                        : Colors.white),
              ),
              onPressed: () {
                setState(() {
                  selectedBtn = index;
                });
              },
            ),
          );
        }),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 26,
        ),
        onPressed: (() {
          Navigator.pop(context);
        }),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {},
          label: Text(
            "Search",
            style: TextStyle(
                color: mySecondTextColor,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
          icon: Icon(Icons.search, size: 24),
        ),
      ],
      elevation: 0,
    );
  }

  Widget myGridView() {
    var provider = Provider.of<DummyData>(context);
    if (selectedBtn == 0) {
      all = provider.getByCategory(widget.title).toList();
    } else {
      other = provider.getBySubCat(all, subCat[selectedBtn]).toList();
    }
    return Container(
      height: _size.getHeight,
      width: _size.getWidth,
      child: GridView.builder(
          scrollDirection: Axis.vertical,
          itemCount: selectedBtn == 0 ? all.length : other.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.9,
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8),
          itemBuilder: (BuildContext context, int index) {
            return ProductCart(
              product: all[index],
            );
          }),
      // child: GridView.count(
      //   crossAxisCount: 2,
      //   childAspectRatio: 0.8,
      //   padding: EdgeInsets.all(2),
      //   scrollDirection: Axis.vertical,
      //   children: List.generate(
      //     selectedBtn == 0 ? all.length : other.length,
      //     (index) => Padding(
      //       padding: EdgeInsets.all(4),
      //       child: ProductCart(
      //         product: all[index],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  bottomSheet() {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (context) {
          return BottomSheetContent();
        });
  }
}

class BottomSheetContent extends StatefulWidget {
  GlobalKey mykey;
  BottomSheetContent({this.mykey, Key key}) : super(key: key);

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  SizeConfig _size = SizeConfig();
  GlobalKey categoryKey = GlobalKey();
  GlobalKey brandKey = GlobalKey();
  RangeValues _rangeValues = RangeValues(3000, 20000);
  var dropdownValue = 'One';
  @override
  Widget build(BuildContext context) {
    _size.init(context);
    return Container(
      padding: EdgeInsets.all(20),
      height: _size.getHeight - (_size.getHeight / 3),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(alignment: Alignment.topCenter, children: [
          Container(
            width: _size.getWidth - 20,
            alignment: Alignment.topCenter,
            child: Text(
              "Filters",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.topRight,
              child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close_rounded,
                    size: 25,
                    color: Colors.black,
                  )),
            ),
          )
        ]),
        SizedBox(height: 50),
        Container(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Category",
                style: TextStyle(
                    fontSize: 18, color: Color.fromRGBO(0, 0, 0, 0.6)),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_forward_ios,
                ),
                iconSize: 17,
                color: Color.fromRGBO(0, 0, 0, 0.5),
              )
            ],
          ),
        ),
        Container(
            alignment: Alignment.topLeft,
            height: 40,
            child: myDropDownButton([""], widget.mykey)),
        Container(
          height: 10,
          width: _size.getWidth,
          child: Divider(
            endIndent: 15,
            thickness: 1,
            color: mySecondTextColor,
          ),
        ),
        Container(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Brand",
                style: TextStyle(
                    fontSize: 18, color: Color.fromRGBO(0, 0, 0, 0.6)),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_forward_ios,
                    color: Color.fromRGBO(0, 0, 0, 0.5)),
                iconSize: 17,
              )
            ],
          ),
        ),
        Container(
            alignment: Alignment.topLeft,
            height: 40,
            child: myDropDownButton([""], widget.mykey)),
        Container(
          height: 10,
          width: _size.getWidth,
          child: Divider(
            endIndent: 15,
            thickness: 1,
            color: mySecondTextColor,
          ),
        ),
        Container(
          height: 30,
          child: Row(
            children: const [
              Text(
                "Price",
                style: TextStyle(
                    fontSize: 18, color: Color.fromRGBO(0, 0, 0, 0.6)),
              ),
            ],
          ),
        ),
        RangeSlider(
          values: _rangeValues,
          min: 0,
          max: 50000,
          divisions: 50,
          labels: RangeLabels(_rangeValues.start.toInt().toString(),
              _rangeValues.end.toInt().toString()),
          onChanged: (newValue) {
            setState(() {
              _rangeValues = newValue;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_rangeValues.start.toInt().toString() + " L.E",
                style: TextStyle(color: myPrimaryColor)),
            Text(
              _rangeValues.end.toInt().toString() + " L.E",
              style: TextStyle(color: myPrimaryColor),
            )
          ],
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                width: (_size.getWidth - 40) / 2,
                height: 50,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Reset",
                      style: TextStyle(fontSize: 17),
                    ))),
            Container(
                width: (_size.getWidth - 40) / 2,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Apply",
                      style: TextStyle(fontSize: 17),
                    )))
          ],
        )
      ]),
    );
  }

  myDropDownButton(List items, GlobalKey key) {
    return DropdownButton<String>(
      underline: Container(
        color: Colors.white,
      ),
      key: key,
      value: dropdownValue,
      icon: const Icon(null),
      // elevation: 50,
      isDense: true,
      style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 0.4), fontSize: 15),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child:
              Padding(padding: EdgeInsets.only(left: 30), child: Text(value)),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/consts/size_config.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> category;
  final List<String> brand;
  const FilterBottomSheet(
      {Key? key, required this.category, required this.brand})
      : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  SizeConfig size = SizeConfig();
  GlobalKey categoryKey = GlobalKey();
  GlobalKey brandKey = GlobalKey();
  RangeValues _rangeValues = RangeValues(0, 50000);
  String dropdownValueForCate = "";
  String dropdownValueForBrand = "";
  @override
  void initState() {
    dropdownValueForCate = widget.category[0];
    dropdownValueForBrand = widget.brand[0];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size.init(context);
    return Container(
      padding: EdgeInsets.all(20),
      height: size.getHeight - (size.getHeight / 3),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(alignment: Alignment.topCenter, children: [
          Container(
            width: size.getWidth - 20,
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
            child: myDropDownButton(widget.category, categoryKey)),
        Container(
          height: 10,
          width: size.getWidth,
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
            child: myDropDownButton(widget.brand, brandKey)),
        Container(
          height: 10,
          width: size.getWidth,
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
                width: (size.getWidth - 40) / 2,
                height: size.getProportionateScreenHeight(60),
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Reset",
                      style: TextStyle(fontSize: 17),
                    ))),
            Container(
                width: (size.getWidth - 40) / 2,
                height: size.getProportionateScreenHeight(60),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(myPrimaryColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
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

  myDropDownButton(List<String> items, GlobalKey key) {
    return DropdownButton<String>(
      underline: Container(color: Colors.white),
      key: key,
      value: key == categoryKey ? dropdownValueForCate : dropdownValueForBrand,
      icon: const Icon(null),
      isDense: true,
      style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 0.4), fontSize: 15),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Padding(
                padding: EdgeInsets.only(left: 30), child: Text(value)));
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          if (key == categoryKey) {
            dropdownValueForCate = newValue!;
          } else {
            dropdownValueForBrand = newValue!;
          }
        });
      },
    );
  }

  apply() {
    // Navigator.of(context).popAndPushNamed();
  }
}

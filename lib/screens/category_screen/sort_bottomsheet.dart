import 'package:flutter/material.dart';
import 'package:reshop/consts/constants.dart';
import 'package:reshop/consts/size_config.dart';

class SortBottomSheet extends StatefulWidget {
  const SortBottomSheet({Key? key}) : super(key: key);

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  SizeConfig size = SizeConfig();
  var selectedVal = 1;
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
                "Sort by",
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
          myRadioButtons("Popularity", 1),
          Divider(color: mySecondTextColor, height: 1),
          myRadioButtons("Rating", 2),
          Divider(color: mySecondTextColor, height: 1),
          myRadioButtons("Price : High to Low", 3),
          Divider(color: mySecondTextColor, height: 1),
          myRadioButtons("Price : Low to High", 4),
          Spacer(),
          Container(
              width: size.getWidth - 40,
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
        ]));
  }

  Widget myRadioButtons(String text, int value) {
    TextStyle unselected =
        TextStyle(fontSize: 18, color: Color.fromRGBO(0, 0, 0, 0.5));
    TextStyle selected = TextStyle(fontSize: 18, color: myPrimaryColor);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: value == selectedVal ? selected : unselected),
        Radio(
          value: value,
          groupValue: selectedVal,
          onChanged: (int? newValue) {
            setState(() {
              selectedVal = newValue!;
            });
          },
        )
      ],
    );
  }
}

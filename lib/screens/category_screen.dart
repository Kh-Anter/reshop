import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reshop/models/product.dart';
import 'package:reshop/widgets/product_card.dart';

import '../providers/dummyData.dart';
import '../constants.dart';
import '../size_config.dart';

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
                  SizedBox(
                    height: 10,
                  ),
                  subCategory(),
                  SizedBox(
                    height: 10,
                  ),
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
      IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt_outlined)),
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
}

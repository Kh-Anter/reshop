import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../consts/size_config.dart';
import '../../providers/categories.dart';
import '../../screens/category_screen/category_screen.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var catProvider = Provider.of<CategoriesProvider>(context);
    SizeConfig size = SizeConfig();
    size.init(context);
    return catProvider.allCategories.isNotEmpty
        ? body(catProvider, size)
        : FutureBuilder(
            initialData: catProvider.allCategories,
            future: catProvider.init(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return body(catProvider, size);
              }
            });
  }

  Widget body(catProvider, size) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: size.isTablete || size.isLandscape ? 5 : 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15),
      itemCount: catProvider.allCategories.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          Navigator.pushNamed(context, CategoryScreen.routeName,
              arguments: catProvider.allCategories[index].name);
        },
        child: Material(
          borderRadius: BorderRadius.circular(5),
          elevation: 3,
          child: Container(
            padding: EdgeInsets.all(1),
            margin: EdgeInsets.all(20),
            child: Column(children: [
              Expanded(
                child: Image.network(
                  catProvider.allCategories[index].imgUrl,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20),
              FittedBox(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Text(catProvider.allCategories[index].name))
            ]),
          ),
        ),
      ),
    );
  }
}

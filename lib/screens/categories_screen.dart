import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

class CategoriesScreen extends StatelessWidget {
  static const routeName = "/CategoriesScreen";
  const CategoriesScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //       leading: IconButton(
    //     icon: Icon(Icons.arrow_back_ios),
    //     onPressed: () {
    //       Navigator.pop(context);
    //     },
    //   )),
    //   body: SingleChildScrollView(
    //     child: Padding(
    //       padding: EdgeInsets.only(left: 20),
    //       child:
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      //  Text("Categories", style: TextStyle(fontSize: 28)),
      SizedBox(
        height: 50,
      ),
      mytree()
    ]);
  }

  Widget mytree() {
    TextStyle style = TextStyle(fontSize: 16);
    TreeController tree_ctrl = TreeController();
    return TreeView(
        indent: 20,
        iconSize: 30,
        treeController: tree_ctrl,
        nodes: [
          TreeNode(
              children: [
                TreeNode(
                    content: InkWell(
                        child: Text("Smart phones", style: style),
                        onTap: () {})),
                TreeNode(
                    content: InkWell(
                        child: Text(
                          "Tablets",
                          style: style,
                        ),
                        onTap: () {})),
                TreeNode(
                    content: InkWell(
                        child: Text(
                          "Television",
                          style: style,
                        ),
                        onTap: () {})),
                TreeNode(
                    content: InkWell(
                        child: Text(
                          "Labtops",
                          style: style,
                        ),
                        onTap: () {})),
                TreeNode(
                    content: InkWell(
                        child: Text(
                          "Accessories",
                          style: style,
                        ),
                        onTap: () {})),
              ],
              content: InkWell(
                  child: Text(
                    "Electronics",
                    style: style,
                  ),
                  onTap: () {})),
          TreeNode(
              content: InkWell(
                  child: Text(
                    "Beauty",
                    style: style,
                  ),
                  onTap: () {})),
          TreeNode(
              content: InkWell(
                  child: Text(
                    "Fashion",
                    style: style,
                  ),
                  onTap: () {})),
          TreeNode(
              content: InkWell(
                  child: Text(
                    "Home",
                    style: style,
                  ),
                  onTap: () {})),
          TreeNode(
              content: InkWell(
                  child: Text(
                    "Kitchen",
                    style: style,
                  ),
                  onTap: () {})),
          TreeNode(
              content: InkWell(
                  child: Text(
                    "Sport",
                    style: style,
                  ),
                  onTap: () {})),
        ]);
  }
}

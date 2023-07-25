// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

class HeroImages extends StatelessWidget {
  static const routeName = "/heroImages";
  final Map<String, dynamic> productImages;

  const HeroImages({Key? key, required this.productImages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> images = productImages["images"];
    int startIndex = productImages["startIndex"];
    bool isProfile = productImages["isProfile"] ?? false;
    String? title = isProfile ? productImages["title"] : null;
    var pageCtrl = PageController(initialPage: startIndex);
    Widget image = images[0].contains("assets")
        ? Image.asset(images[0], fit: BoxFit.contain)
        : FancyShimmerImage(
            imageUrl: images[0],
            boxFit: BoxFit.contain,
          );
    return Scaffold(
      appBar: appBar(context, title),
      body: Hero(
          tag: "",
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 2,
            child: isProfile
                ? Center(
                    child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: image),
                  )
                : PageView(
                    controller: pageCtrl,
                    children: List.generate(
                      images.length,
                      (index) => images[index].contains("assets")
                          ? Image.asset(images[index])
                          : FancyShimmerImage(
                              imageUrl: images[index],
                              boxFit: BoxFit.contain,
                            ),
                    )),
          )),
    );
  }

  appBar(context, String? txt) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: txt != null
          ? Text(txt,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold))
          : null,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: (() {
          Navigator.pop(context);
        }),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reshop/models/onboardingModel.dart';

class OnBoardingProvider with ChangeNotifier {
  List<OnBoardingScreenModel> allScreens = [];
  Future<void> init() async {
    allScreens = await fetchOnboardingScreens();
  }

  Future<List<OnBoardingScreenModel>> fetchOnboardingScreens() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('onboarding_screens').get();
    return snapshot.docs
        .map((doc) => OnBoardingScreenModel(
              title: doc['title'],
              description: doc['description'],
              imgUrl: doc['imgUrl'],
            ))
        .toList();
  }
}

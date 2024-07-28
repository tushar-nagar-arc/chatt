import 'dart:developer';
import 'package:chatt/services/local_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../auth/models/user_model.dart';

class UserProvider with ChangeNotifier{

  List<UserModel> usersList = [];
  
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future fetchUsers() async {
    
    usersList.clear();
    log("fetching");
    try{
      final response = await _firebaseFirestore.collection("users").get();
      for(int i=0;i<response.docs.length;i++){
        usersList.add(UserModel.fromJson(response.docs[i].data()));
      }
      usersList.removeWhere((element) => element.userId == LocalStorage.getUserInfo()!.userId!);
      notifyListeners();
    }
    catch(e){
      print("$e");
      rethrow;
    }
    finally{
      notifyListeners();
    }
  }

}
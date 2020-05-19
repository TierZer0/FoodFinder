import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


import '../services/auth.dart';

class DataService with ChangeNotifier {
  final Firestore _db = Firestore.instance;
  String key = 'w-VxjptGgWFWBzmZbewHR939JctoKl8dcoyJ1TUZx0ua-h3rUNYEsFVtjeFVLEPZVDZmJFpWOrOVDhX8pN88_xIkZO0yzqwdBwjYXk-WHmRgxKWBgurVMxiXYoRmXXYx';

  int selectedView = 1;


  bool darkTheme = false;

  setDarkTheme(bool) async {
    
    darkTheme = bool;
    notifyListeners();
    return darkTheme;
  }

  final primaryColor = new Color(0xFF1de9b6);
  final darkColor = new Color(0xFF212121);
  final darkHigherColor = new Color(0xFF424242);
  final whiteColor = new Color(0xFFF8F8F9);
  getBackgroundColor() {
    if (darkTheme) {
      return darkColor;
    } else {
      return whiteColor;
    }
  }

  getElevatedBackgroundColor() {
    if (darkTheme) {
      return darkHigherColor;
    } else {
      return whiteColor;
    }
  }

  getTextColorOnPrimaryColor() {
    if (darkTheme) {
      return darkColor;
    } else {
      return whiteColor;
    }
  }

  getTextColor() {
    if (darkTheme) {
      return whiteColor;
    } else {
      return darkColor;
    }
  }


  doNothing() {

  }

  List<bool> prices = [true, false, false, false];

  setPriceSelected(index, value) async {
    prices[index] = value;
  }

  addPreference(field, item) async {
    var user = authService.currentUser;

    DocumentReference ref = _db.collection('users').document(user);

    ref.collection(field).document(item).setData({
      'pref' : item
    });
  }

  addToHistory(data) {
    var user = authService.currentUser;

    DocumentReference ref = _db.collection('users').document(user);

    ref.collection('history').document(data['id']).setData(
      {
        'restaurantId' : data['id'],
        'name' : data['name'],
        'address' : data['location']['address1'],
        'category' : data['categories'],
        'rating' : data['rating'],
        'cost' : data['price'],
        'lat' : data['coordinates']['latitude'],
        'lng' : data['coordinates']['longitude']
      }
    );
  }

  removePreference(field, item) async {
    var user = authService.currentUser;

    _db.collection('users').document(user).collection(field).document(item).delete();
  }

  getRestaurants(lat, lng) async {
    String baseUrl = 'https://api.yelp.com/v3/businesses/search';
    List data;
    String fullUrl = baseUrl + 
    "?latitude=" + lat.toString() +
    "&longitude=" + lng.toString() +
    "&categories=restaurants" +
    "&radius=5000" +
    "&limit=30";

    var response = await http.get(
      fullUrl,
      headers: {
        'Authorization' : 'Bearer $key'
      }
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      data = result['businesses'];
      return data;
    } else {
      return null;
    }


  }

  getNearbyRestaurants(distance, restaurantType, prices, ratings, lat, lng) async {
    String baseUrl = 'https://api.yelp.com/v3/businesses/search';
    List data;
    //print(prices);
    var price = [ratings];

    var rating = [prices];

    String fullUrl = baseUrl + 
    "?latitude=" + lat.toString() + 
    "&longitude=" + lng.toString() +
    "&categories=restaurants,food" + 
    "&radius=" + (distance != "" ? distance.toString() : "5000") +
    (price.length != 0 ? "&price=" + price.join(',') : "") + 
    "&rating=" + rating.join(',') + 
    "&term=" + restaurantType +
    "&limit=20";
    print(fullUrl);
    var response = await http.get(
      fullUrl,
      headers: {
        'Authorization': 'Bearer $key'
      }
    );
    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      data = result['businesses'];
      
      return data;
    } else {
      return null;
    }
  }

  getNearbyRestaurantsFromUser(lat, lng) async {
    var user = authService.currentUser;
    List data;
    var db = Firestore.instance.collection('users').document(user);

    var foodTypesData = [];
    QuerySnapshot foodTypes = await db.collection('foodTypes').getDocuments();
    foodTypes.documents.forEach((DocumentSnapshot doc) {
      foodTypesData.add(doc.data['pref']);
    });

    var distancesData = [];
    QuerySnapshot distances = await db.collection('distances').getDocuments();
    distances.documents.forEach((DocumentSnapshot doc) {
      distancesData.add(doc.data['pref']);
    });

    var pricesData = [];
    QuerySnapshot prices = await db.collection('prices').getDocuments();
    prices.documents.forEach((DocumentSnapshot doc) {
      pricesData.add(doc.data['pref']);
    });

    var ratingsData = [];
    QuerySnapshot ratings = await db.collection('ratings').getDocuments();
    ratings.documents.forEach((DocumentSnapshot doc) {
      ratingsData.add(doc.data['pref']);
    }); 

    String baseUrl = 'https://api.yelp.com/v3/businesses/search';

    String fullUrl = baseUrl + 
    "?latitude="  + lat.toString() + 
    "&longitude=" + lng.toString() + 
    "&categories=restuarants,food" +
    "&radius=" + (distancesData.length != 0 ? distancesData[0] : "5000") + 
    (pricesData.length != 0 ? "&price=" + pricesData.join(',') : "") + 
    "&rating=" + ratingsData.join(',') + 
    "&term=" + foodTypesData.join(',') + 
    "&limit=20";
    print(fullUrl);
    var response = await http.get(
      fullUrl,
      headers: {
        'Authorization': 'Bearer $key'
      }
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      data = result['businesses'];
      return data;
    } else {
      return null;
    }



  }

  getRestaurantDetails(restaurantID) async {
    String baseUrl = 'https://api.yelp.com/v3/businesses/';
    
    String fullUrl = baseUrl + restaurantID;
    var response = await http.get(
      fullUrl,
      headers: {
        'Authorization' : 'Bearer $key'
      }
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return result;
    }
  }

  getAndBuildRestuarantDetails(restaurantID)  async {
    String baseUrl = 'https://api.yelp.com/v3/businesses/';

    String fullUrl = baseUrl + restaurantID;
    var response = await http.get(
      fullUrl,
      headers: {
        'Authorization' : 'Bearer $key'
      }
    );

    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      return new Text(
        result['name']
      );
    }
  }
}

final DataService dataService = DataService();
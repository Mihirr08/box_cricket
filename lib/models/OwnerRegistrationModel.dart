import 'dart:convert';
import "dart:io";

import 'package:dio/dio.dart';

import 'BookingSlots.dart';

class OwnerRegistrationModel {
  OwnerRegistrationModel({
    this.ownerEmail,
    this.ownerPhone,
    this.ownerName,
    this.boxCricketName,
    this.boxCricketAddress,
    this.boxCricketState,
    this.boxCricketCity,
    this.boxCricketLandmark,
    this.bookingSlots,
    this.minSlotPrice,
    this.maxSlotPrice,
    this.boxCricketFacilities,
    this.boxCricketArea,
    this.files,
  });

  OwnerRegistrationModel.fromJson(dynamic json) {
    ownerEmail = json['ownerEmail'];
    ownerPhone = json['ownerPhone'];
    ownerName = json['ownerName'];
    boxCricketName = json['boxCricketName'];
    boxCricketAddress = json['boxCricketAddress'];
    boxCricketState = json['boxCricketState'];
    boxCricketCity = json['boxCricketCity'];
    boxCricketLandmark = json['boxCricketLandmark'];
    if (json['bookingSlots'] != null) {
      bookingSlots = [];
      json['bookingSlots'].forEach((v) {
        bookingSlots?.add(BookingSlots.fromJson(v));
      });
    }
    minSlotPrice = json['minSlotPrice'];
    maxSlotPrice = json['maxSlotPrice'];
    boxCricketFacilities = json['boxCricketFacilities'];
    files = json['files'];
  }

  String? ownerEmail;
  String? ownerPhone;
  String? ownerName;
  String? boxCricketName;
  String? boxCricketAddress;
  String? boxCricketState;
  String? boxCricketCity;
  String? boxCricketLandmark;
  String? boxCricketArea;
  List<BookingSlots>? bookingSlots;
  int? minSlotPrice;
  int? maxSlotPrice;
  String? boxCricketFacilities;
  List<File>? files;

  Future<Map<String, dynamic>> toJson() async {
    final map = <String, dynamic>{};
    map['ownerEmail'] = ownerEmail;
    map['ownerPhone'] = ownerPhone;
    map['ownerName'] = ownerName;
    map['boxCricketName'] = boxCricketName;
    map['boxCricketAddress'] = boxCricketAddress;
    map['boxCricketState'] = boxCricketState;
    map['boxCricketCity'] = boxCricketCity;
    map['boxCricketLandmark'] = boxCricketLandmark;
    map['boxCricketArea'] = boxCricketArea;
    if (bookingSlots != null) {
      map['bookingSlots'] =
          jsonEncode(bookingSlots?.map((v) => v.toJson()).toList());
    } else {
      map['bookingSlots'] = jsonEncode([]);
    }
    map['minSlotPrice'] = minSlotPrice ?? 1000;
    map['maxSlotPrice'] = maxSlotPrice ?? 2000;
    map['boxCricketFacilities'] = boxCricketFacilities;

    List<MultipartFile> multiPartFiles = [];

    for (File element in (files ?? [])) {
      MultipartFile multipartFile = await MultipartFile.fromFile(element.path);

      multiPartFiles.add(multipartFile);
    }

    map['files'] = multiPartFiles;
    return map;
  }
}

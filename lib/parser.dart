import 'package:latlong2/latlong.dart';

class Record {
  int lat = 0;
  double latd = 0.0;
  double lond = 0.0;
  int lon = 0;
  int temp = 0;
  int hum = 0;
  Record(List<dynamic> lod) {
    lon = lod[0] + (lod[1] << 8) + (lod[2] << 16) + (lod[3] << 24);
    lat = lod[4] + (lod[5] << 8) + (lod[6] << 16) + (lod[7] << 24);
    temp = lod[8] + (lod[9] << 8) + (lod[10] << 16) + (lod[11] << 24);
    hum = lod[12] + (lod[13] << 8) + (lod[14] << 16) + (lod[15] << 24);
    latd = lat / 1000000;
    lond = lon / 1000000;
  }
  @override
  String toString() {
    return "lat:$lat, lon:$lon,latd:$latd,lond:$lond, temp:$temp, hum:$hum";
  }
}

class EPage {
  List<dynamic> listOfData = [];
  List<Record> listOfRecords = [];
  int Metadata = 0;
  EPage(List<dynamic> lod) {
    //   try {
    listOfData = lod;
    Metadata = lod[0] + (lod[1] << 8) + (lod[2] << 16) + (lod[3] << 24);
    lod.removeRange(0, 16);
    for (var i = 0; i < Metadata; i++) {
      try {
        var i = Record(lod.take(16).toList());
        listOfRecords.add(i);
        lod.removeRange(0, 16);
      } catch (e) {
        print(e);
      }
    }
  }
  void printdata() {
    for (var record in listOfRecords) {
      print(record.toString());
    }
  }
}

class Parser {
  List<EPage> pages = [];
  Parser(List<int> list) {
    while (list.length > 512) {
      var lod = list.take(512).toList();
      pages.add(EPage(lod));
      try {
        list.removeRange(0, 512);
      } catch (e) {
        print(e);
      }
    }
  }
  @override
  toString() {
    String retval = "";
    for (var elem in gpscoords()) {
      retval += elem.toString();
    }
    return retval;
  }

  List<LatLng> gpscoords() {
    List<LatLng> coordlist = [];
    for (var page in pages) {
      for (var rec in page.listOfRecords) {
          if (rec.latd > 90.0||rec.latd < -90.0 || rec.lond > 90.0||  rec.lond < -90.0 ){
              print(rec.latd);
              print(rec.lond);
          }else{
        coordlist.add(LatLng(rec.latd, rec.lond));
        }
      }
    }
    return coordlist;
  }
}

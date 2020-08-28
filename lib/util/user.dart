class User{

  String _lat;
  String _long;
  String _address;
  String _note;
  String _time;
  int _id;
  User(this._lat,this._long,this._address,this._note,this._time);

  //assign incoming map values to the class private variables
  User.map(dynamic obj)
  {
    this._lat=obj["lat"];
    this._long=obj["long"];
    this._address=obj["address"];
    this._note=obj["note"];
    this._time=obj["time"];
    this._id=obj["id"];
  }
//get the values .This is used to secure the private variables
  String get lat=>_lat;
  String get long=>_long;
  String get address=>_address;
  String get note=>_note;
  String get time=>_time;
  int get id=>_id;

  //
Map<String,dynamic> toMap()
{
  var map=Map<String,dynamic>();
  map["lat"]=_lat;
  map["long"]=_long;
  map["address"]=_address;
  map["note"]=_note;
  map["time"]=_time;
  if(id!=null)
    {
      map["id"]=_id;
    }
  return map;
}
User.fromMap(Map<String,dynamic> map)
  {
this._lat=map["lat"];
this._long=map["long"];
this._address=map["address"];
this._note=map["note"];
this._time=map["time"];
this._id=map["id"];
  }
}
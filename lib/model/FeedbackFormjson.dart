class FeedbackformJson {
  String first_name="";
  String last_name="";
  String phone="";
  String feedback="";
  String latitude="";
  String longitude="";
  String deviceid="";
  String intimestamp="";
  String outtimestamp="";


  FeedbackformJson({this.first_name, this.last_name,this.phone, this.feedback,this.latitude, this.longitude,this.deviceid, this.intimestamp,this.outtimestamp});

  FeedbackformJson.fromJson(Map<String, dynamic> json) {
    first_name = json['first_name'];
    last_name = json['last_name'];
    phone = json['phone'];
    feedback = json['feedback'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deviceid = json['deviceid'];
    intimestamp = json['intimestamp'];
    outtimestamp = json['outtimestamp'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.first_name;
    data['last_name']=this.last_name;
    data['phone']=this.phone;
    data['feedback']=this.feedback;
    data['latitude']=this.latitude;
    data['longitude']=this.longitude;
    data['deviceid']=this.deviceid;
    data['intimestamp']=this.intimestamp;
    data['outtimestamp']=this.outtimestamp;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
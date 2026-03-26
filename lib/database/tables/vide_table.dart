import 'dart:convert';

class VideoTable {
  String? videoId;
  String? videoDescription;

  VideoTable({this.videoId, this.videoDescription, });
  factory VideoTable.fromRawJson(String str) =>
      VideoTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VideoTable.fromJson(Map<String, dynamic> json) =>
      VideoTable(
        videoId: json["id"],
        videoDescription: json["data"],

      );

  Map<String, dynamic> toJson() => {
    "videoId": videoId,
    "videoDescription": videoDescription,

  };
}
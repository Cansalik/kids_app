import 'dart:convert';

class VideoTable {
  int? videoId;
  int? categoryId;
  String? videoUrl;
  String? videoName;

  VideoTable({
    this.videoId,
    this.categoryId,
    this.videoUrl,
    this.videoName,
  });

  factory VideoTable.fromRawJson(String str) =>
      VideoTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VideoTable.fromJson(Map<String, dynamic> json) =>
      VideoTable(
        videoId: json["video_id"],
        categoryId: json["category_id"],
        videoUrl: json["video_url"],
        videoName: json["video_name"],
      );

  Map<String, dynamic> toJson() => {
    "videoId": videoId,
    "categoryId": categoryId,
    "videoUrl": videoUrl,
    "videoName": videoName,
  };
}

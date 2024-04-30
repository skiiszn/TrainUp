class Video {
  String? title;
  String? time;
  String? thumbnail;
  String? videoId;

  Video({
    this.title,
    this.time,
    this.thumbnail,
    this.videoId,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        title: json["title"],
        time: json["time"],
        thumbnail: json["thumbnail"],
        videoId: json["videoId"],
      );
}

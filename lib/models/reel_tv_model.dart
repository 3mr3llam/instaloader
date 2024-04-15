class ReelModel {
  Graphql? graphql;

  ReelModel({this.graphql});

  ReelModel.fromJson(Map<String, dynamic> json) {
    graphql = json['graphql'] != null ? Graphql.fromJson(json['graphql']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (graphql != null) {
      data['graphql'] = graphql!.toJson();
    }
    return data;
  }
}

class Graphql {
  ShortcodeMedia? shortcodeMedia;

  Graphql({this.shortcodeMedia});

  Graphql.fromJson(Map<String, dynamic> json) {
    shortcodeMedia = json['shortcode_media'] != null ? ShortcodeMedia.fromJson(json['shortcode_media']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (shortcodeMedia != null) {
      data['shortcode_media'] = shortcodeMedia!.toJson();
    }
    return data;
  }
}

class ShortcodeMedia {
  String? displayUrl;
  String? videoUrl;

  ShortcodeMedia({
    this.displayUrl,
    this.videoUrl,
  });

  ShortcodeMedia.fromJson(Map<String, dynamic> json) {
    displayUrl = json['display_url'];
    videoUrl = json['video_url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['display_url'] = displayUrl;
    data['video_url'] = videoUrl;
    return data;
  }
}

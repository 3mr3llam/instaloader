class PhotoModel {
  Graphql? graphql;

  PhotoModel({this.graphql});

  PhotoModel.fromJson(Map<String, dynamic> json) {
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

  ShortcodeMedia({
    this.displayUrl,
  });

  ShortcodeMedia.fromJson(Map<String, dynamic> json) {
    displayUrl = json['display_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['display_url'] = displayUrl;
    return data;
  }
}

import 'package:webfeed/domain/atom_category.dart';
import 'package:webfeed/domain/atom_link.dart';
import 'package:webfeed/domain/atom_person.dart';
import 'package:webfeed/domain/atom_source.dart';
import 'package:webfeed/domain/media/media.dart';
import 'package:webfeed/util/helpers.dart';
import 'package:xml/xml.dart';
import 'dart:convert';

class AtomItem {
  final String id;
  final String title;
  final String updated;

  final List<AtomPerson> authors;
  final List<AtomLink> links;
  final List<AtomCategory> categories;
  final List<AtomPerson> contributors;
  final AtomSource source;
  final String published;
  final String content;
  final String summary;
  final String rights;
  final Media media;

  AtomItem({
    this.id,
    this.title,
    this.updated,
    this.authors,
    this.links,
    this.categories,
    this.contributors,
    this.source,
    this.published,
    this.content,
    this.summary,
    this.rights,
    this.media,
  });

  String getAuthorsJson(){
    List<String> authorsStrings = [];
    authors.forEach((author) {
      authorsStrings.add(jsonEncode(author.toJson()));
    });
    //print("authorjson: "+jsonEncode(authorsStrings));
    return jsonEncode(authorsStrings);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'updated': updated,
      'authors': getAuthorsJson(),
      'links': "",
      'categories' : "",
      'contributors': "",
      'source': "",
      'published': published,
      'content': content,
      'summary': summary,
      'rights': rights,
      'media':""
    };
  }

  factory AtomItem.parse(XmlElement element) {
    return AtomItem(
      id: findElementOrNull(element, "id")?.text,
      title: findElementOrNull(element, "title")?.text,
      updated: findElementOrNull(element, "updated")?.text,
      authors: element.findElements("author").map((element) {
        return AtomPerson.parse(element);
      }).toList(),
      links: element.findElements("link").map((element) {
        return AtomLink.parse(element);
      }).toList(),
      categories: element.findElements("category").map((element) {
        return AtomCategory.parse(element);
      }).toList(),
      contributors: element.findElements("contributor").map((element) {
        return AtomPerson.parse(element);
      }).toList(),
      source: AtomSource.parse(findElementOrNull(element, "source")),
      published: findElementOrNull(element, "published")?.text,
      content: findElementOrNull(element, "content")?.text,
      summary: findElementOrNull(element, "summary")?.text,
      rights: findElementOrNull(element, "rights")?.text,
      media: Media.parse(element),
    );
  }
}

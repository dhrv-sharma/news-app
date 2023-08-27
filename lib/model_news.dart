class newsModel {
  // step 1 creating the variable that you required
  late String? newsheadline;
  late String? newsDes;
  late String? newsImg;
  late String? newsUrl;

  // step 2 create constructor which can have not reuired fiels

  newsModel({this.newsheadline, this.newsDes, this.newsImg, this.newsUrl});

  // step 3 creating an instance without any object  using fromMap fucntion
  // factory constructor
  factory newsModel.fromMap(Map news) {
    // in this fucntion you have to pass news Map as a argument

    return newsModel(
          newsheadline: news["title"],
          newsDes: news["description"],
          newsImg: news["urlToImage"],
          newsUrl: news["url"]);

  }

    
    
}

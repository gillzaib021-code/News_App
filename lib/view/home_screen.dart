
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/categories_news_model.dart';
import 'package:flutter_news_app/models/news_channel_headlines_model.dart';
import 'package:flutter_news_app/view/bottom_news_detail_screen.dart';
import 'package:flutter_news_app/view/categoires_screen.dart';
import 'package:flutter_news_app/view/news_detail_screen.dart';
import 'package:flutter_news_app/view_model/news_view_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, CBS, foxnews, cnn, googlenews }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();

  FilterList? selectedMenu;
  final formate = DateFormat('MMMM dd, yyyy');
  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 23, 56, 83),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoiresScreen()));
          },
          icon: Image.asset('assets/images/category_icon.png', height: 20, width: 20,color: Colors.white,),
        ),
        title: Text('News', style: GoogleFonts.poppins(fontSize: width * 0.06, fontWeight: FontWeight.w700,color: Colors.white)),
        centerTitle: true,
        actions: [
          PopupMenuButton<FilterList>(
          
            initialValue: selectedMenu,
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (FilterList item) {
              switch (item) {
                case FilterList.bbcNews:
                  name = "bbc-news";
                  break;
                case FilterList.aryNews:
                  name = "ary-news";
                  break;
                case FilterList.CBS:
                  name = "cbs-news";
                  break;
                case FilterList.foxnews:
                  name = "fox-news";
                  break;
                case FilterList.cnn:
                  name = "cnn";
                  break;
                case FilterList.googlenews:
                  name = "google-news";
                  break;
              }
              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: FilterList.bbcNews, child: Text('BBC News')),
              const PopupMenuItem(value: FilterList.aryNews, child: Text('ARY News')),
              const PopupMenuItem(value: FilterList.CBS, child: Text('CBS News')),
              const PopupMenuItem(value: FilterList.foxnews, child: Text('Fox News')),
              const PopupMenuItem(value: FilterList.cnn, child: Text('CNN News')),
              const PopupMenuItem(value: FilterList.googlenews, child: Text('Google News')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // TOP SECTION - Horizontal Scrolling Channel Headlines
          SizedBox(
            height: height * 0.55,
            width: width,
            child: FutureBuilder<NewsChannelHeadlinesModel>(
              key: ValueKey(name),
              future: newsViewModel.fetchNewsChannelHeadlinesApi(name: name),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(color: Colors.blue),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 50),
                        const SizedBox(height: 10),
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.data!.articles == null || snapshot.data!.articles!.isEmpty) {
                  return const Center(
                    child: Text('No news found for this channel'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(
                        snapshot.data!.articles![index].publishedAt.toString()
                      );

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailScreen(
                                newsImage: snapshot.data!.articles![index].urlToImage ?? '',
                                newsTitle: snapshot.data!.articles![index].title ?? 'No Title',
                                newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                author: snapshot.data!.articles![index].author ?? 'Unknown',
                                discrption: snapshot.data!.articles![index].description ?? 'No description available',
                                content: snapshot.data!.articles![index].content ?? 'No content available',
                                source: snapshot.data!.articles![index].source?.name ?? 'Unknown Source',
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: width * 0.95,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: height * 0.6,
                                width: width * 0.9,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage ?? '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: SpinKitCircle(color: Colors.blue),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(
                                      Icons.error, 
                                      color: Colors.red, 
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                right: 20,
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title ?? 'No Title',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: width * 0.04, 
                                            fontWeight: FontWeight.w700
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index].source?.name ?? 'Unknown',
                                              style: GoogleFonts.poppins(
                                                fontSize: width * 0.03, 
                                                fontWeight: FontWeight.w400
                                              ),
                                            ),
                                            Text(
                                              formate.format(dateTime),
                                              style: GoogleFonts.poppins(
                                                fontSize: width * 0.025, 
                                                fontWeight: FontWeight.w300
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          
          // BOTTOM SECTION - Vertical Scrolling General News
          Expanded(
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi('general'),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(color: Colors.blue),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.data!.articles == null || snapshot.data!.articles!.isEmpty) {
                  return const Center(
                    child: Text('No general news found'),
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(
                        snapshot.data!.articles![index].publishedAt.toString()
                      );

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNewsDetailScreen(
                                newsImage: snapshot.data!.articles![index].urlToImage ?? '',
                                newsTitle: snapshot.data!.articles![index].title ?? 'No Title',
                                newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                author: snapshot.data!.articles![index].author ?? 'Unknown',
                                discrption: snapshot.data!.articles![index].description ?? 'No description available',
                                content: snapshot.data!.articles![index].content ?? 'No content available',
                                source: snapshot.data!.articles![index].source?.name ?? 'Unknown Source',
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.articles![index].urlToImage ?? '',
                                  fit: BoxFit.cover,
                                  height: height * 0.18,
                                  width: width * 0.3,
                                  placeholder: (context, url) => Container(
                                    height: height * 0.18,
                                    width: width * 0.3,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: SpinKitCircle(color: Colors.blue, size: 30),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    height: height * 0.18,
                                    width: width * 0.3,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.error, color: Colors.red),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: height * 0.18,
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.articles![index].title ?? 'No Title',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              snapshot.data!.articles![index].source?.name ?? 'Unknown',
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                color: Colors.black54,
                                                fontSize: width * 0.03,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            formate.format(dateTime),
                                            style: GoogleFonts.poppins(
                                              fontSize: width * 0.025,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
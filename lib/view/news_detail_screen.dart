
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsImage, newsTitle, newsDate, author, discrption, content, source;
  
  const NewsDetailScreen({
    super.key,
    required this.newsImage,
    required this.newsTitle,
    required this.newsDate,
    required this.author,
    required this.discrption,
    required this.content,
    required this.source,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final formate = DateFormat('MMMM dd, yyyy');
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(widget.newsDate);
    } catch (e) {
      dateTime = DateTime.now();
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 14, 54, 87),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'News Details',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: width * 0.045,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image with Parallax Effect
            Container(
              height: height * 0.5,
              width: width,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.newsImage.isNotEmpty ? widget.newsImage : '',
                    fit: BoxFit.cover,
                    width: width,
                    height: height * 0.5,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color.fromARGB(255, 14, 54, 87),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.newspaper, size: 80, color: Colors.white.withOpacity(0.7)),
                          const SizedBox(height: 10),
                          Text(
                            'Image not available',
                            style: GoogleFonts.poppins(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Title overlay on image
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 14, 54, 87),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            widget.source.isNotEmpty ? widget.source : 'News',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: width * 0.03,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.newsTitle.isNotEmpty ? widget.newsTitle : 'No Title Available',
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.06,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Section
            Container(
              padding: EdgeInsets.all(width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta information card
                  Container(
                    padding: EdgeInsets.all(width * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Published Date',
                                style: GoogleFonts.poppins(
                                  fontSize: width * 0.03,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                formate.format(dateTime),
                                style: GoogleFonts.poppins(
                                  fontSize: width * 0.035,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.author.isNotEmpty && widget.author != 'null')
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Written by',
                                  style: GoogleFonts.poppins(
                                    fontSize: width * 0.03,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  widget.author,
                                  style: GoogleFonts.poppins(
                                    fontSize: width * 0.035,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: height * 0.03),
                  
                  // Description
                  if (widget.discrption.isNotEmpty && widget.discrption != 'null')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.045,
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(width * 0.04),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 14, 54, 87).withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.discrption,
                            style: GoogleFonts.poppins(
                              fontSize: width * 0.04,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  
                  SizedBox(height: height * 0.03),
                  
                  // Full Article
                  Text(
                    'Full Article',
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.045,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  Text(
                    widget.content.isNotEmpty && widget.content != 'null' 
                        ? widget.content 
                        : 'No content available for this article. Please check the source for more details.',
                    style: GoogleFonts.poppins(
                      fontSize: width * 0.04,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                    ),
                  ),
                  
                  SizedBox(height: height * 0.03),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Share feature coming soon!')),
                            );
                          },
                          icon: Icon(Icons.share, color: const Color.fromARGB(255, 14, 54, 87)),
                          label: Text(
                            'Share',
                            style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 14, 54, 87),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: height * 0.02),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Save feature coming soon!')),
                            );
                          },
                          icon: const Icon(Icons.bookmark_border, color: Colors.white),
                          label: Text(
                            'Save',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 14, 54, 87),
                            padding: EdgeInsets.symmetric(vertical: height * 0.02),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: height * 0.03),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
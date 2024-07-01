import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:youtube_explode/youtube_explode.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Downloader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final yt = YoutubeExplode();
  final downloadedVideos = <String>[];
  final watchHistory = <Video>[];

  @override
  void initState() {
    super.initState();
    checkExistingVideos();
    fetchWatchHistory();
  }

  Future<void> checkExistingVideos() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = await dir.list().toList();

    files.forEach((file) {
      if (file is File && file.path.endsWith('.mp4')) {
        downloadedVideos.add(file.path);
      }
    });
  }

  Future<void> fetchWatchHistory() async {
    // Fetch watch history from YouTube Data API
    final watchHistoryIds = ['videoId1', 'videoId2']; // Replace with actual video IDs
    watchHistory.clear();

    for (var id in watchHistoryIds) {
      final video = await yt.videos.get(id);
      watchHistory.add(video);
    }
  }

  Future<void> downloadVideo(String url) async {
    final savedDir = await getApplicationDocumentsDirectory();
    final outputPath = '${savedDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: savedDir.path,
      showNotification: true,
      onProgress: (progress) => print('Download progress: $progress%'),
    );

    FlutterDownloader.registerCallback((id, status, progress) {
      if (status == DownloadTaskStatus.complete) {
        setState(() {
          downloadedVideos.add(outputPath);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Downloader'),
      ),
      body: ListView.builder(
        itemCount: watchHistory.length,
        itemBuilder: (context, index) {
          final video = watchHistory[index];
          return ListTile(
            leading: Icon(Icons.video_library),
            title: Text(video.title),
            subtitle: Text(video.author),
            trailing: downloadedVideos.contains(video.id) ? Icon(Icons.done) : null,
            onTap: () => downloadVideo('https://www.youtube.com/watch?v=${video.id}'),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    yt.close();
    super.dispose();
  }
}

class yt_explode_log{
    // final meter_
    // final videoTimers
    @override
    Widget build(BuildContext context) {
      return ;
    } 

}

class yt_streamStateMeter {

}

class video_downloadDb {


}

import 'dart:async';
import 'dart:convert';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode/youtube_explode.dart';

class VideoDownloader {
  static const String YOUTUBE_BASE_URL = 'https://www.youtube.com/watch?v=';

  Future<bool> isVideoAlreadyDownloaded(String url) async {
    // Implement cache checking logic here
    // (e.g., access browser cache using platform-specific methods)
    // For this example, we'll assume a simple check based on filename:
    final outputDir = await getApplicationDocumentsDirectory();
    final filename = Uri.parse(url).queryParameters['v']; // Extract video ID
    final filePath = '${outputDir.path}/$filename.mp4';
    return await File(filePath).exists();
  }

  Future<String> downloadVideo(String url, {
    Function(int progress)? onProgress,
  }) async {
    if (await isVideoAlreadyDownloaded(url)) {
      print('Video already downloaded.');
      return ''; // Or return existing file path
    }

    final youtube = YoutubeExplode();
    final videoInfo = await youtube.videos.get(url);

    final outputDir = await getApplicationDocumentsDirectory();
    final filename = '${videoInfo.id}.mp4';
    final filePath = '${outputDir.path}/$filename';

    final savedDir = await Directory(outputDir.path).create(recursive: true);
    final taskId = await FlutterDownloader.enqueue(
      url: videoInfo.progressiveDownloadUrl,
      savedDir: savedDir.path,
      fileName: filename,
      showNotification: true, // Optional notification
      onProgress: onProgress, // Optional progress callback
    );

    return filePath;
  }
}

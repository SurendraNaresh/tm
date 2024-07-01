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

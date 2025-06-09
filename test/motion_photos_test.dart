import 'dart:io';

import 'package:motion_photos/motion_photos.dart';
import 'package:motion_photos/src/boyermoore_search.dart';
import 'package:motion_photos/src/constants.dart';
import 'package:test/test.dart';

void main() {
  group('isMotionPhoto', () {
    test('JPEG MotionPhoto', () {
      final motionPhotos = MotionPhotos(File('assets/motionphoto.jpg').readAsBytesSync());
      expect(motionPhotos.isMotionPhoto(), true);
    });

    test('HEIF MotionPhoto', () {
      final motionPhotos = MotionPhotos(File('assets/motionphoto.heic').readAsBytesSync());
      expect(motionPhotos.isMotionPhoto(), true);
    });

    //  https://github.com/ente-io/photos-app/issues/1551
    test('Pixel 6 Top shot', () {
      final motionPhotos = MotionPhotos(File('assets/pixel_6_small_video.jpg').readAsBytesSync());
      expect(motionPhotos.isMotionPhoto(), true);
    });

    test('Not a MotionPhoto', () {
      final motionPhotos = MotionPhotos(File('assets/normalphoto.jpg').readAsBytesSync());
      expect(motionPhotos.isMotionPhoto(), false);
    });

    test('Not a MotionPhoto (Pixel8)', () {
      final motionPhotos = MotionPhotos(File('assets/pixel_8.jpg').readAsBytesSync());
      expect(motionPhotos.isMotionPhoto(), false);
    });
  });

  group('getVideoIndex', () {
    test('JPEG MotionPhoto', () {
      final motionPhotos = MotionPhotos(File('assets/motionphoto.jpg').readAsBytesSync());
      final actualResult = motionPhotos.getMotionVideoIndex();
      const expectedResult = VideoIndex(start: 3366251, end: 8013982);
      expect(actualResult!, expectedResult);
    });

    test('HEIF MotionPhoto', () {
      final motionPhotos = MotionPhotos(File('assets/motionphoto.heic').readAsBytesSync());
      final actualResult = motionPhotos.getMotionVideoIndex();
      const expectedResult = VideoIndex(start: 1455411, end: 3649069);
      expect(actualResult!, expectedResult);
    });

    test('Not a motion photo_pixel', () {
      final motionPhotos = MotionPhotos(File('assets/normalphoto.jpg').readAsBytesSync());
      final actualResult = motionPhotos.getMotionVideoIndex();
      expect(actualResult == null, true);
    });
  });

  group('getMotionVideo', () {
    test('JPEG MotionPhoto', () {
      final motionPhotos = MotionPhotos(File('assets/motionphoto.jpg').readAsBytesSync());
      final videoBuffer = motionPhotos.getMotionVideo()!;
      final hasVideoContent = boyerMooreSearch(videoBuffer, MotionPhotoConstants.mp4HeaderPattern) != -1;
      expect(hasVideoContent, true);
    });

    test('HEIF MotionPhoto', () {
      final motionPhotos = MotionPhotos(File('assets/motionphoto.heic').readAsBytesSync());
      final videoBuffer = motionPhotos.getMotionVideo()!;
      final hasVideoContent = boyerMooreSearch(videoBuffer, MotionPhotoConstants.mp4HeaderPattern) != -1;
      expect(hasVideoContent, true);
    });
  });
}

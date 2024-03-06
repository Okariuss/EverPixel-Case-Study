# EverPixel-Case-Study

## Overview

EverPixel-Case-Study is a Flutter-based mobile application that mimics fundamental functionalities of the PixVibe App. It's crafted using the MVVM architecture, focusing on providing users with basic image processing capabilities. The app allows users to select images from their gallery or capture new ones using the camera, apply various edits like tuning and filters, and either save them to the gallery or share them directly.

## Features

- **Image Selection**: Users can choose an existing image from the gallery or capture a new one using the camera.
- **Tune Image**: Modify image properties such as contrast, saturation, and brightness using the `adjustColor` function from the image package.
- **Apply Filters**: Users can apply different filters to their images, like grayscale, sepia, sketch, pixelate, and monochrome.
- **Edit History**: Support for undoing and redoing edits, allowing users to navigate back and forth in their edit history.
- **Save**: The processed images can be saved to the gallery.

## Technology Stack

- Flutter for cross-platform app development.
- MVVM architecture for scalable and maintainable code.
- Various Flutter packages such as `kartal`, `equatable`, `easy_localization`, `image`, `image_picker`, `photo_manager`, `permission_handler`, and `provider` for state management and utility functions.

## Installation

To get this project up and running on your local machine, follow these steps:

```bash
git clone https://github.com/Okariuss/EverPixel-Case-Study.git
cd EverPixel-Case-Study
flutter pub get
flutter run
```
Ensure you have Flutter installed and set up on your machine, and your environment is configured for the platform you intend to run the app on (iOS/Android).

## Usage

Upon launching the app, you'll be greeted with a simple landing page featuring two buttons:

- One to pick an image from the gallery.
- Another to capture an image using the camera.
- 
After selecting or capturing an image, you can:

- Tune the image (adjust contrast, saturation, brightness).
- Apply various filters (grayscale, sepia, sketch, pixelate, and monochrome).
- Save it to the gallery.



https://github.com/Okariuss/EverPixel-Case-Study/assets/73099263/3a3c33ee-10bf-4231-b60b-9f6501410a5b




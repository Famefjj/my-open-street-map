# my_open_street_map

Custom map library, developed using the Flutter_map library, is designed to display, mark, and track vehicles in a web application.

## Flutter dependencies

you must install all of following library :

- [latlong2](https://pub.dev/packages/latlong2/install)
- [flutter_svg](https://pub.dev/packages/flutter_svg/install)
- [url_launcher](https://pub.dev/packages/url_launcher/install)
- [flutter_map_cancellable_tile_provider](https://pub.dev/packages/flutter_map_cancellable_tile_provider/install)

## How to use

1. create your flutter project
2. Install all of above dependencies.
3. Clone this repository to your projects using 'git clone ..'.
4. inside your project, add following codes to your dependencies inside pubspec.yaml

```yaml
my_open_street_map:
  path: { path to my_open_street_map project }
```

5. import library to your project by following :

```dart
import 'package:my_open_street_map/my_open_street_map.dart';
```

6. import these additional libraries as need

```dart
//==== you must import this yourself =====//
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_open_street_map/models/map_pos_notifier_model.dart';
//========================================//
```

## Demonstration

![til](./assets/Animation.gif)

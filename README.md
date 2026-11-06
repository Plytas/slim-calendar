# Slim Calendar

A small menu bar calendar for macOS: month grid, ISO week numbers, weekends in red.

## Build

Requires Xcode 26 and [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`).

```sh
xcodegen          # generate SlimCalendar.xcodeproj from project.yml
open SlimCalendar.xcodeproj
./install.sh      # build Release, copy to /Applications, relaunch
```

Run the tests:

```sh
xcodebuild test -project SlimCalendar.xcodeproj -scheme SlimCalendar
```

## Layout

- `SlimCalendar/App` – app entry point
- `SlimCalendar/Model` – `Clock` (current date) and `MonthGrid` (date logic, unit tested)
- `SlimCalendar/Views` – SwiftUI views
- `SlimCalendar/Support` – menu bar icon, launch at login
- `AppIcon.icon` – Icon Composer icon (open in Icon Composer to edit)
- `project.yml` – XcodeGen spec; the `.xcodeproj` is generated and not committed

## License

MIT

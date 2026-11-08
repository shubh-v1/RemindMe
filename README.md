# RemindMe

RemindMe is a small macOS menu bar app that counts down days. Set a number, and it shows up in the menu bar as **`Rem N`**. The number goes down by one each day, so you can always see how many days are left before a deadline, a trip, or anything else.

The app has no Dock icon and no main window. Everything happens from the menu bar.

## Features

- **Countdown in the menu bar.** The current value appears as `Rem N` (white text on a dark box).
- **Set the number of days** with an input dialog.
- **Goes down once a day** at midnight.
- **Keeps your number after a restart.** The value is saved in `UserDefaults`, so it is still there after you quit and reopen the app.
- **Menu bar only.** `LSUIElement` is turned on, so the app never shows in the Dock or the app switcher.

## Requirements

- macOS 14.6 or later
- Xcode 16 or later (the test target uses Swift Testing)

## Getting started

1. Clone the repository:
   ```sh
   git clone <repo-url>
   cd RemindMe
   ```
2. Open the project in Xcode:
   ```sh
   open RemindMe.xcodeproj
   ```
3. Choose the **RemindMe** scheme and press **⌘R**.

You can also build it from the command line:

```sh
xcodebuild -project RemindMe.xcodeproj -scheme RemindMe -configuration Release build
```

When the app is running, look for `Rem 0` in the menu bar.

## Usage

Click the `Rem N` item in the menu bar to open the menu:

| Menu item     | Shortcut | What it does                                                       |
| ------------- | -------- | ------------------------------------------------------------------ |
| One           | ⌘1       | Shows `Rem 1` in a smaller box. This changes the display only and is not saved. |
| Two           | ⌘2       | Shows `Rem 2` in a smaller box. This changes the display only and is not saved. |
| Enter days    | —        | Opens a dialog where you type the number of days to count down from. |
| Quit          | ⌘Q       | Quits RemindMe.                                                    |

### Launch at login (optional)

To start RemindMe automatically, add the built app in **System Settings → General → Login Items**.

## Project structure

```
RemindMe/
├── RemindMe/
│   ├── main.swift            # Starts the app without a storyboard
│   ├── AppDelegate.swift     # Menu bar item, menu, daily timer, saving, drawing the icon
│   ├── ViewController.swift  # Leftover template code (not used)
│   ├── Assets.xcassets
│   └── RemindMe.entitlements # App Sandbox
├── RemindMeTests/            # Unit tests (Swift Testing, placeholder)
└── RemindMeUITests/          # UI tests (XCTest, placeholder)
```

## How it works

- `main.swift` creates `NSApplication` and attaches `AppDelegate` directly, so the app does not use a storyboard.
- On launch, `AppDelegate` reads `storedNumber` from `UserDefaults` and creates an `NSStatusItem`. It then draws the icon with `numberRectangleImage(number:size:)`.
- `scheduleDailyDecrement()` starts a `Timer` that first fires at the next midnight. Each time it fires, the number goes down by one and is saved.

## Known limitations

- **Days missed while the app is closed are not counted.** The countdown only moves while the app is running.
- **After the first midnight, the timer does not repeat every 24 hours.** It repeats at the interval between launch time and midnight. A fix is to schedule a single timer for midnight and then schedule the next one each day, or to work out the remaining days from a saved target date.
- **"Enter days" does not update the value the timer uses.** The new number is saved, but `storedNumber` is not updated, so the next daily step starts from the old value until you restart the app.
- **The number can go below zero.** There is no alert when the countdown reaches 0.

## License

No license has been specified yet.

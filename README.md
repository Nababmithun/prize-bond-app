🎯 Prize Bond Checker App – Flutter (MVVM + EasyLocalization)
📘 Overview

The Prize Bond Checker App is a Flutter-based application that allows users to:

View all prize bond draws.

Check detailed draw results.

See their winning results dynamically.

Switch between English and Bangla languages.

Get an elegant, modern UI with gradient themes and responsive design.

The project follows MVVM architecture and supports EasyLocalization for multilingual support.

🏗️ Project Structure
lib/
┣ core/
┃ ┣ theme/app_theme.dart
┃ ┗ utils/app_routes.dart
┣ data/
┃ ┗ repositories/
┣ viewmodels/
┃ ┣ bond_view_model.dart
┃ ┣ auth_view_model.dart
┃ ┗ settings_view_model.dart
┣ views/
┃ ┣ home/
┃ ┣ draw/
┃ ┃ ┣ DrawListView.dart
┃ ┃ ┣ DrawDetailView.dart
┃ ┃ ┗ WinningResultView.dart
┃ ┗ splash/
┃    ┗ SplashView.dart
┣ main.dart

🌍 Localization Setup
🧩 Add Translation Files
assets/
┗ translations/
┣ en.json
┗ bn.json

Example: en.json
{
"home": {
"title": "Prize Bond Checker",
"info": "Prize bond info",
"support": "Support"
},
"draw": {
"title": "Prize Bond Draw",
"no": "Draw No",
"date": "Date",
"check": "Check My Bonds",
"last_update": "Last update: {{0}}",
"no_short": "Draw {{0}}",
"selected": "Draw {{0}}"
},
"draw_detail": {
"draw_no_title": "Draw no {{0}}",
"date_title": "Date: {{0}}",
"series": "Series",
"first_prize": "1st Prize",
"second_prize": "2nd Prize",
"third_prize": "3rd Prize"
},
"congrats": {
"title": "Congratulations",
"youwin": "You Won",
"refresh": "Refresh",
"first_prize": "1st Prize"
},
"common": {
"last_update": "Last update: {{0}}"
}
}

Example: bn.json
{
"home": {
"title": "প্রাইজ বন্ড চেকার",
"info": "পুরস্কার বন্ড তথ্য",
"support": "সমর্থন"
},
"draw": {
"title": "প্রাইজ বন্ড ড্র",
"no": "ড্র নম্বর",
"date": "তারিখ",
"check": "আমার বন্ড চেক করুন",
"last_update": "সর্বশেষ আপডেট: {{0}}",
"no_short": "ড্র {{0}}",
"selected": "ড্র {{0}}"
},
"draw_detail": {
"draw_no_title": "ড্র নম্বর {{0}}",
"date_title": "তারিখ: {{0}}",
"series": "সিরিজ",
"first_prize": "প্রথম পুরস্কার",
"second_prize": "দ্বিতীয় পুরস্কার",
"third_prize": "তৃতীয় পুরস্কার"
},
"congrats": {
"title": "অভিনন্দন",
"youwin": "আপনি জিতেছেন",
"refresh": "রিফ্রেশ",
"first_prize": "প্রথম পুরস্কার"
},
"common": {
"last_update": "সর্বশেষ আপডেট: {{0}}"
}
}

🧠 Features
Feature	Description
🌐 EasyLocalization	Supports English ↔ Bangla with .tr()
🎨 AppTheme	Custom color palette (green-based gradient)
🧩 MVVM Pattern	Separate ViewModels for logic handling
📜 Draw List View	Displays available draw numbers and dates
📊 Draw Detail View	Shows draw-wise results with series and prizes
🏆 Winning Result View	Displays user’s winning bonds and draw info
⚙️ Dynamic UI	Soft gradients, rounded cards, smooth shadows
🔄 Refresh System	Manual refresh button for latest data
🚀 Scalable Codebase	Modular files for easier API integration
⚙️ How to Run
Step 1. Install dependencies
flutter pub get

Step 2. Run localization generation (if using codegen)
flutter pub run easy_localization:generate -S assets/translations -f json -o locale_keys.g.dart

Step 3. Run App
flutter run


Step-1: টার্মিনাল খুলে JKS ফাইল তৈরি করো

Windows / macOS / Linux সব জায়গায় একই কমান্ড কাজ করে:
keytool -genkey -v -keystore ~/bond_notifier_keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias bondnotifier

ব্যাখ্যা:
~/bond_notifier_keystore.jks → তোমার keystore ফাইল কোথায় সংরক্ষণ হবে (তুমি চাইলে অন্য জায়গাও দিতে পারো)
-alias bondnotifier → key alias (এইটা তোমার সাইনিং কনফিগে ব্যবহার হবে)
-validity 10000 → ১০,০০০ দিন (প্রায় ২৭ বছর) পর্যন্ত বৈধ থাকবে

💡 কমান্ড দিলে এটি তোমাকে নিচের মতো ইনফো চাইবে:

Enter keystore password: ********
Re-enter new password: ********
What is your first and last name?  [Unknown]: Md Mahadi Hasan
What is the name of your organizational unit?  [Unknown]: TSS
What is the name of your organization?  [Unknown]: TSS Technologies
What is the name of your City or Locality?  [Unknown]: Dhaka
What is the name of your State or Province?  [Unknown]: Dhaka
What is the two-letter country code for this unit?  [Unknown]: BD
Is CN=Md Mahadi Hasan, OU=TSS, O=TSS Technologies, L=Dhaka, ST=Dhaka, C=BD correct?  [no]: yes

শেষে এটা bond_notifier_keystore.jks ফাইল তৈরি করবে।

🧩 Step-2: Keystore ফাইলটি প্রজেক্টে রাখো
 Flutter প্রজেক্টের android/app/ ফোল্ডারে .jks ফাইলটি কপি করো:

android/
└── app/
├── build.gradle.kts
├── google-services.json
├── bond_notifier_keystore.jks  ✅

🧩 Step-3: key.properties ফাইল তৈরি করো
android/ ফোল্ডারে একটি নতুন ফাইল তৈরি করো key.properties নামে:

storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=bondnotifier
storeFile=app/bond_notifier_keystore.jks

🧩 Step-4: android/app/build.gradle.kts-এ সাইনিং কনফিগ যোগ করো
 build.gradle.kts ফাইলে নিচের অংশ যোগ করো (defaultConfig এর উপরে, buildTypes এর নিচে নয়):

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = java.util.Properties()
if (keystorePropertiesFile.exists()) {
keystoreProperties.load(java.io.FileInputStream(keystorePropertiesFile))
}

android {
...

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

🧩 Step-5: রিলিজ APK বানাও

টার্মিনালে নিচের কমান্ড চালাও:

flutter clean
flutter pub get
flutter build apk --release


➡ তোমার রিলিজ ফাইল থাকবে:
build/app/outputs/flutter-apk/app-release.apk

🧩 Step-6 (Optional): AppBundle (.aab) বানাতে
Google Play Store-এর জন্য .aab দরকার হয়:
flutter build appbundle --release
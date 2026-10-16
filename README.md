# Амттай — хоол захиалгын апп

Монгол хэлтэй хоол захиалгын апп. iPhone хувилбар нь SwiftUI, Android хувилбар нь Kotlin болон Jetpack Compose ашиглана.

## Боломжууд

- Хоолны цэсийг ангиллаар шүүх, нэр болон тайлбараар хайх
- Хоолыг дуртайд хадгалах
- Сагсанд нэмэх, тоо ширхэгийг өөрчлөх, нийт үнийг харах
- Захиалгыг баталгаажуулах

## Ажиллуулах

### iPhone

`FoodOrderApp.xcodeproj` файлыг macOS дээр Xcode ашиглан нээж, iPhone Simulator эсвэл төхөөрөмж дээр ажиллуулна. Төслийн deployment target нь iOS 17.0.

GitHub Actions нь iOS Simulator build-ийг macOS runner дээр төслийн файлууд өөрчлөгдөх бүрд, pull request бүрд, эсвэл Actions табаас гараар ажиллуулна. Амжилттай build-ийн `FoodOrderApp-ios-simulator` artifact-ийг workflow run-оос татаж авна. Энэ artifact нь Simulator апп бөгөөд төхөөрөмжид суулгах signed IPA биш.

### Android

`C:\lesson` хавтсыг Android Studio дээр нээж, Gradle синк хийсний дараа `app` тохиргоог Android эмулятор эсвэл төхөөрөмж дээр ажиллуулна. Android хувилбар нь Android SDK 35 болон JDK 17 ашиглана.

Энэ эхний хувилбарууд нь жишээ цэс, UI төлөв ашиглана; бодит төлбөр, хүргэлтийн API болон өгөгдөл хадгалалт холбоогүй.

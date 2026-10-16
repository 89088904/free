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

### TestFlight

Төхөөрөмж дээр тестлэх signed IPA-г `.github/workflows/ios-testflight.yml` workflow-оор гараар build хийж TestFlight-д байршуулна. Үүнд `mn.amtai.foodorder` bundle ID-тай App Store Connect app, идэвхтэй App Store provisioning profile, болон Apple Distribution сертификат шаардлагатай. GitHub repository-ийн Actions хэсэгт дараах тохиргоог нууцлалтайгаар оруулна:

- Repository variables: `APPLE_TEAM_ID`, `APPSTORE_ISSUER_ID`, `APPSTORE_API_KEY_ID`
- Repository secrets: `APPSTORE_API_PRIVATE_KEY`, `APPSTORE_CERTIFICATES_FILE_BASE64`, `APPSTORE_CERTIFICATES_PASSWORD`

Эдгээрийг тохируулсны дараа Actions → **iOS TestFlight** → **Run workflow** гэж ажиллуулна. App Store Connect build-ийг боловсруулж дууссаны дараа TestFlight-аар iPhone-д суулгана. Signed IPA нь workflow run-ийн `FoodOrderApp-iphone-signed` artifact хэлбэрээр мөн хадгалагдана. Нууц түлхүүр, сертификатыг эх код эсвэл чатад бүү оруул.

### Android

`C:\lesson` хавтсыг Android Studio дээр нээж, Gradle синк хийсний дараа `app` тохиргоог Android эмулятор эсвэл төхөөрөмж дээр ажиллуулна. Android хувилбар нь Android SDK 35 болон JDK 17 ашиглана.

Энэ эхний хувилбарууд нь жишээ цэс, UI төлөв ашиглана; бодит төлбөр, хүргэлтийн API болон өгөгдөл хадгалалт холбоогүй.

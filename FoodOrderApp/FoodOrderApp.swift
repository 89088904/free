import SwiftUI

@main
struct FoodOrderApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

private enum FoodCategory: String, CaseIterable, Identifiable {
    case all = "Бүгд"
    case burger = "Бургер"
    case pizza = "Пицца"
    case salad = "Салат"
    case drink = "Ундаа"

    var id: String { rawValue }
}

private struct FoodItem: Identifiable {
    let id: String
    let name: String
    let description: String
    let price: Int
    let category: FoodCategory
    let emoji: String
    let tint: Color

    static let menu: [FoodItem] = [
        FoodItem(
            id: "classic-burger",
            name: "Классик бургер",
            description: "Үхрийн мах, чеддар бяслаг",
            price: 18900,
            category: .burger,
            emoji: "🍔",
            tint: Color(hex: 0xFFF0DA)
        ),
        FoodItem(
            id: "pepperoni-pizza",
            name: "Пепперони пицца",
            description: "Моцарелла, пепперони",
            price: 26900,
            category: .pizza,
            emoji: "🍕",
            tint: Color(hex: 0xFCE9DD)
        ),
        FoodItem(
            id: "avocado-salad",
            name: "Авокадотой салат",
            description: "Шинэхэн ногоо, авокадо",
            price: 15900,
            category: .salad,
            emoji: "🥗",
            tint: Color(hex: 0xE7F2E3)
        ),
        FoodItem(
            id: "iced-coffee",
            name: "Мөстэй кофе",
            description: "Зөөлөн сүүтэй кофе",
            price: 8900,
            category: .drink,
            emoji: "🧋",
            tint: Color(hex: 0xEFE7E2)
        ),
        FoodItem(
            id: "double-cheese",
            name: "Дабл чизбургер",
            description: "Давхар мах, чеддар бяслаг",
            price: 22900,
            category: .burger,
            emoji: "🍔",
            tint: Color(hex: 0xFFF0DA)
        ),
        FoodItem(
            id: "margherita-pizza",
            name: "Маргарита пицца",
            description: "Улаан лооль, базилик",
            price: 23900,
            category: .pizza,
            emoji: "🍕",
            tint: Color(hex: 0xFCE9DD)
        )
    ]
}

private enum AppTab: String, CaseIterable {
    case home = "Нүүр"
    case favorites = "Дуртай"
    case cart = "Сагс"

    var symbol: String {
        switch self {
        case .home: "house.fill"
        case .favorites: "heart"
        case .cart: "bag"
        }
    }
}

private struct HomeView: View {
    @State private var selectedTab: AppTab = .home
    @State private var selectedCategory: FoodCategory = .all
    @State private var searchText = ""
    @State private var quantities: [String: Int] = [:]
    @State private var favorites: Set<String> = []
    @State private var isCartPresented = false
    @State private var showOrderPlaced = false

    private var visibleItems: [FoodItem] {
        FoodItem.menu.filter { item in
            let matchesCategory = selectedCategory == .all || item.category == selectedCategory
            let matchesSearch = searchText.isEmpty
                || item.name.localizedCaseInsensitiveContains(searchText)
                || item.description.localizedCaseInsensitiveContains(searchText)
            let matchesTab = selectedTab != .favorites || favorites.contains(item.id)
            return matchesCategory && matchesSearch && matchesTab
        }
    }

    private var cartCount: Int {
        quantities.values.reduce(0, +)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 25) {
                    header
                    searchField

                    if selectedTab == .home {
                        promotionCard
                    }

                    categoryPicker
                    menuSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 24)
            }

            bottomBar
        }
        .background(Color(hex: 0xFAF9F6))
        .preferredColorScheme(.light)
        .sheet(isPresented: $isCartPresented) {
            CartView(items: FoodItem.menu, quantities: $quantities) {
                quantities.removeAll()
                isCartPresented = false
                showOrderPlaced = true
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .alert("Захиалга амжилттай!", isPresented: $showOrderPlaced) {
            Button("Баярлалаа", role: .cancel) { }
        } message: {
            Text("Таны хоол удахгүй хүргэгдэх болно.")
        }
        .onChange(of: selectedTab) { _, tab in
            if tab == .cart {
                isCartPresented = true
                selectedTab = .home
            }
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Хүргэх хаяг")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color(hex: 0x858585))

                HStack(spacing: 5) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundStyle(Color(hex: 0xF15A3B))
                    Text("Улаанбаатар хот")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(hex: 0x242424))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color(hex: 0x777777))
                }
            }

            Spacer()

            Button {
                isCartPresented = true
            } label: {
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white)
                        .frame(width: 48, height: 48)
                        .overlay {
                            Image(systemName: "bag")
                                .font(.system(size: 19, weight: .medium))
                                .foregroundStyle(Color(hex: 0x262626))
                        }

                    if cartCount > 0 {
                        Text("\(cartCount)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(minWidth: 18, minHeight: 18)
                            .background(Color(hex: 0xF15A3B), in: Circle())
                            .offset(x: 4, y: -4)
                    }
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Сагс, \(cartCount) бараа")
        }
    }

    private var searchField: some View {
        HStack(spacing: 11) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color(hex: 0x8A8A8A))
            TextField("Хоол хайх...", text: $searchText)
                .font(.system(size: 15))
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
    }

    private var promotionCard: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 10) {
                Text("ӨНӨӨДӨРТӨӨ")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1)
                    .foregroundStyle(.white.opacity(0.8))
                Text("Амттай хоол,\nаз жаргалтай өдөр")
                    .font(.system(size: 21, weight: .bold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                Text("Хүргэлт үнэгүй")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(.white.opacity(0.2), in: Capsule())
            }

            Spacer(minLength: 0)

            Text("🍱")
                .font(.system(size: 69))
                .rotationEffect(.degrees(-8))
                .accessibilityHidden(true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Color(hex: 0xF47A45), Color(hex: 0xEE503D)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 23)
        )
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(FoodCategory.allCases) { category in
                    let isSelected = selectedCategory == category
                    Button {
                        selectedCategory = category
                    } label: {
                        Text(category.rawValue)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(isSelected ? .white : Color(hex: 0x686868))
                            .padding(.horizontal, 17)
                            .padding(.vertical, 11)
                            .background(
                                isSelected ? Color(hex: 0xF15A3B) : .white,
                                in: Capsule()
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .contentMargins(.trailing, 20)
        .padding(.trailing, -20)
    }

    private var menuSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(selectedTab == .favorites ? "Дуртай хоолнууд" : "Алдартай хоолнууд")
                    .font(.system(size: 19, weight: .bold))
                    .foregroundStyle(Color(hex: 0x242424))
                Spacer()
                Button("Бүгд") {
                    selectedCategory = .all
                    selectedTab = .home
                }
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(hex: 0xF15A3B))
            }

            if visibleItems.isEmpty {
                ContentUnavailableView(
                    selectedTab == .favorites ? "Дуртай хоол алга" : "Хоол олдсонгүй",
                    systemImage: selectedTab == .favorites ? "heart" : "magnifyingglass",
                    description: Text(selectedTab == .favorites
                                      ? "Таалагдсан хоолнуудаа зүрх дээр дарж хадгалаарай."
                                      : "Хайлтын үгээ эсвэл ангиллаа өөрчилж үзээрэй.")
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            } else {
                LazyVGrid(
                    columns: [GridItem(.flexible(), spacing: 13), GridItem(.flexible(), spacing: 13)],
                    spacing: 13
                ) {
                    ForEach(visibleItems) { item in
                        FoodCard(
                            item: item,
                            quantity: quantities[item.id, default: 0],
                            isFavorite: favorites.contains(item.id),
                            onAdd: { quantities[item.id, default: 0] += 1 },
                            onFavorite: { toggleFavorite(item.id) }
                        )
                    }
                }
            }
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: tab.symbol)
                            .font(.system(size: 19, weight: .semibold))
                        Text(tab.rawValue)
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundStyle(selectedTab == tab ? Color(hex: 0xF15A3B) : Color(hex: 0x929292))
                    .frame(maxWidth: .infinity)
                    .frame(height: 57)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 8)
        .background(.white)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color(hex: 0xEEEEEE))
                .frame(height: 1)
        }
    }

    private func toggleFavorite(_ id: String) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
    }
}

private struct FoodCard: View {
    let item: FoodItem
    let quantity: Int
    let isFavorite: Bool
    let onAdd: () -> Void
    let onFavorite: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 17)
                    .fill(item.tint)
                    .frame(height: 116)
                    .overlay {
                        Text(item.emoji)
                            .font(.system(size: 59))
                            .accessibilityHidden(true)
                    }

                Button(action: onFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(isFavorite ? Color(hex: 0xF15A3B) : Color(hex: 0x555555))
                        .frame(width: 32, height: 32)
                        .background(.white.opacity(0.93), in: Circle())
                }
                .buttonStyle(.plain)
                .padding(8)
                .accessibilityLabel(isFavorite ? "Дуртайгаас хасах" : "Дуртайд нэмэх")
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color(hex: 0x292929))
                    .lineLimit(1)

                Text(item.description)
                    .font(.system(size: 11))
                    .foregroundStyle(Color(hex: 0x858585))
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Text("\(item.price.formatted()) ₮")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color(hex: 0xF15A3B))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Spacer(minLength: 2)

                    Button(action: onAdd) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 29, height: 29)
                            .background(Color(hex: 0xF15A3B), in: RoundedRectangle(cornerRadius: 10))
                            .overlay(alignment: .topTrailing) {
                                if quantity > 0 {
                                    Text("\(quantity)")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundStyle(.white)
                                        .frame(width: 15, height: 15)
                                        .background(Color(hex: 0x282828), in: Circle())
                                        .offset(x: 4, y: -4)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(item.name) сагсанд нэмэх")
                }
                .padding(.top, 2)
            }
        }
        .padding(9)
        .background(.white, in: RoundedRectangle(cornerRadius: 21))
    }
}

private struct CartView: View {
    let items: [FoodItem]
    @Binding var quantities: [String: Int]
    let onPlaceOrder: () -> Void

    private var cartItems: [FoodItem] {
        items.filter { quantities[$0.id, default: 0] > 0 }
    }

    private var total: Int {
        cartItems.reduce(0) { $0 + $1.price * quantities[$1.id, default: 0] }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if cartItems.isEmpty {
                    ContentUnavailableView(
                        "Таны сагс хоосон байна",
                        systemImage: "bag",
                        description: Text("Цэснээс дуртай хоолоо сонгоод сагсандаа нэмээрэй.")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(cartItems) { item in
                        HStack(spacing: 12) {
                            Text(item.emoji)
                                .font(.system(size: 34))
                                .frame(width: 56, height: 56)
                                .background(item.tint, in: RoundedRectangle(cornerRadius: 14))

                            VStack(alignment: .leading, spacing: 5) {
                                Text(item.name)
                                    .font(.system(size: 15, weight: .semibold))
                                Text("\(item.price.formatted()) ₮")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(Color(hex: 0xF15A3B))
                            }

                            Spacer()

                            HStack(spacing: 12) {
                                quantityButton(symbol: "minus") {
                                    let next = quantities[item.id, default: 0] - 1
                                    if next > 0 {
                                        quantities[item.id] = next
                                    } else {
                                        quantities.removeValue(forKey: item.id)
                                    }
                                }
                                Text("\(quantities[item.id, default: 0])")
                                    .font(.system(size: 14, weight: .semibold))
                                    .monospacedDigit()
                                quantityButton(symbol: "plus") {
                                    quantities[item.id, default: 0] += 1
                                }
                            }
                        }
                        .padding(.vertical, 5)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)

                    VStack(spacing: 14) {
                        HStack {
                            Text("Нийт төлбөр")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(Color(hex: 0x686868))
                            Spacer()
                            Text("\(total.formatted()) ₮")
                                .font(.system(size: 19, weight: .bold))
                                .foregroundStyle(Color(hex: 0x242424))
                        }

                        Button(action: onPlaceOrder) {
                            Text("Захиалга өгөх")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color(hex: 0xF15A3B), in: RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    .padding(20)
                    .background(.white)
                }
            }
            .background(Color(hex: 0xFAF9F6))
            .navigationTitle("Миний сагс")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func quantityButton(symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(Color(hex: 0xF15A3B))
                .frame(width: 28, height: 28)
                .background(Color(hex: 0xFFF0EC), in: Circle())
        }
        .buttonStyle(.plain)
    }
}

private extension Color {
    init(hex: UInt) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}

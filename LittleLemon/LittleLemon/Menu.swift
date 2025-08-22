//
//  Menu.swift
//  Little Lemon
//
//  Created by 化石星星的橡木盾 on 8/3/25.
//

import SwiftUI
import CoreData

enum MenuCategory: String, CaseIterable, Identifiable {
    case starters = "Starters"
    case mains = "Mains"
    case desserts = "Desserts"
    case drinks = "Drinks"
    
    var id: String { rawValue }
    
    var title: String { rawValue }
}

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    init() {}
    
    @State private var searchText = ""
    @State private var selectedCategory: MenuCategory? = nil
    
    var body: some View {
        VStack {
            TopBar()
            VStack(alignment: .leading, spacing: 0) {
                Text("Little Lemon")
                    .appFont(.display)
                    .foregroundColor(.primary2)
                
                HeroView()
                SearchToggleRow(text: $searchText)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(Color("Primary 1"))
            .frame(maxWidth: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)
            
            CategoryBar(selected: $selectedCategory)
            
            FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                MenuListView(dishes: dishes )
            }
        }
        .task { try? await getMenuDataIfNeeded() }
    }
    
    func getMenuDataIfNeeded() async throws {
        let fetch: NSFetchRequest<NSFetchRequestResult> = Dish.fetchRequest()
        fetch.fetchLimit = 1
        let count = try viewContext.count(for: fetch)
        guard count == 0 else { return }
        try await getMenuData()
    }
    
    func getMenuData() async throws {
        PersistenceController.shared.clear()
        
        let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json")
        guard let url = url else {
            throw NSError()
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                do {
                    let menuList = try JSONDecoder().decode(MenuList.self, from: data)
                    viewContext.perform {
                        for item in menuList.menu {
                            let dish = Dish(context: viewContext)
                            dish.title = item.title
                            dish.image = item.image
                            dish.price = Double(item.price) ?? 0
                            dish.dishDescription = item.description
                            dish.category = item.category
                        }
                        try? viewContext.save()
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return
            [NSSortDescriptor(
                key: "title",
                ascending: true,
                selector: #selector(NSString.localizedStandardCompare)
            )]
    }
    
    func buildPredicate() -> NSPredicate {
        var subs: [NSPredicate] = []
        
        if !searchText.isEmpty {
            subs.append(NSPredicate(format: "title CONTAINS[cd] %@ OR dishDescription CONTAINS[cd] %@", searchText,searchText))
        }
        
        if let cat = selectedCategory {
            subs.append(NSPredicate(format: "category ==[c] %@", cat.rawValue))
        }
        
        
        if subs.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: subs)
        }
    }
    
}

private struct CategoryBar: View {
    @Binding var selected: MenuCategory?
    var categories: [MenuCategory] = MenuCategory.allCases
    
    var body: some View {
        Text("ORDER FOR DELIVERY!")
            .font(.custom("Karla-Extrabold", size: 24))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        HStack(spacing: 12) {
            ForEach(categories) { cat in
                Button {
                    selected = (selected == cat) ? nil : cat
                } label: {
                    Text(cat.title)
                        .appFont(.categories)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 14)
                        .background(
                            Capsule()
                                .fill(selected == cat ? Color("Primary 2") : Color("Secondary 3"))
                        )
                        .foregroundColor(selected == cat ? Color("Primary 1") : Color("Secondary 4"))
                }
            }
        }
        .padding(.vertical, 0)
    }
}

struct TopBar: View {
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 28)
                Spacer()
            }
            .padding(.horizontal, 16)
            HStack {
                Spacer()
                Image("Profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    .padding(.trailing, 16)
                    .clipped()
            }
            .padding(.trailing, 16)
        }
        .padding(.top, 8)
    }
}

struct HeroView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Chicago")
                    .appFont(.markazi40)
                    .foregroundColor(.secondary3)
                
                Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                    .appFont(.lead)
                    .foregroundColor(.secondary3)
                    .appParagraphMaxWidth()
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
            }
            .layoutPriority(1)
            
            Image("Hero image")
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal, 0)
    }
}

private struct MenuListView: View {
    let dishes: [Dish]
    
    var body: some View {
            List {
                ForEach(dishes, id: \.objectID) { dish in
                    DishRow(dish: dish)
                }
            }
            .listStyle(.plain)
            //.scrollContentBackground(.visible)
    }
}


private struct DishRow: View {
    let dish: Dish
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 6) {

            VStack(alignment: .leading, spacing: 6) {
                Text(dish.title ?? "")
                    .appFont(.cardTitle)
                
                Text(dish.dishDescription ?? "")
                    .appFont(.paragraph)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                
                Text(String(format: "$%.2f", dish.price))
                    .appFont(.priceHighlight)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if let urlStr = dish.image,
               let url = URL(string: urlStr) {
                
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Color.secondary.opacity(0.1)
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure(_):
                        Color.secondary.opacity(0.2)
                    @unknown default:
                        Color.secondary.opacity(0.1)
                    }
                }
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
    }
}

private struct SearchToggleRow: View {
    @Binding var text: String
    @State private var isSearching = false

    var placeholder = "Search menu"

    var body: some View {
        HStack(spacing: 8) {
            if isSearching {
                TextField(placeholder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.move(edge: .leading).combined(with: .opacity))
                    .layoutPriority(1)
            }

            Button {
                withAnimation(.easeInOut) {
                    isSearching.toggle()
                    if !isSearching { text = "" }
                }
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
                    .padding(10)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(radius: 1)
            }
            .accessibilityLabel("Toggle search")
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
    }
}



#Preview {
    //Menu().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    Menu()
}

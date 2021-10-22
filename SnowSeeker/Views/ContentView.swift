//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Milo Wyner on 10/16/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var favorites = Favorites()
    let originalResorts: [Resort] = Bundle.main.decode("resorts.json")
    
    enum SortType: CaseIterable {
        case `default`, alphabetical, country
    }
    
    @State private var sort = SortType.default
    @State private var filter = Resort.Filter()
    
    var resorts: [Resort] {
        var resorts = originalResorts
        
        // Sort
        switch sort {
        case .default:
            break
        case .alphabetical:
            resorts.sort(by: { $0.name < $1.name })
        case .country:
            resorts.sort(by: { $0.country < $1.country })
        }
        
        // Filter
        if let country = filter.selected["Country"]! {
            resorts = resorts.filter { resort in
                resort.country == country
            }
        }
        
        if let price = filter.selected["Price"]! {
            resorts = resorts.filter { resort in
                resort.priceString == price
            }
        }
        
        if let size = filter.selected["Size"]! {
            resorts = resorts.filter { resort in
                resort.sizeString == size
            }
        }
        
        return resorts
    }
    
    private func filterMenu(_ type: String) -> some View {
        Menu {
            ForEach(filter.types[type]!, id: \.self) { option in
                Button(action: {
                    filter.selected[type] = filter.selected[type] == option ? nil : option
                }, label: {
                    HStack {
                        Text(option)
                        if filter.selected[type] == option {
                            Image(systemName: "checkmark")
                        }
                    }
                })
            }
        } label: {
            Text(type)
            if filter.selected[type]! != nil {
                Image(systemName: "line.3.horizontal.decrease")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List(resorts) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationBarTitle("Resorts")
            .navigationBarItems(
                leading: Menu(
                    content: {
                        Picker("Sort", selection: $sort) {
                            ForEach(SortType.allCases, id: \.self) {
                                Text(String(describing: $0).capitalized)
                            }
                        }
                    },
                    label: {
                        Text("Sort")
                    }
                ),
                
                trailing: Menu("Filters") {
                    ForEach(filter.types.keys.sorted(), id: \.self) { type in
                        filterMenu(type)
                    }
                    
                    if filter.selected.values.contains(where: { $0 != nil }) {
                        let action = {
                            for key in filter.selected.keys {
                                filter.selected[key]! = nil
                            }
                        }
                        let label = { Text("Clear Filters") }
                        
                        if #available(iOS 15.0, *) {
                            Button(role: .destructive, action: action, label: label)
                        } else {
                            Button(action: action, label: label)
                        }
                    }
                }
            )
            
            WelcomeView()
        }
        .environmentObject(favorites)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 15.0, *) {
            ContentView()
                .previewInterfaceOrientation(.landscapeLeft)
        } else {
            ContentView()
        }
    }
}

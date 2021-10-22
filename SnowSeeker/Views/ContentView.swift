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
    enum FilterType: CaseIterable {
        case country, size, price
    }
    
    @State private var sort = SortType.default
    @State private var filter: FilterType?
    
    var resorts: [Resort] {
        var resorts = originalResorts
        
        switch sort {
        case .default:
            break
        case .alphabetical:
            resorts.sort(by: { $0.name < $1.name })
        case .country:
            resorts.sort(by: { $0.country < $1.country })
        }
        
        return resorts
    }
    
    private func sortButton(_ type: SortType) -> some View {
        Button(action: { sort = type }, label: {
            HStack {
                if sort == type {
                    Image(systemName: "checkmark")
                }
                Text(String(describing: type).capitalized)
            }
        })
    }
    
    private func filterButton(_ type: FilterType) -> some View {
        Button(action: {
            filter = (filter == type) ? nil : type
        }, label: {
            HStack {
                if filter == type {
                    Image(systemName: "checkmark")
                }
                Text(String(describing: type).capitalized)
            }
        })
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
                leading: Menu("Sort") {
                    ForEach(SortType.allCases, id: \.self) { sort in
                        sortButton(sort)
                    }
                },
                trailing: Menu("Filter") {
                    ForEach(FilterType.allCases, id: \.self) { filter in
                        filterButton(filter)
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

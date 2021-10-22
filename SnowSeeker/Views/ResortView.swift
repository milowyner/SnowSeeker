//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Milo Wyner on 10/16/21.
//

import SwiftUI

struct ResortView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @EnvironmentObject var favorites: Favorites
    let resort: Resort
    
    @State private var selectedFacility: Facility?
    @State private var showingImageCredit = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(decorative: resort.id)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ZStack {
                                    Rectangle()
                                        .fill(.black)
                                        .opacity(0.3)
                                    if showingImageCredit || sizeClass == .regular {
                                        Text("Photo by \(resort.imageCredit)")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .transition(
                                                .move(edge: .trailing)
                                                    .combined(with: .opacity)
                                            )
                                    } else {
                                        Image(systemName: "camera")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(8)
                                    }
                                }
                                .fixedSize(horizontal: true, vertical: true)
                                .onTapGesture {
                                    withAnimation {
                                        showingImageCredit.toggle()
                                    }
                                }
                            }
                        }
                    )

                Group {
                    HStack {
                        if sizeClass == .compact {
                            Spacer()
                            VStack { ResortDetailsView(resort: resort) }
                            Spacer()
                            VStack { SkiDetailsView(resort: resort) }
                            Spacer()
                        } else {
                            ResortDetailsView(resort: resort)
                            Spacer()
                            SkiDetailsView(resort: resort)
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top)
                    
                    Text(resort.description)
                        .padding(.vertical)

                    Text("Facilities")
                        .font(.headline)

                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            facility.icon
                                .font(.title)
                                .onTapGesture {
                                    selectedFacility = facility
                                }
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal)
                
                Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                    if favorites.contains(resort) {
                        favorites.remove(resort)
                    } else {
                        favorites.add(resort)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle(Text("\(resort.name), \(resort.country)"), displayMode: .inline)
        .alert(item: $selectedFacility) { facility in
            facility.alert
        }
    }
}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        ResortView(resort: Resort.example)
            .environmentObject(Favorites())
    }
}

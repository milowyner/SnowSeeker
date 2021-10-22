//
//  ResortDetailsView.swift
//  SnowSeeker
//
//  Created by Milo Wyner on 10/16/21.
//

import SwiftUI

struct ResortDetailsView: View {
    let resort: Resort
    
    var body: some View {
        Group {
            Text("Size: \(resort.sizeString)")
            Spacer()
            Text("Price: \(resort.priceString)")
        }
    }
}

struct ResortDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ResortDetailsView(resort: Resort.example)
    }
}

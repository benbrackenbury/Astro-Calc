//
//  RootNavigationView.swift
//  AstroCalc
//
//  Created by Ben Brackenbury on 14/04/2023.
//  Copyright © 2023 Ben Brackenbury. All rights reserved.
//

import SwiftUI

struct RootNavigationView: View {
    var body: some View {
        TabView {
            ForEach(Tab.allCases) { $0.tabItem() }
        }
    }
}

struct RootNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        RootNavigationView()
    }
}

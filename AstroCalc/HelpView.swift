//
//  HelpView.swift
//  AstroCalc
//
//  Created by Ben Brackenbury on 14/04/2023.
//  Copyright © 2023 Ben Brackenbury. All rights reserved.
//

import SwiftUI

struct HelpView<Content: View>: View {
    @Environment(\.dismiss) private var dismiss

    var content: () -> Content
    var spacing: CGFloat

    init(spacing: CGFloat = 32, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    content()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.body)
                        .foregroundStyle(.primary)
                }
                .padding()
            }
            .navigationTitle("How this works")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .bold()
                }
                .visibilityPriority(.high)
            }
            .toolbarMinimizationBehavior(.onScrollDown, for: .navigationBar)
        }
    }
}

#Preview {
    HelpView {
        Text("When taking pictures of the night sky, a maximum shutter speed exists, influenced by focal length and sensor crop factor.")

        Text("To calculate this we use the **500 Rule**:")

        VStack(spacing: 5) {
            Text("Max shutter speed =")
            Text("500 / (crop * focal length)")
                .italic()
        }
    }
}

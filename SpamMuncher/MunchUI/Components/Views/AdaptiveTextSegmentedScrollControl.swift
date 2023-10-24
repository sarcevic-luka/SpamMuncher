//
//  AdaptiveTextSegmentedScrollControl.swift
//  MunchUI
//
//  Created by Code Forge on 09.10.2023..
//

import SwiftUI

public struct AdaptiveTextSegmentedScrollControl<T>: View where T: CaseIterable, T: RawRepresentable, T.RawValue == String  {
    @Binding var selectedValue: T

    private let columns: [GridItem] = [
            GridItem(.adaptive(minimum: 34))
        ]

    public init(selectedValue: Binding<T>) {
        self._selectedValue = selectedValue
    }

    public var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: columns, alignment: .center, spacing: 5) {
                        ForEach(Array(T.allCases.enumerated()), id: \.offset) { index, value in
                            let isSelected = selectedValue == value
                            ZStack {
                                Rectangle()
                                    .fill(isSelected ? Color.baseColor : Color.primaryColor)
                                    .cornerRadius(17)
                                    .onTapGesture {
                                        withAnimation(.interactiveSpring(response: 0.2, dampingFraction: 2, blendDuration: 0.5)) {
                                            selectedValue = value
                                        }
                                    }
                                Text(value.rawValue.capitalized)
                                    .font(isSelected ? .headline : .subheadline)
                                    .foregroundColor(isSelected ? .highlightColor : .lowKeyPrimary)
                                    .lineLimit(1)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal, 8)
                                    .frame(minWidth: 100)
                            }
                        }
                    }
                    .padding(.horizontal, max(0, (geometry.size.width - CGFloat(T.allCases.count) * 108) / 2))
                }
            }
            .frame(height: 34)
        }
    }
}

struct AdaptiveTextSegmentedScrollControl_Previews: PreviewProvider {
    private enum Example: String, CaseIterable {
        case one, two, three
    }

    @State private static var selectedExample: Example = .two

    static var previews: some View {
        AdaptiveTextSegmentedScrollControl(selectedValue: $selectedExample)
    }
}

//
//  AssignmentText.swift
//  Assignment
//
//  Created by Kunal on 10/01/25.
//

import Foundation
import SwiftUI

struct AssignmentText: View {
    let text: String
    let font: Font
    
    init(text: String, font: Font? = nil) {
        self.text = text
        self.font = font ?? .headline
    }

    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(Color.black)
    }
}

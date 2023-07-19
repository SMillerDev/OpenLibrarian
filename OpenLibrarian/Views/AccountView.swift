//
//  AccountView.swift
//  OpenLibrarian
//
//  Created by Sean Molenaar on 19/07/2023.
//

import SwiftUI

struct AccountView: View {
    @AppStorage("username") var username: String?
    
    var body: some View {
        Text("Hello \(username ?? "User")")
    }
}

#Preview {
    AccountView()
}

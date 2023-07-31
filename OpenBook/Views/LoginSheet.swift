//
//  LoginSheet.swift
//  OpenBook
//
//  Created by Sean Molenaar on 18/06/2023.
//

import SwiftUI
import OpenLibraryKit

struct LoginSheet: View {
    let api: OpenLibraryKit = OpenLibraryKit()
    @State var usernameField: String = ""
    @State var passwordField: String = ""
    @AppStorage("username") var username: String?

    var body: some View {
        Form {
            Text("Login")
                .font(.title)
            TextField("Username", text: $usernameField)
                .textContentType(.username)
                .textCase(.lowercase)
            #if os(iOS)
                .textInputAutocapitalization(.never)
            #endif
            SecureField("Password", text: $passwordField)
                .textContentType(.password)
            Button("Login", action: {
                Task {
                    let username = try? await api.auth.login(user: usernameField, secret: passwordField)
                    guard let username = username else {
                        return
                    }
                    self.username = username
                }
            })
        }.padding()
        #if os(macOS)
        .frame(minWidth: 400, minHeight: 200)
        #endif
    }
}

#Preview {
    LoginSheet()
}

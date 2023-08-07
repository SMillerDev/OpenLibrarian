//
//  LoginSheet.swift
//  OpenBook
//
//  Created by Sean Molenaar on 18/06/2023.
//

import SwiftUI
import OpenLibraryKit

struct LoginSheet: View {
    let api: OpenLibraryKit = OpenLibraryKit.shared
    @State var usernameField: String = ""
    @State var passwordField: String = ""
    @State var errorText: String = ""
    @AppStorage("username") var username: String?

    var body: some View {
        Text("Login")
            .font(.title)
        Form {
            TextField("Username", text: $usernameField)
                .textContentType(.username)
                .textCase(.lowercase)
            #if os(iOS)
                .textInputAutocapitalization(.never)
            #endif
            SecureField("Password", text: $passwordField)
                .textContentType(.password)
            Text(errorText)
            Button("Login", action: {
                Task {
                    do {
                        self.username = try await api.auth.login(user: usernameField, secret: passwordField)
                    } catch {
                        errorText = "Failed to login!"
                    }
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

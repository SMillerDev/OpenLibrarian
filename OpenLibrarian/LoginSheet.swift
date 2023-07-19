//
//  LoginSheet.swift
//  OpenLibrarian
//
//  Created by Sean Molenaar on 18/06/2023.
//

import SwiftUI
import OpenLibraryKit

struct LoginSheet: View {

    @State var usernameField: String = ""
    @State var passwordField: String = ""
    @AppStorage("username") var username: String?

    var body: some View {
        Text("Login").font(.title)
        Form {
            TextField("Username", text: $usernameField)
                .textContentType(.username)
            SecureField("Password", text: $passwordField)
                .textContentType(.password)
            Button("Login", action: {
                Task {
                    let username = try? await OpenLibraryKit().auth().login(user: usernameField, secret: passwordField)
                    guard let username = username else {
                        return
                    }
                    self.username = username
                }
            })
        }
    }
}

#Preview {
    LoginSheet()
}

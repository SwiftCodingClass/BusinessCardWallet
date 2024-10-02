//
//  NameCardList.swift
//  BusinessWallet
//
//  Created by elice77 on 9/28/24.
//

import SwiftUI

struct Person: Identifiable {
    let id = UUID()
    let username: String
    let reponame: String?
}

private var persons: [Person] = [
    Person(username: "misutgaru", reponame: "stack-on-a-budget"),
    Person(username: "seunggyun-jeong", reponame: "coding-interview-university"),
    Person(username: "SallyPark9303", reponame: "SpringThymeleaf"),
    Person(username: "miramazing", reponame: nil)
]

struct NameCardList: View {
    
    var body: some View {
        NavigationView {
            List(persons) { person in
                NavigationLink {
                    NameCardView(username: person.username, reponame: person.reponame)
                } label: {
                    Text(person.username)
                }
            }
        }
    }
}

#Preview {
    NameCardList()
}

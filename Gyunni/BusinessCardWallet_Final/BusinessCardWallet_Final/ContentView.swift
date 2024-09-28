//
//  ContentView.swift
//  BusinessCardWallet_Final
//
//  Created by Gyunni on 9/27/24.
//

import SwiftUI

struct ContentView: View {
    // 사용자 리스트 정의
    let nameList = ["seunggyun-jeong": "MacC-Team16-ABloom", "M1zz": "TheFirstCommit"]

    var body: some View {
        List(nameList.keys.sorted(), id: \.self) { key in
            NavigationLink(key) {
                NameCardView(name: key, repositoryName: nameList[key, default: ""])
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}


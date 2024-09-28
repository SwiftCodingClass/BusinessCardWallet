//
//  NewCardView.swift
//  BusinessWallet
//
//  Created by elice77 on 9/28/24.
//

import SwiftUI

struct NameCardView: View {
    var username: String
    var reponame: String?
    @State var user: GitHubUser?
    
    var body: some View {
        VStack {
            // 프로필 이미지
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) {
                image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 20)
            }.frame(width: 150)
            
            // 이름
            Text(user?.name ?? "이름 없음")
                .font(.title)
                .bold()
            
            // 회사
            Text(user?.company ?? "회사 없음")
                .padding(.bottom, 20)
            
            //
            NavigationLink {
                RepoCardView(username: username, reponame: reponame)
            } label: {
                Text("View More")
                    .padding(.horizontal, 70)
                    .padding(.vertical, 10)
                    .background{
                        Capsule()
                            .foregroundStyle(.cyan)
                    }
                    .foregroundStyle(.white)
            }.padding(.bottom, 50)
            
            HStack{
                Text(user?.htmlUrl ?? "깃허브 주소 없음")
                Spacer()
            }
            
            Divider()
            
            HStack{
                Text(user?.email ?? "이메일 정보 없음")
                Spacer()
            }

        }
        .padding(.horizontal, 30)
        .task {
            self.user = try? await getUserData(username: username)
        }
    }
    
    func getUserData(username: String) async throws ->
        GitHubUser {
            guard let url=URL(string: "https://api.github.com/users/\(username)") else {
                throw URLError(.badURL)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(GitHubUser.self, from: data)
        }
}

#Preview {
    NavigationStack {
        NameCardView(username: "misutgaru")
    }
}

struct GitHubUser: Codable {
    let avatarUrl: String?
    let name: String?
    let company: String?
    let htmlUrl: String
    let email: String?
}

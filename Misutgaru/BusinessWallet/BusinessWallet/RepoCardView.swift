//
//  RepoCardView.swift
//  BusinessWallet
//
//  Created by elice77 on 9/28/24.
//

import SwiftUI

struct RepoCardView: View {
    var username: String?
    var reponame: String?
    @State var repo: GithubRepo?
    
    var body: some View {
        Text(reponame ?? "레포지토리가 없어요 :(")
        VStack {
            Text("별 개수 : \(repo?.stargazersCount ?? 0)")
            if let star = repo?.stargazersCount {
                HStack {
                    ForEach(0..<star, id: \.self) { index in
                        Text("⭐️")
                    }
                }
            }
            
            
        }.task {
            self.repo = try? await getRepoData(username: username, reponame: reponame)
        }
    }
    
    func getRepoData(username: String?, reponame: String?) async throws -> GithubRepo {
        
        guard let username = username, let reponame = reponame else {
            throw URLError(.badURL)
        }
        
        guard let url=URL(string: "https://api.github.com/repos/\(username)/\(reponame)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(GithubRepo.self, from: data)
    }
}

#Preview {
    RepoCardView(username: "misutgaru", reponame: "stack-on-a-budget")
}

struct GithubRepo: Codable {
    let stargazersCount: Int
}

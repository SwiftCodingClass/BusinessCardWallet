//
//  DetailView.swift
//  BusinessCardWallet_Final
//
//  Created by Gyunni on 9/27/24.
//

import SwiftUI

struct DetailView: View {
    @State var repository: GitHubRepository?
    let name: String
    let repositoryName: String

    var body: some View {
        VStack {
            Text(repository?.name ?? "이름 없음")
                .font(.title)
                .padding(.bottom, 10)

            Text("별 개수 : \(repository?.stargazersCount ?? 0)")

            HStack {
                if let count = repository?.stargazersCount {
                    ForEach(0..<count, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.yellow)
                            .frame(width: 30)
                    }
                }
            }

        }
        .task {
            self.repository = try? await getRepository(owner: name, repository: repositoryName)
        }
    }

    func getRepository(owner: String, repository: String) async throws -> GitHubRepository {
        guard let url = URL(string: "https://api.github.com/repos/\(owner)/\(repository)") else { throw URLError(.badURL) }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return try decoder.decode(GitHubRepository.self, from: data)
    }
}

#Preview {
    DetailView(name: "seunggyun-jeong", repositoryName: "MacC-Team16-ABloom")
}

struct GitHubRepository: Codable {
    let name: String
    let stargazersCount: Int?
}

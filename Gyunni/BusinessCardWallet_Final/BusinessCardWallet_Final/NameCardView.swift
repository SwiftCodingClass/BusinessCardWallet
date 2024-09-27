//
//  NameCardView.swift
//  BusinessCardWallet_Final
//
//  Created by Gyunni on 9/27/24.
//

import SwiftUI

struct NameCardView: View {
    @State var user: GitHubUser?
    
    let name: String
    let repositoryName: String

    var body: some View {
        VStack {
            // 프로필 이미지
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.secondary)
                    .padding(.bottom, 30)
            }
            .frame(width: 150)

            // 이름
            Text("\(user?.name ?? "이름 정보 없음")")
                .font(.title)
                .bold()

            // 회사 정보
            Text("\(user?.company ?? "회사정보 없음")")
                .padding(.bottom, 20)

            // View More
            NavigationLink {
                DetailView(name: name, repositoryName: repositoryName)
            } label: {
                Text("View More")
                    .padding(.horizontal, 70)
                    .padding(.vertical, 10)
                    .background {
                        Capsule()
                            .foregroundStyle(.cyan)
                    }
                    .foregroundStyle(.white)
                    .bold()
                    .padding(.bottom, 50)
            }

            // GitHub Page Link
            HStack {
                Text("\(user?.htmlUrl ?? "깃허브 주소 없음")")
                    .font(.body)

                Spacer()
            }
            .padding(.bottom, 10)

            Divider()
                .padding(.bottom, 10)

            // 이메일 주소
            HStack {
                Text("\(user?.email ?? "이메일 정보 없음")")
                    .font(.body)

                Spacer()
            }
        }
        .padding(.horizontal, 30)
        .task {
            self.user = try? await getUser(name: self.name)
        }
    }

    // 네트워크 통신 메서드
    func getUser(name: String) async throws -> GitHubUser {
        guard let url = URL(string: "https://api.github.com/users/\(name)") else { throw URLError(.badURL)}

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
    NameCardView(name: "seunggyun-jeong", repositoryName: "MacC-Team16-ABloom")
}

struct GitHubUser: Codable {
    let avatarUrl: String
    let name: String?
    let company: String?
    let htmlUrl: String
    let email: String?
}

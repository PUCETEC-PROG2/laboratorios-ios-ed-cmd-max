
//
//  RepoItem.swift
//  GithubClient
//
//  Created by Usuario invitado on 14/7/26.
//

import SwiftUI

struct RepoItem: View {
    
    let repository: Repository
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            
            AsyncImage(
                url: URL(string: repository.owner.avatarUrl)
            ) { phase in
                
                switch phase {
                    
                case .empty:
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                        
                        ProgressView()
                    }
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                    
                case .failure:
                    Image(uiImage: .imageNotFound)
                        .resizable()
                        .scaledToFit()
                        .padding(5)
                    
                @unknown default:
                    Image(uiImage: .imageNotFound)
                        .resizable()
                        .scaledToFit()
                        .padding(5)
                }
            }
            .frame(width: 80, height: 80)
            .background(Color.gray.opacity(0.1))
            .clipShape(Circle())
            .padding(.trailing, 10)
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(repository.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                if let description = repository.description,
                   !description.isEmpty {
                    
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                }
                
                if let language = repository.language,
                   !language.isEmpty {
                    
                    HStack {
                        Text("Lenguaje:")
                            .font(.caption)
                            .fontWeight(.semibold)
                        
                        Text(language)
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    RepoItem(
        repository: Repository(
            id: 1,
            name: "GithubClient",
            description: "Cliente GitHub desarrollado con SwiftUI",
            language: "Swift",
            owner: UserInfo(
                login: "pabloperez",
                name: "Pablo Pérez",
                avatarUrl: "Ihttps://avatars.githubusercontent.com/u/9919?v=4",
                bio: nil
            )
        )
    )
}


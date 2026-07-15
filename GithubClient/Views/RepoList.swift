//
//  RepoList.swift
//  GithubClient
//
//  Created by Usuario invitado on 10/7/26.
//

import SwiftUI

struct RepoList: View {
    private var repoList = Repository.sampleData
    
    var body: some View {
        NavigationStack {
            Group {
                List(repoList) { repo in
                    RepoItem(repository: repo)
                }
            }
            .navigationTitle("Repositorios")
        }
    }
}

#Preview {
    RepoList()
}

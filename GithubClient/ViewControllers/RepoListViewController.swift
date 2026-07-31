//
//  RepoListViewController.swift
//  GithubClient
//

import Foundation

@MainActor
final class RepoListViewController: ObservableObject {

    @Published var repositories: [Repository] = []
    @Published var isLoading: Bool = false
    @Published var errorMsg: String?

    private let githubService: GithubService

    init(service: GithubService = .shared) {
        self.githubService = service
    }

    func loadRepositories() async {
        guard !isLoading else {
            return
        }

        isLoading = true
        errorMsg = nil

        defer {
            isLoading = false
        }

        do {
            repositories = try await githubService.getRepositories()
        } catch {
            errorMsg = error.localizedDescription
        }
    }

    func insertCreatedRepository(
        _ repository: Repository
    ) {
       
        repositories.removeAll {
            $0.id == repository.id
        }

     
        repositories.insert(
            repository,
            at: 0
        )

        errorMsg = nil
    }
}

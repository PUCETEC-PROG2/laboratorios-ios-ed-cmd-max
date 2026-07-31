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

            // Ignorar cancelaciones normales de SwiftUI
            if Task.isCancelled {
                return
            }

            let nsError = error as NSError

            // Código de petición cancelada
            if nsError.code == NSURLErrorCancelled {
                return
            }

            // Mensaje de cancelación de Alamofire
            if error.localizedDescription == "Request explicitly cancelled." {
                return
            }

            // Mostrar otros errores reales
            errorMsg = error.localizedDescription
        }
    }

    func insertCreatedRepository(
        _ repository: Repository
    ) {
        // Evita tener dos veces el mismo repositorio
        repositories.removeAll {
            $0.id == repository.id
        }

        // Inserta el nuevo repositorio al inicio
        repositories.insert(
            repository,
            at: 0
        )

        errorMsg = nil
    }
}

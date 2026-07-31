//
//  RepoFormViewController.swift
//  GithubClient
//
//  Created by Usuario invitado on 24/7/26.
//

//
//  RepoFormViewController.swift
//  GithubClient
//

import Foundation

@MainActor
class RepoFormViewController: ObservableObject {

    @Published var repoName: String = ""
    @Published var repoDescription: String = ""
    @Published var isPrivate: Bool = false

    @Published var isLoading: Bool = false
    @Published var errorMsg: String = ""
    @Published var showAlert: Bool = false

    private let githubService: GithubService

    init(service: GithubService = .shared) {
        self.githubService = service
    }

    func createRepository(
        onSuccess: @escaping () -> Void
    ) {

        let cleanName = repoName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        
        guard !cleanName.isEmpty else {
            errorMsg = "El nombre del repositorio es obligatorio."
            showAlert = true
            return
        }

        isLoading = true

        githubService.createRepo(
            name: cleanName,
            description: repoDescription,
            private: isPrivate
        ) { [weak self] result in

            DispatchQueue.main.async {

                guard let self = self else {
                    return
                }

                self.isLoading = false

                switch result {

                case .success:
                    self.repoName = ""
                    self.repoDescription = ""
                    self.isPrivate = false

                    onSuccess()

                case .failure(let error):
                    self.errorMsg = error.localizedDescription
                    self.showAlert = true
                }
            }
        }
    }
}

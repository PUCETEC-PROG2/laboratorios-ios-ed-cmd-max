//
//  ProfileViewController.swift
//  GithubClient
//

import Foundation

@MainActor
final class ProfileViewController: ObservableObject {

    @Published var user: UserInfo?
    @Published var isLoading: Bool = false
    @Published var errorMsg: String?

    func loadProfile() async {

        guard !isLoading else {
            return
        }

        isLoading = true
        errorMsg = nil

        defer {
            isLoading = false
        }

        do {
            user = try await GithubService.shared.getUserProfile()
        } catch {

            if Task.isCancelled {
                return
            }

            if error.localizedDescription == "Request explicitly cancelled." {
                return
            }

            errorMsg = error.localizedDescription
        }
    }
}

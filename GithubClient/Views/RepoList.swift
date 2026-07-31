//
//  RepoList.swift
//  GithubClient
//

import SwiftUI

struct RepoList: View {

    @ObservedObject var viewController:
        RepoListViewController

    var body: some View {
        NavigationStack {
            Group {

                if viewController.isLoading &&
                    viewController.repositories.isEmpty {

                    ProgressView("Cargando repositorios...")

                } else if let error = viewController.errorMsg {

                    VStack(spacing: 15) {
                        Text(error)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)

                        Button("Reintentar") {
                            Task {
                                await viewController.loadRepositories()
                            }
                        }
                    }
                    .padding()

                } else if viewController.repositories.isEmpty {

                    ContentUnavailableView(
                        "Sin repositorios",
                        systemImage: "folder",
                        description: Text(
                            "Crea un repositorio o recarga la lista."
                        )
                    )

                } else {

                    List(viewController.repositories) { repository in
                        RepoItem(repository: repository)
                    }
                    .refreshable {
                        await viewController.loadRepositories()
                    }
                }
            }
            .navigationTitle("Repositorios")
        }
        .task {
            if viewController.repositories.isEmpty {
                await viewController.loadRepositories()
            }
        }
    }
}

#Preview {
    RepoList(
        viewController: RepoListViewController()
    )
}

//
//  ContentView.swift
//  GithubClient
//

import SwiftUI

struct ContentView: View {

    @State private var selection: Int = 0

    @StateObject private var repoListViewController =
        RepoListViewController()

    var body: some View {
        TabView(selection: $selection) {

            RepoList(
                viewController: repoListViewController
            )
            .tabItem {
                Label(
                    "Repositorios",
                    systemImage: "arrow.branch"
                )
            }
            .tag(0)

            RepoForm(
                selectedTab: $selection
            ) {
                // Después de crear, vuelve a cargar la lista
                Task {
                    await repoListViewController.loadRepositories()
                }
            }
            .tabItem {
                Label(
                    "Crear Repo",
                    systemImage: "plus"
                )
            }
            .tag(1)

            Profile()
                .tabItem {
                    Label(
                        "Perfil",
                        systemImage: "person"
                    )
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}

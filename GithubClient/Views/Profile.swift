//
//  Profile.swift
//  GithubClient
//

import SwiftUI

struct Profile: View {

    @StateObject private var viewController =
        ProfileViewController()

    var body: some View {

        NavigationStack {

            Group {

                if viewController.isLoading &&
                    viewController.user == nil {

                    ProgressView("Cargando perfil...")

                } else if let errorMsg =
                            viewController.errorMsg {

                    VStack(spacing: 15) {

                        Text(errorMsg)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)

                        Button("Reintentar") {
                            Task {
                                await viewController.loadProfile()
                            }
                        }
                    }
                    .padding()

                } else if let user = viewController.user {

                    VStack(spacing: 15) {

                        AsyncImage(
                            url: URL(string: user.avatarUrl)
                        ) { image in

                            image
                                .resizable()
                                .scaledToFill()

                        } placeholder: {

                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.gray)
                        }
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())

                        Text(user.name ?? "Sin nombre")
                            .font(.title)
                            .bold()

                        Text("@\(user.login)")
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        Text(user.bio ?? "Sin biografía")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                } else {

                    Text("No se pudo cargar el perfil.")
                }
            }
            .navigationTitle("Perfil")
        }
        .task {
            await viewController.loadProfile()
        }
    }
}

#Preview {
    Profile()
}

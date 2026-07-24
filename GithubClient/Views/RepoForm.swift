//
//  RepoForm.swift
//  GithubClient
//
//  Created by Usuario invitado on 10/7/26.
//

import SwiftUI

struct RepoForm: View {
    @StateObject private var viewController = RepoFormViewController()
    @Binding var selectedTab: Int

    var body: some View {
        NavigationStack {
            VStack {
                if viewController.isLoading {
                    ProgressView("Creando Repositorio")
                } else {
                    Spacer()

                    TextField("Nombre de repositorio", text: $viewController.repoName)
                        .textFieldStyle(.roundedBorder)
                        .padding(.vertical)

                    TextField(
                        "Descripción de repositorio",
                        text: $viewController.repoDescription,
                        axis: .vertical
                    )
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(6...10)
                    .padding(.vertical)
                    
                    if let error = viewController.errorMsg {
                        Spacer()
                        Text(error)
                            .foregroundStyle(.red)
                            .padding()
                    }

                    Spacer()

                    HStack {
                        Button(action: {
                            print("Botón aplastado")
                        }) {
                            Label("Cancelar", systemImage: "xmark.circle")
                                .padding(10)
                                .foregroundStyle(.black)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)

                        Button(action: {
                            Task {
                                await viewController.createRepository()
                                if viewController.errorMsg == nil {
                                    selectedTab = 0
                                }
                            }
                            print("Botón Guardar")
                        }) {
                            Label("Guardar", systemImage: "square.and.arrow.down")
                                .padding(10)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .padding()
            .navigationTitle("Formulario de repositorio")
        }
    }
}

#Preview {
    RepoForm(selectedTab: .constant(1))
}



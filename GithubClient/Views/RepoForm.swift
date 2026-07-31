//
//  RepoForm.swift
//  GithubClient
//

import SwiftUI

struct RepoForm: View {

    @StateObject private var viewController =
        RepoFormViewController()

    @Binding var selectedTab: Int

    var onRepositoryCreated: () -> Void

    var body: some View {

        NavigationStack {

            VStack {

                Spacer()

                TextField(
                    "Nombre de repositorio",
                    text: $viewController.repoName
                )
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.vertical)

                TextField(
                    "Descripción de repositorio",
                    text: $viewController.repoDescription,
                    axis: .vertical
                )
                .textFieldStyle(.roundedBorder)
                .lineLimit(4...6)
                .padding(.vertical)

                

                Spacer()

                HStack {

                    Button {

                        viewController.repoName = ""
                        viewController.repoDescription = ""
                        viewController.isPrivate = false

                        selectedTab = 0

                    } label: {

                        Label(
                            "Cancelar",
                            systemImage: "xmark.circle"
                        )
                        .padding(10)
                        .foregroundStyle(.black)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .disabled(viewController.isLoading)

                    Button {

                        viewController.createRepository {

                            // Actualizar la lista
                            onRepositoryCreated()

                            // Regresar a la pestaña de repositorios
                            selectedTab = 0
                        }

                    } label: {

                        HStack {

                            if viewController.isLoading {
                                ProgressView()
                                    .tint(.white)
                            }

                            Text(
                                viewController.isLoading
                                ? "Guardando..."
                                : "Guardar"
                            )

                            if !viewController.isLoading {
                                Image(
                                    systemName: "square.and.arrow.down"
                                )
                            }
                        }
                        .padding(10)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewController.isLoading)
                }
            }
            .padding()
            .navigationTitle("Formulario de repositorio")

            
            .alert(
                "Error",
                isPresented: $viewController.showAlert
            ) {
                Button(
                    "Aceptar",
                    role: .cancel
                ) { }
            } message: {
                Text(viewController.errorMsg)
            }
        }
    }
}

#Preview {
    RepoForm(
        selectedTab: .constant(1),
        onRepositoryCreated: { }
    )
}

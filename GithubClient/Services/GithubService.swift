//
//  GithubService.swift
//  GithubClient
//

import Foundation
import Alamofire
import Foundation
import Alamofire
struct GitHubError: Decodable {
    let message: String
}

class GithubService {

    static let shared = GithubService()

    private let baseUrl = AppConfig.apiBaseURL

    private init() {}

    private var headers: HTTPHeaders {
        [
            .authorization(bearerToken: AppConfig.apiToken),
            .accept("application/vnd.github+json")
        ]
    }

    func getRepositories() async throws -> [Repository] {
        
        let response = await AF.request(
            "\(baseUrl)/user/repos",
            method: .get,
            parameters: [
                "sort": "created",
                "direction": "desc",
                "per_page": 100,
                "affiliation": "owner"
            ],
            encoding: URLEncoding.default,
            headers: headers
        )
            .validate(statusCode: 200..<300)
            .serializingDecodable([Repository].self)
            .response
        
        switch response.result {
        case .success(let repositories):
            return repositories
            
        case .failure(let error):
            print(error)
            
            if let statusCode = response.response?.statusCode {
                print("Status Code:", statusCode)
            }
            
            if let data = response.data {
                print(String(data: data, encoding: .utf8) ?? "")
            }
            
            throw error
            
        }
    }
    func getUserProfile() async throws -> UserInfo {

        let response = await AF.request(
            "\(baseUrl)/user",
            method: .get,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .serializingDecodable(UserInfo.self)
        .response

        switch response.result {

        case .success(let user):
            return user

        case .failure(let error):
            throw error
        }
    }


    func createRepo(
        name: String,
        description: String,
        `private`: Bool,

        completion: @escaping (Result<Repository, Error>) -> Void
    ) {

        let parameters: Parameters = [
            "name": name,
            "description": description,
            "private": `private`
        ]

        AF.request(
            "\(baseUrl)/user/repos",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: Repository.self) { response in

            switch response.result {

            case .success(let repository):
                completion(.success(repository))

            case .failure(let error):

                if let data = response.data,
                   let githubError = try? JSONDecoder().decode(
                        GitHubError.self,
                        from: data
                   ) {

                    let apiError = NSError(
                        domain: "GitHubAPI",
                        code: response.response?.statusCode ?? 0,
                        userInfo: [
                            NSLocalizedDescriptionKey: githubError.message
                        ]
                    )

                    completion(.failure(apiError))

                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}

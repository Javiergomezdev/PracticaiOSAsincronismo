//
//  LoginUseCaseProtocol.swift
//  KCProfessional
//
//  Created by Javier Gomez on 10/5/25.
//

import Foundation

protocol LoginUseCaseProtocol {
    var repo: LoginRepositoryProtocol { get }
    func loginApp(user: String, password: String) async -> Bool
    func logoutApp() async
    func validateToken() async -> Bool
}

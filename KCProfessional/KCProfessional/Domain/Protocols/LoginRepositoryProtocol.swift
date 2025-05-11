//
//  LoginRepositoryProtocol.swift
//  KCProfessional
//
//  Created by Luis Escamez Sanchez on 30/4/25.
//

import Foundation

protocol LoginRepositoryProtocol {
    func loginApp(user: String, pass: String) async -> String //devuelve el token JWT
}


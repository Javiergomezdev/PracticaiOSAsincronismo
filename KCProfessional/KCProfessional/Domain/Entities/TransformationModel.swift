//
//  TransformationModel.swift
//  KCProfessional
//
//  Created by Javier Gomez on 5/5/25.
//


import Foundation

struct TransformationModel: Codable {
    let id: UUID           // Identificador único para cada transformación
    let name: String       // Nombre de la transformación (por ejemplo, "Super Saiyan")
    let description: String // Descripción detallada de la transformación
    let photo: String  // Nombre del asset de imagen en tu proyecto
    let hero: Hero
}
struct Hero: Codable {
    let id: UUID
}
struct TransformationModelRequest: Codable {
    let id: UUID
}

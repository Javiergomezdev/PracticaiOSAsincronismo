//
//  NetworkTransformations.swift
//  KCProfessional
//
//  Created by Javier Gomez on 10/5/25.
//
import Foundation
import KCLibrarySwift

protocol NetworkTransformationsProtocol {
   
    func getTransformations(filter: UUID) async -> [TransformationModel]
}


final class NetworkTransformations: NetworkTransformationsProtocol {
    
    
    func getTransformations(filter: UUID) async -> [TransformationModel] {
        var transformations = [TransformationModel]() // 🧺 Aquí guardaremos las transformaciones que nos devuelva el servidor
        
   
        let url: String = "\(ConstantsApp.CONST_API_URL)\(EndPoints.transformations.rawValue)"
        
        //Creamos la request, asegurándonos de que la URL es válida
        var request: URLRequest = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethods.post // Usamos POST porque vamos a enviar un body
        
        // Creamos el cuerpo del request con el ID del héroe (así el servidor sabe qué héroe preguntamos)
        request.httpBody = try? JSONEncoder().encode(TransformationModelRequest(id: filter))
        
        // 📇 Indicamos que el tipo de contenido es JSON
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-type")
        let JwtToken =  KeychainManager.shared.getKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        // 🔑 Añadimos el token JWT desde el Keychain, si existe
        if let tokenJWT = JwtToken{
            request.addValue("Bearer \(tokenJWT)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == HTTPResponseCodes.SUCCESS {
                
                transformations = try JSONDecoder().decode([TransformationModel].self, from: data)
            }
        } catch {
            
            print("Error al obtener transformaciones: \(error.localizedDescription)")
        }
        
        
        return transformations
    }
}


final class NetworkTransformationsFake: NetworkTransformationsProtocol {

  
    func getTransformations(filter: UUID) async -> [TransformationModel] {
        return getTransformationsFromJson()
    }
}

func getTransformationsFromJson() -> [TransformationModel] {
    if let url = Bundle.main.url(forResource: "transformations", withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([TransformationModel].self, from: data)
        } catch {
            print("Error al decodificar JSON: \(error)")
        }
    }
    return []
}

func getTransformationsHardcoded() -> [TransformationModel] {
    let model1 = TransformationModel(
        id: UUID(),
        name: "1. Oozaru – Gran Mono",
        description: "Cómo todos los Saiyans con cola, Goku es capaz de convertirse en un mono gigante si mira fijamente a la luna llena...",
        photo: "https://areajugones.sport.es/wp-content/uploads/2021/05/ozarru.jpg.webp",
        hero: Hero(id: UUID())
    )

    let model2 = TransformationModel(
        id: UUID(),
        name: "2. Kaio-Ken",
        description: "La técnica de Kaio-sama permitía a Goku aumentar su poder de forma exponencial...",
        photo: "https://areajugones.sport.es/wp-content/uploads/2017/05/Goku_Kaio-Ken_Coolers_Revenge.jpg",
        hero: Hero(id: UUID())
    )

    return [model1, model2]
}

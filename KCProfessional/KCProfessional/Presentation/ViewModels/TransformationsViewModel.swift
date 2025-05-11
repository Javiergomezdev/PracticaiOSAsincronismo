//
//  TransformationsViewModel.swift
//  KCProfessional
//
//  Created by Javier Gomez on 11/5/25.
//


import Foundation

final class TransformationsViewModel: ObservableObject {
    
    // Publica cambios en el array de transformaciones
    @Published var transformationData: [TransformationModel] = []

    // Caso de uso que encapsula la lógica de negocio
    private var transformationUseCase: TransformationUseCaseProtocol

    // Inicializador con inyección de dependencia (por defecto usa la implementación concreta)
    init(useCase: TransformationUseCaseProtocol = TransformationUseCase()) {
        self.transformationUseCase = useCase
        Task {
            await getTransformations(id: UUID())
        }
    }

    func extractLeadingNumber(from name: String) -> Int {
        let pattern = #"^\d+"#
        if let range = name.range(of: pattern, options: .regularExpression) {
            return Int(name[range]) ?? Int.max
        }
        return Int.max
    }

    // Llama al caso de uso para obtener transformaciones y las publica procesadas
    func getTransformations(id: UUID) async {
        let data = await transformationUseCase.getTransformation(filter: id)
        //let processedData = processTransformation(data)

        DispatchQueue.main.async {
            self.transformationData = data
        }
    }
}

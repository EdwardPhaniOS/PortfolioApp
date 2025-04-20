//
//  Bundle-Decodable.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 18/4/25.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(file: String, asType type: T.Type = T.self) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Can not find \(file) in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Can not load \(file) in bundle")
        }
        
        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .deferredToData
        decoder.keyDecodingStrategy = .useDefaultKeys
        
        do {
            return try decoder.decode(type, from: data)
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value  - \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            fatalError("Failed to decode \(file) from bundle because it appears as invalid JSON")
        } catch DecodingError.typeMismatch(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to type missmatch  - \(context.debugDescription)")
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key \(key.stringValue)  - \(context.debugDescription)")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}

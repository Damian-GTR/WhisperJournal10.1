//
//  TranslationService.swift
//  WhisperJournal10.1
//
//  Created by andree on 15/12/24.
//


import Foundation

class TranslationService {
    static func translate(text: String, to targetLanguage: String, completion: @escaping (String) -> Void) {
        // Aquí puedes usar una API de traducción como Google Translate o DeepL
        // Por simplicidad, esto es solo un ejemplo con un texto fijo
        let translatedText = "[Traducción simulada a \(targetLanguage)]: \(text)"
        completion(translatedText)
    }
}

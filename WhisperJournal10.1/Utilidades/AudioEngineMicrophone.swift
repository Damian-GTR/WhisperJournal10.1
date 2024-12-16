//
//  AudioEngineMicrophone.swift
//  WhisperJournal10.1
//
//  Created by andree on 15/12/24.
//

import Foundation
import AudioKit

class AudioEngineMicrophone: ObservableObject {
    let audioEngine = AudioEngine()
    let audioInput: AudioEngine.InputNode

    init() {
        guard let input = audioEngine.input else {
            fatalError("No se pudo acceder al micrófono.")
        }
        self.audioInput = input
    }

    func start() {
        do {
            try audioEngine.start()
        } catch {
            print("Error al iniciar el motor de audio: \(error.localizedDescription)")
        }
    }

    func stop() {
        audioEngine.stop()
    }
}

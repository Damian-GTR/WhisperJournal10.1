//
//  RecordingViewModel.swift
//  WhisperJournal10.1
//
//  Created by andree on 14/12/24.
//


import Foundation
import AVFoundation

class RecordingViewModel: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var audioSession: AVAudioSession?
    
    @Published var transcription: String?
    
    // Configurar la sesión de audio
    func setupAudioSession() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setCategory(.record, mode: .default)
            try audioSession?.setActive(true)
        } catch {
            print("Error configurando la sesión de audio: \(error)")
        }
    }
    
    // Iniciar grabación
    func startRecording() {
        let filename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
            audioRecorder?.record()
        } catch {
            print("Error al iniciar la grabación: \(error)")
        }
    }
    
    // Detener grabación
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        // Aquí se llamaría a la API de Whisper para transcribir el audio grabado
        transcribeAudio()
    }
    
    
    // Función para transcribir el audio grabado
    func transcribeAudio() {
        WhisperService.shared.transcribeAudio(at: getDocumentsDirectory().appendingPathComponent("recording.m4a")) { transcription in
            DispatchQueue.main.async {
                self.transcription = transcription
                if let transcription = transcription {
                    // Guardar la transcripción en Core Data
                    let currentDate = Date()
                    PersistenceController.shared.saveTranscript(text: transcription, date: currentDate)
                }
            }
        }
    }


    
    // Obtener el directorio de documentos para guardar el archivo de audio
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
func saveTranscriptToCoreData(transcription: String) {
    let context = PersistenceController.shared.container.viewContext
    let newTranscript = Transcript(context: context)
    newTranscript.text = transcription
    newTranscript.timestamp = Date()
    
    
    do {
        try context.save()
        print("Transcripción guardada con éxito")
    } catch {
        print("Error al guardar la transcripción: \(error)")
    }
}

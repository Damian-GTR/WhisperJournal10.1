//
//  MainView.swif.swift
//  WhisperJournal10.1
//
//  Created by andree on 14/12/24.
//

import Foundation
import SwiftUI
import CoreData

struct MainView: View {
    @State private var recordings: [Transcript] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Iniciar Grabación") {
                    // Iniciar grabación
                    let audioURL = FileManager.default.temporaryDirectory.appendingPathComponent("audio.m4a")
                    AudioSessionManager.shared.startRecording(to: audioURL)
                }
                .padding()
                
                List(recordings, id: \.self) { transcript in
                    Text(transcript.text ?? "Sin transcripción")
                }
                
                Spacer()
            }
            .navigationBarTitle("Whisper Journal")
        }
        .onAppear {
            // Cargar transcripciones de CoreData
            loadTranscriptions()
        }
    }
    
    func loadTranscriptions() {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Transcript> = Transcript.fetchRequest()
        
        do {
            recordings = try context.fetch(fetchRequest)
        } catch {
            print("Error al cargar transcripciones: \(error)")
        }
    }
}

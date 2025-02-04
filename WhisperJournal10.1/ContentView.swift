//
//  ContentView.swift
//  WhisperJournal10.1
//
//  Created by andree on 14/12/24.
//
import SwiftUI
import AVFoundation
import CoreData
import AudioKit
import AudioKitUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isRecording = false
    @State private var recordedText = ""
    @State private var transcriptionDate = Date()
    @State private var tags = ""

    let audioRecorder = AudioRecorder()
    let engine = AudioEngine()
        let mic: AudioEngine.InputNode

        init() {
            // Configurar el nodo del micrófono
            guard let input = engine.input else {
                fatalError("No se pudo acceder al micrófono.")
            }
            mic = input
        }
    var body: some View {
        NavigationView {
            VStack {
                Text("Whisper Journal")
                    .font(.largeTitle)
                    .padding()

                // Visualizador de ondas de audio
                if isRecording {
                    NodeOutputView(mic)
                        .frame(height: 150)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding()
                }

                // Botón para grabar
                Button(action: {
                    if isRecording {
                        stopRecording()
                    } else {
                        startRecording()
                    }
                }) {
                    Text(isRecording ? "Stop Recording" : "Start Recording")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isRecording ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }
                .padding(.top, 20)

                // Mostrar la transcripción
                if !recordedText.isEmpty {
                    Text("Transcription:")
                        .font(.headline)
                        .padding(.top, 20)

                    Text(recordedText)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }

                // Campo de entrada para Tags
                TextField("Enter tags...", text: $tags)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                // Botón para guardar la transcripción
                Button(action: saveTranscription) {
                    Text("Save Transcription")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }
                .padding(.top, 10)

                // Botón para ver transcripciones guardadas
                NavigationLink(destination: TranscriptionListView()) {
                    Text("View Saved Transcriptions")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.headline)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding()
            .navigationTitle("Home")
            .onAppear {
                mic.start() // Iniciar el micrófono para el visualizador
            }
            .onDisappear {
                mic.stop() // Detener el micrófono al salir de la vista
            }
        }
    }

    // Iniciar grabación
    func startRecording() {
        isRecording = true
        recordedText = ""
        transcriptionDate = Date()
        audioRecorder.startRecording { transcription in
            self.recordedText = transcription
        }
    }

    // Detener grabación
    func stopRecording() {
        isRecording = false
        audioRecorder.stopRecording()
    }

    // Guardar transcripción en Core Data
    func saveTranscription() {
        guard !recordedText.isEmpty else {
            print("No transcription to save.")
            return
        }

        let newTranscript = Transcript(context: viewContext)
        newTranscript.text = recordedText
        newTranscript.date = transcriptionDate
        newTranscript.tags = tags

        do {
            try viewContext.save()
            print("Transcription saved successfully!")
            resetFields()
        } catch {
            print("Error saving transcription: \(error.localizedDescription)")
        }
    }

    // Reiniciar campos después de guardar
    func resetFields() {
        recordedText = ""
        tags = ""
    }
    
    // Iniciar el motor de audio
        func startAudioEngine() {
            do {
                try engine.start()
            } catch {
                print("Error al iniciar el motor de audio: \(error.localizedDescription)")
            }
        }

        // Detener el motor de audio
        func stopAudioEngine() {
            engine.stop()
        }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        ContentView()
            .environment(\.managedObjectContext, context)
    }
}

//
//  RecordingView.swif.swift
//  WhisperJournal10.1
//
//  Created by andree on 14/12/24.
//

import SwiftUI
import AVFoundation
import CoreData

struct RecordingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isRecording = false
    @State private var recordedText = ""
    @State private var transcriptionDate = Date()
    @State private var tags = ""
    
    let audioRecorder = AudioRecorder()
    
    var body: some View {
        VStack {
            Text("Record New Transcription")
                .font(.title2)
                .padding()
            
            Button(action: {
                if self.isRecording {
                    self.stopRecording()
                } else {
                    self.startRecording()
                }
            }) {
                Text(isRecording ? "Stop Recording" : "Start Recording")
                    .padding()
                    .background(isRecording ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Text("Transcription:")
                .font(.headline)
                .padding(.top)
            
            Text(recordedText)
                .padding()
            
            Button(action: saveTranscription) {
                Text("Save Transcription")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    func startRecording() {
        isRecording = true
        recordedText = ""
        transcriptionDate = Date()
        audioRecorder.startRecording { (transcription) in
            self.recordedText = transcription
        }
    }
    
    func stopRecording() {
        isRecording = false
        audioRecorder.stopRecording()
    }
    
    func saveTranscription() {
        let newTranscript = Transcript(context: viewContext)
        newTranscript.text = recordedText
        newTranscript.date = transcriptionDate
        newTranscript.tags = tags
        
        do {
            try viewContext.save()
            print("Transcription saved successfully!")
        } catch {
            print("Error saving transcription: \(error.localizedDescription)")
        }
    }
}

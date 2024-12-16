//
//  TranscriptDetailView.swift
//  WhisperJournal10.1
//
//  Created by andree on 15/12/24.
//

import Foundation
import SwiftUI

struct TranscriptDetailView: View {
    let transcript: Transcript
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Transcription:")
                .font(.title2)
            Text(transcript.text ?? "No Text")
                .padding()
            
            Text("Date:")
                .font(.headline)
            Text(transcript.date ?? Date(), style: .date)
                .foregroundColor(.gray)
            
            Text("Tags:")
                .font(.headline)
            Text(transcript.tags ?? "No Tags")
                .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Details")
    }
}

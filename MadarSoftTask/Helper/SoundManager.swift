//
//  SoundManager.swift
//  MadarSoftTask
//
//  Created by Mohamed Osama on 26/10/2024.
//

import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var player: AVAudioPlayer?
    
    func play() {
        guard let url = Bundle.main.url(forResource: "todo_done", withExtension: "wav") else { return }
        player?.stop()
        player = try? AVAudioPlayer(contentsOf: url)
        player?.play()
    }
}

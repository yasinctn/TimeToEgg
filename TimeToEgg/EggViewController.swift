//
//  EggViewController.swift
//  TimeToEgg
//
//  Created by Yasin Cetin on 2.09.2023.
//

import UIKit
import AVFoundation

final class EggViewController: UIViewController {
    
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!
    
    private var counter = 0
    private var totalTime = 0
    private var timer: Timer?
    private var player: AVAudioPlayer?
    private let hardnessTime = ["Soft": 5, "Medium": 8, "Hard": 12]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProgress(progress: 1)
    }
    
    @IBAction private func softnessSelected(_ sender: UIButton) {
        guard let softness = sender.currentTitle else { return }
        
        setProgress(progress: 1)
        updateInfoLabel(text: "Choose the cook degree")
        setCounter(softness: softness)
        startTimer()
        
    }
    
}

// MARK: - Methods

private extension EggViewController {
    
    func playAudio(name:String) throws {
            
            if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            }
        }
    
    func startTimer() {
        if (timer == nil || timer?.isValid == false) {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        }
    }
    
    
    func setCounter(softness selectedSoftness: String) {
        
        switch selectedSoftness {
        case "Soft" :
            counter = 5*60
        case "Medium" :
            counter = 8*60
        case "Hard" :
            counter = 12*60
        default:
            print("check your code")
        }
        totalTime = counter
        
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            setProgress(progress: Float(counter)/Float(totalTime))
            updateInfoLabel(text: "\(counter/60) minute\n\(counter%60) second")
            counter -= 1
        }else {
            
            do{
                try playAudio(name: "alarm")
            }catch {
                print("Sound Error")
            }
            setProgress(progress: 0.0)
            timer?.invalidate()
            updateInfoLabel(text: "Egg ready\nEnjoy your meal")
        }
    }
    
    func updateInfoLabel(text: String) {
        infoLabel.text = text
    }
    
    func setProgress(progress: Float) {
        progressView.setProgress(progress, animated: true)
    }
}


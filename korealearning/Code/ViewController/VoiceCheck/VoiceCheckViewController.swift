//
//  VoiceCheckViewController.swift
//  korealearning
//
//  Created by Hien Nguyen on 6/26/18.
//  Copyright © 2018 Hien Nguyen. All rights reserved.
//

import UIKit
import AVFoundation
//import googleapis

let SAMPLE_RATE = 16000

class VoiceCheckViewController: BaseViewController {
    var phrase: Phrase!
    @IBOutlet weak var btSound: UIButton!
    @IBOutlet weak var btMicro: UIButton!
    @IBOutlet weak var btClose: UIButton!
    @IBOutlet weak var lbPhrase: UILabel!
    @IBOutlet weak var lbStatus: UILabel!

    var audioData: NSMutableData!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateData()
//        AudioController.sharedInstance.delegate = self
    }

    func updateData() {
        lbPhrase.text = phrase.korean + "\n" + phrase.pinyin
    }

    func stopAudio() {
//        _ = AudioController.sharedInstance.stop()
//        SpeechRecognitionService.sharedInstance.stopStreaming()
    }


    @IBAction func closeBtPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func soundBtPressed(_ sender: Any) {
    }
    @IBAction func microBtPressed(_ sender: Any) {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
        } catch {

        }
        audioData = NSMutableData()
//        _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE)
//        SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
//        _ = AudioController.sharedInstance.start()
    }
}
/*
extension VoiceCheckViewController: AudioControllerDelegate {
    func processSampleData(_ data: Data) {
        audioData.append(data)

        // We recommend sending samples in 100ms chunks
        let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
            * Double(SAMPLE_RATE) /* samples/second */
            * 2 /* bytes/sample */);

        if (audioData.length > chunkSize) {
            SpeechRecognitionService.sharedInstance.streamAudioData(audioData,
                                                                    completion:
                { [weak self] (response, error) in
                    guard let strongSelf = self else {
                        return
                    }

                    if let error = error {
                        strongSelf.lbStatus.text = error.localizedDescription
                    } else if let response = response {
                        var finished = false
                        print(response)
                        for result in response.resultsArray! {
                            if let result = result as? StreamingRecognitionResult {
                                if result.isFinal {
                                    finished = true
                                }
                            }
                        }
                        strongSelf.lbStatus.text = response.description
                        if finished {
                            strongSelf.stopAudio()
                        }
                    }
            })
            self.audioData = NSMutableData()
        }
    }
}
*/

//
//  PhraseListViewController.swift
//  korealearning
//
//  Created by Hien Nguyen on 6/24/18.
//  Copyright © 2018 Hien Nguyen. All rights reserved.
//

import UIKit
import AVFoundation
import PromiseKit
import PopupDialog

class PhraseListViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!

    var category: Category?
    fileprivate var phraseList: [Phrase] = []
    fileprivate let cellId = "PhraseCell"
    fileprivate var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if player?.isPlaying == true {
            player?.stop()
        }
    }

    func loadData() {
        guard let category = self.category else { return }
        if category._id == 0 { // favorite
            firstly {
                DataManager.shared.getFavoriteList()
                }.done {
                    self.phraseList = $0
                }.catch { err in
                    // error

                }.finally {
                    self.tableView.reloadData()
            }
            return
        } else {
            phraseList = DataManager.shared.getAllPhrases(categoryId: category._id)
        }
        tableView.reloadData()
    }

    func playVoice(at indexPath: IndexPath) {
        guard indexPath.row < phraseList.count && indexPath.row >= 0 else {
            return
        }
        if player?.isPlaying == true {
            player?.stop()
        }

        let phrase = phraseList[indexPath.row]
        let file = phrase.voice + "_f"
        if let path = Bundle.main.path(forResource: file, ofType: "mp3") {
            do {
                let url = URL(fileURLWithPath: path)
                player = try AVAudioPlayer(contentsOf: url)
                player?.delegate = self
//                player?.setVolume(1, fadeDuration: 0)
                player?.prepareToPlay()
                player?.play()
            }catch {
                print("play error \(error)")
            }
        } else {
            print("cannot find file \(file)")
        }
    }

    func stopVoice(at indexPath: IndexPath) {
        player?.stop()
    }
}

extension PhraseListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phraseList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PhraseCell
        cell.selectionStyle = .none
        cell.update(phrase: phraseList[indexPath.row], at: indexPath)
        cell.delegate = self
        if tableView.indexPathForSelectedRow == indexPath {
            cell.isSelected = true
            cell.isShowPlaying = player?.isPlaying == true
        } else {
            cell.isSelected = false
            cell.isShowPlaying = false
        }
        return cell
    }
}

extension PhraseListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let currentIdx = tableView.indexPathForSelectedRow {
            let cell = tableView.cellForRow(at: indexPath) as? PhraseCell
            cell?.isShowPlaying = false
            stopVoice(at: currentIdx)
            if currentIdx == indexPath {
                tableView.beginUpdates()
                tableView.deselectRow(at: indexPath, animated: true)
                tableView.endUpdates()
                return nil
            }
        }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playVoice(at: indexPath)
        tableView.beginUpdates()
        let cell = tableView.cellForRow(at: indexPath) as? PhraseCell
        cell?.isSelected = cell?.isSelected ?? false
        cell?.isShowPlaying = true
        tableView.endUpdates()
    }
}

extension PhraseListViewController: AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("\(#function) error: \(error?.localizedDescription)")
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        let cell = tableView.cellForRow(at: indexPath) as? PhraseCell
        cell?.isShowPlaying = false
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("\(#function) flag = \(flag)")
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        let cell = tableView.cellForRow(at: indexPath) as? PhraseCell
        cell?.isShowPlaying = false
    }
}

extension PhraseListViewController: PhraseCellDelegate {
    func cellDidPressedSound() {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        let cell = tableView.cellForRow(at: indexPath) as? PhraseCell
        if player?.isPlaying == true {
            player?.stop()
            cell?.isShowPlaying = false
        } else {
            player?.currentTime = 0
            player?.play()
            cell?.isShowPlaying = true
        }
    }

    func cellDidPressedMicro(_ phrase: Phrase?) {
        guard let phrase = phrase, let vc = self.storyboard?.instantiateViewController(withIdentifier: "VoiceCheckViewController") as? VoiceCheckViewController else { return }
        vc.phrase = phrase
        let popup = PopupDialog(viewController: vc)
        self.present(popup, animated: true, completion: nil)
    }
}

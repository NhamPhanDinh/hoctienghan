//
//  PhraseCell.swift
//  korealearning
//
//  Created by Hien Nguyen on 6/24/18.
//  Copyright © 2018 Hien Nguyen. All rights reserved.
//

import UIKit

protocol PhraseCellDelegate: class {
    func cellDidPressedSound()
    func cellDidPressedMicro(_ phrase: Phrase?)
}

class PhraseCell: UITableViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btFavorite: UIButton!
    @IBOutlet weak var pronounView: UIView!
    @IBOutlet weak var lbKoreaText: UILabel!
    @IBOutlet weak var lbPronounText: UILabel!
    @IBOutlet weak var btSound: UIButton!
    @IBOutlet weak var btMicro: UIButton!

    weak var delegate: PhraseCellDelegate?

    var indexPath: IndexPath?
    var phrase: Phrase?
    var isShowPlaying: Bool = false {
        didSet {
            btSound.setImage(isShowPlaying ? #imageLiteral(resourceName: "listen_focus") : #imageLiteral(resourceName: "listen"), for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        isSelected = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        pronounView.isHidden = !isSelected
    }

    func update(phrase: Phrase, at indexPath: IndexPath) {
        self.phrase = phrase
        self.indexPath = indexPath

        lbTitle.text = phrase.title
        lbKoreaText.text = phrase.korean
        lbPronounText.text = phrase.pinyin

        if phrase.favorite == 1 {
            btFavorite.setImage(#imageLiteral(resourceName: "ic_star_mark"), for: .normal)
        } else {
            btFavorite.setImage(#imageLiteral(resourceName: "ic_star"), for: .normal)
        }
    }

    @IBAction func favoriteBtPressed(_ sender: Any) {
        guard let phrase = self.phrase else { return }
        phrase.favorite = phrase.favorite == 1 ? 0 : 1
        let favorite = phrase.favorite == 1
        DataManager.shared.setFavorite(favorite, for: phrase)
        btFavorite.setImage(favorite ? #imageLiteral(resourceName: "ic_star_mark") : #imageLiteral(resourceName: "ic_star"), for: .normal)
    }
    
    @IBAction func microBtPressed(_ sender: Any) {
        delegate?.cellDidPressedMicro(self.phrase)
    }

    @IBAction func soundBtPressed(_ sender: Any) {
        delegate?.cellDidPressedSound()
    }
}

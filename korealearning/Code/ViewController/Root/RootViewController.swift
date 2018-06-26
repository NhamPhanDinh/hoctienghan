//
//  RootViewController.swift
//  korealearning
//
//  Created by Hien Nguyen on 6/23/18.
//  Copyright © 2018 Hien Nguyen. All rights reserved.
//

import UIKit
import MessageUI

class RootViewController: BaseViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    var categoryList: [Category] = []

    fileprivate let cellId = "CategoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
    }

    func loadData() {
        categoryList = DataManager.shared.getAllCategory()
        collectionView.reloadData()
    }

    func openMenu(_ indexPath: IndexPath) {
        switch indexPath.row {
        case 18: // language
            openLanguageSelection()
        case 19: // rate
            openRateApp()
        case 20: // feedback
            openFeedback()
        case 21: // more apps
            openMoreApps()
        case 22: // about
            openAbout()
        default:
            break
        }
    }

    func openLanguageSelection() {
        let vc = UIAlertController(title: "Choose language", message: nil, preferredStyle: .actionSheet)
        let vietnameseAction = UIAlertAction(title: "Vietnamese", style: .default) { _ in

        }
        let englishAction = UIAlertAction(title: "English", style: .default) { _ in

        }
        let chineseAction = UIAlertAction(title: "Chinese", style: .default) { _ in

        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in

        }
        vc.addAction(vietnameseAction)
        vc.addAction(englishAction)
        vc.addAction(chineseAction)
        vc.addAction(cancelAction)
        present(vc, animated: true, completion: nil)
    }

    func openRateApp() {
        let url = URL(string: "itms-apps://itunes.apple.com/us/app/apple-store/id1381226716?mt=8")!
        UIApplication.shared.openURL(url)
    }

    func openFeedback() {
        let vc = MFMailComposeViewController()
        vc.setMessageBody("Feedback", isHTML: false)
        vc.setSubject("Feedback subject")
        vc.mailComposeDelegate = self
        self.present(vc, animated: true, completion: nil)
    }

    func openMoreApps() {
        let url = URL(string: "itms-apps://itunes.apple.com/vn/developer/hoang-cao/id964419067?mt=8")!
        UIApplication.shared.openURL(url)
    }

    func openAbout() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as? AboutViewController else { return }
        show(vc, sender: nil)
    }
}

extension RootViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        cell.category = categoryList[indexPath.row]
        return cell
    }
}

extension RootViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < 18 else {
            openMenu(indexPath)
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhraseListViewController") as! PhraseListViewController
        vc.category = categoryList[indexPath.row]
        show(vc, sender: nil)
    }
}

extension RootViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = min(collectionView.frame.width / 3 - 8, 150)
        return CGSize(width: width, height: width * 1.1)
    }
}

extension RootViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

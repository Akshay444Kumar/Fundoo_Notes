//
//  ShowReminderViewController.swift
//  CustomLogin
//
//  Created by YE002 on 18/07/23.
//

import UIKit

class ShowReminderViewController: UIViewController {
    
    @IBOutlet var reminderNotesCollectionView: UICollectionView!
    var reminderNotes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NoteService.fetchData(isDeleted: false, hasReminder: true) { notes in
            self.reminderNotes = notes
            self.reminderNotesCollectionView.reloadData()
        }
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        print("Cancel Tapped")
        self.dismiss(animated: true, completion: nil)
    }
}

extension ShowReminderViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reminderNotes.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reminderNotesCell", for: indexPath) as! ReminderNotesCollectionViewCell
        cell.reminderNoteTitleLabel.text = reminderNotes[indexPath.row].title
        cell.reminderNoteDescriptionLabel.text = reminderNotes[indexPath.row].description
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionWidth = collectionView.bounds.width
        return CGSize(width: collectionWidth/2-15, height: collectionWidth/2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}


//
//  TrashNotesViewController.swift
//  CustomLogin
//
//  Created by YE002 on 16/07/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class TrashNotesViewController: UIViewController {
    
    var hasReminder: Bool = true
    var trashNotes = [Note]()
    
    @IBOutlet var trashNotesCollectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NoteService.fetchData(isDeleted: true, hasReminder: true) { notes in
            self.trashNotes = notes
            NoteService.fetchData(isDeleted: true, hasReminder: false) { notes in
                self.trashNotes.append(contentsOf: notes)
                self.trashNotesCollectionView.reloadData()
                
            }
        }
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        print("cancel")
    }
}

extension TrashNotesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trashNotes.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trashNotesCell", for: indexPath) as! TrashNotesCollectionViewCell
        cell.trashNoteTitle.text = trashNotes[indexPath.row].title
        cell.trashNoteDescription.text = trashNotes[indexPath.row].description
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.cellIndex = indexPath
        cell.delegate = self
        cell.restoreDelegate = self
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

extension TrashNotesViewController: DataDeletionDelegate, DataRestorationDelegate {
    
    func deleteData(index: Int) {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        
        db.collection("users").document(user.uid).collection("notes").document(trashNotes[index].uId!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.trashNotes.remove(at: index)
                
                self.trashNotesCollectionView?.reloadData()
            }
        }
    }
    
    
    func restoreData(index: Int) {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).collection("notes").document(trashNotes[index].uId!).updateData(["isDeleted" : false]) { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.trashNotes.remove(at: index)
                self.trashNotesCollectionView.reloadData()
            }
        }
    }
}

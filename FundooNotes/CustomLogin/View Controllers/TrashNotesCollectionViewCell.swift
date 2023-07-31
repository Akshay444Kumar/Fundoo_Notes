//
//  TrashNotesCollectionViewCell.swift
//  CustomLogin
//
//  Created by YE002 on 18/07/23.
//

import UIKit

class TrashNotesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var trashNoteTitle: UILabel!
    @IBOutlet var trashNoteDescription: UILabel!
    var delegate: DataDeletionDelegate?
    var restoreDelegate: DataRestorationDelegate?
    var cellIndex: IndexPath?
    

    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        print("Trash Note Delete Button Tapped")
        delegate?.deleteData(index: cellIndex!.row)
    }
    
    
    @IBAction func restoreButtonTapped(_ sender: UIButton) {
        print("Restore Tapped")
        restoreDelegate?.restoreData(index: cellIndex!.row)
    }
}

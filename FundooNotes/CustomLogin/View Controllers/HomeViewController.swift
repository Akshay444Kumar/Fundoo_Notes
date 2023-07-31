//
//  HomeViewController.swift
//  CustomLogin
//
//  Created by YE002 on 06/07/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var notes: [Note] = []
    private var collectionView: UICollectionView?
    var delegate: HomeControllerDelegate?
    let notificationCenter = UNUserNotificationCenter.current()
    
    var searching = false
    var searchedNote = [Note]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var isListView = false
    var newNoteButton: UIBarButtonItem!
    var gridViewButton: UIBarButtonItem!
    var listViewButton: UIBarButtonItem!
    
    var emptyNote: UILabel = {
        let label = UILabel()
        label.text = "Oops! No Notes Found."
        label.font = UIFont(name:"HelveticaNeue-Bold", size: 25)
        label.isHidden = true
        return label
        
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        
        view.backgroundColor = .white
        
        checkIfAlreadyLoggedIn()
        configureNavigationBar()
        configureCollectionView()
        configureSearchController()
        configureLabel()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { permissionGranted, error in
            if !permissionGranted
            {
                print("Permission Denied")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    // MARK: - Handlers
    
    func configureLabel() {
        view.addSubview(emptyNote)
        emptyNote.frame = CGRect(x: (Int(view.frame.width)/2)-150, y: Int(view.frame.height)/2, width: 300, height: 50)
    }
    
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOptions: nil)
    }
    
    
    @objc func goToNewNoteScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let newNoteVC = storyboard.instantiateViewController(withIdentifier: "NewNoteViewController") as? NewNoteViewController else { return }
        print("Check MArk")
        newNoteVC.title = "New Note"
        newNoteVC.delegate = self
        self.navigationController?.pushViewController(newNoteVC, animated: true)
    }
    
    
    @objc func listGridToggle() {
        print("List Grid View Button Tapped")
        isListView = !isListView
        if isListView {
            navigationItem.rightBarButtonItems = [newNoteButton, gridViewButton]
            
        } else {
            navigationItem.rightBarButtonItems = [newNoteButton, listViewButton]
            
        }
        collectionView?.reloadData()
    }
    
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Notes"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet.circle"), style: .plain, target: self, action: #selector(handleMenuToggle))
        
        newNoteButton = UIBarButtonItem(image: UIImage(systemName: "note.text.badge.plus"), style: .plain, target: self, action: #selector(goToNewNoteScreen))
        
        listViewButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(listGridToggle))
        
        gridViewButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.grid.2x2"), style: .plain, target: self, action: #selector(listGridToggle))
        
        if isListView {
            navigationItem.rightBarButtonItems = [newNoteButton, gridViewButton]
            
        } else {
            navigationItem.rightBarButtonItems = [newNoteButton, listViewButton]
            
        }
    }
    
    
    func configureCollectionView() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.size.width/3)-4,
                                 height: (view.frame.size.width/3)-4)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {return}
        collectionView.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: NoteCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        
        print("Screen Loads")
    }
    
    
    func configureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false       // Background dim na ho
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false            // keep search bar permanent
        self.navigationItem.title = "Notes"
        definesPresentationContext = true                                  // properly display search bar
        searchController.searchBar.placeholder = "Search Notes by Title..."
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Inside didSelect")
        if searching {
            return searchedNote.count
        } else {
            return notes.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.identifier, for: indexPath) as! NoteCollectionViewCell
        
        if searching
        {
            cell.set(note: searchedNote[indexPath.row])
            cell.cellIndex = indexPath
            cell.delegate = self
            
        }
        else
        {
            cell.set(note: notes[indexPath.row])
            cell.cellIndex = indexPath
            cell.delegate = self
        }
        cell.reminderDelegate = self
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let size = (collectionView.frame.size.width-20) / 2
        //        return CGSize(width: size, height: size)
        
        let width = collectionView.frame.size.width
        if isListView {
            return CGSize(width: width, height: 120)
        }else {
            return CGSize(width: (width - 20)/2, height: (width - 20)/2)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let updateNoteVC = storyboard.instantiateViewController(withIdentifier: "UpdateNoteViewController") as! UpdateNoteViewController
        
        updateNoteVC.title = "Update Your Note"
        updateNoteVC.editNote = notes[indexPath.row].title
        updateNoteVC.editDescription = notes[indexPath.row].description
        updateNoteVC.completion = {
            title, noteDescription in
            self.notes[indexPath.row].title = title
            self.notes[indexPath.row].description = noteDescription
            self.navigationController?.popViewController(animated: true)
            self.updateData(index: indexPath.row, note: self.notes[indexPath.row])
            //self.collectionView?.reloadData()
            
        }
        self.navigationController?.pushViewController(updateNoteVC, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

extension HomeViewController: DataPassDelegate {
    
    func dataPassing(title: String, description: String, uid: String, isDeleted: Bool, hasReminder: Bool) {
        print("Inside Data Passing")
        let note = Note(uId: uid, title: title, description: description, isDeleted: false, hasReminder: false)
        notes.append(note)
        saveData(note: note)
        collectionView?.reloadData()
    }
    
    
    func saveData(note: Note) {
        
        guard let user = Auth.auth().currentUser else {return}
        
        let db = Firestore.firestore()
        
        let document = db.collection("users").document(user.uid).collection("notes").document()
        let dictionary: [String: Any] = ["title": note.title ?? "", "description": note.description ?? "", "id":document.documentID, "isDeleted": false, "hasReminder": false]
        document.setData(dictionary) { error in
            print("Saved")
        }
    }
    
    
    func updateData(index: Int, note: Note) {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        
        db.collection("users").document(user.uid).collection("notes").document(notes[index].uId!).setData(["title": note.title, "description": note.description], merge: true)
        
        collectionView?.reloadData()
    }
    
    
    func checkIfAlreadyLoggedIn(){
        NoteService.fetchData(isDeleted: false, hasReminder: false) { notes in
            DispatchQueue.main.async {
                self.notes = notes
                self.collectionView?.reloadData()
            }
        }
    }
}

extension HomeViewController: DataDeletionDelegate {
    
    func deleteData(index: Int) {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).collection("notes").document(notes[index].uId!).updateData(["isDeleted" : true]) { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.notes.remove(at: index)
                self.collectionView?.reloadData()
            }
        }
    }
    
}

extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        if !searchText.isEmpty
        {
            searching = true
            searchedNote.removeAll()
            
            for note in notes {
                if note.title!.lowercased().contains(searchText.lowercased()) {
                    searchedNote.append(note)
                    
                }
                
            }
            collectionView?.reloadData()
            emptyNote.isHidden = !(searchedNote.count == 0)
        }
        else
        {
            searching = false
            searchedNote.removeAll()
            emptyNote.isHidden = true
            //searchedNote = notes
            collectionView?.reloadData()
            
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchedNote.removeAll()
        collectionView?.reloadData()
    }
}

extension HomeViewController: SetReminderDelegate {
    func setReminder(index: Int) {
        print("djfh")
        
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).collection("notes").document(notes[index].uId!).updateData(["hasReminder" : true]) { err in
            if let err = err {
                print("Error Updating Reminder Field: \(err)")
            } else {
                print("Reminder Field Updated Successfully!")
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let setReminderVC = storyboard.instantiateViewController(withIdentifier: "SetReminderViewController") as? SetReminderViewController else { return }
        //setReminderVC.delegate = self
        setReminderVC.title = "Set Your Reminder"
        setReminderVC.titleString = notes[index].title
        self.navigationController?.pushViewController(setReminderVC, animated: true)
    }
}





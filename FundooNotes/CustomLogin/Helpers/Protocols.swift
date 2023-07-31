//
//  Protocols.swift
//  SideMenu
//
//  Created by YE002 on 07/07/23.
//

protocol HomeControllerDelegate {
    func handleMenuToggle(forMenuOptions menuOptions: MenuOptions?)
}

protocol DataPassDelegate {
    func dataPassing(title: String, description: String, uid: String, isDeleted: Bool, hasReminder: Bool)
}


protocol DataDeletionDelegate {
    func deleteData(index: Int)
    
}

protocol SetReminderDelegate {
    func setReminder(index: Int)
}

protocol DataRestorationDelegate {
    func restoreData(index: Int)
}

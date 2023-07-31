//
//  MenuOptions.swift
//  SideMenu
//
//  Created by YE002 on 07/07/23.
//

import UIKit

enum MenuOptions: Int, CustomStringConvertible {
    
    case Profile
    case Reminders
    case Trash
    case LogOut
    
    var description: String {
        switch self {
            
        case .Profile: return "Profile"
        case .Reminders: return "Show Reminders"
        case .Trash: return "Go to Trash"
        case .LogOut: return "Log Out"
        }
    }
    
    var image: UIImage {
        switch self {
            
        case .Profile: return UIImage(systemName: "person.crop.circle") ?? UIImage()
        case .Reminders: return UIImage(systemName: "calendar.badge.clock") ?? UIImage()
        case .Trash: return UIImage(systemName: "trash.circle.fill") ?? UIImage()
        case .LogOut: return UIImage(systemName: "lightswitch.off.square") ?? UIImage()
        }
    }
}

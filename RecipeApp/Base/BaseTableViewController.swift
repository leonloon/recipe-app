//
//  BaseTableViewController.swift
//  RecipeApp
//
//  Created by Leon Mah Kean Loon on 10/12/2020.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

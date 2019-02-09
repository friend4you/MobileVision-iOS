//
//  DetectionTypeTableViewController.swift
//  MobileVision
//
//  Created by Vlad Arsenyuk on 2/9/19.
//  Copyright © 2019 Arseniuk. All rights reserved.
//

import UIKit
import CoreImage

enum DetectionType: String {
    case face = "Human faces 💩"
    case text = "Text ✍🏻"
    case qrCode = "QRCodes ⿻"
    case rectangle = "Rectangles ◻️"
}

class DetectionTypeTableViewController: UITableViewController {

    let items: [DetectionType] = [.face, .text, .qrCode, .rectangle]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].rawValue
        cell.textLabel?.textColor = .white
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DetectionController.shared.changeDetection(with: items[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    
}

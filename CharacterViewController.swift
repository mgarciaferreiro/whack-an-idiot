//
//  CharacterViewController.swift
//  Project14
//
//  Created by Marta García Ferreiro on 5/18/17.
//  Copyright © 2017 Marta García Ferreiro. All rights reserved.
//

import UIKit
class CharacterViewController: UIViewController {
    
    @IBOutlet var badTable: UITableView!
    @IBOutlet var goodTable: UITableView!
    
    let characters = ["Donald Trump", "Hillary Clinton","Barack Obama", "Vladimir Putin", "Kim Jong Un", "Cute baby", "Meghan Healey"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        goodTable.reloadData()
        badTable.reloadData()
    }
    
    @IBAction func playButton(_ sender: UIButton) {
        if (SharingManager.sharedInstance.bad != "" && SharingManager.sharedInstance.good != ""){
           self.performSegue(withIdentifier: "mySegueID", sender: nil)
        }
    }
}

extension CharacterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        print(characters[6])
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            if(tableView == self.badTable){
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
                cell.textLabel?.font = UIFont(name: "MarkerFelt-Thin", size:28)
                cell.textLabel?.text = characters[indexPath.row]
                let imageName = UIImage(named: characters[indexPath.row].lowercased())
                cell.imageView?.image = imageName
                
                return cell
            }
            
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
                cell.textLabel?.font = UIFont(name: "MarkerFelt-Thin", size:28)
                cell.textLabel?.text = characters[indexPath.row]
                let imageName = UIImage(named: characters[indexPath.row].lowercased())
                cell.imageView?.image = imageName
                
                return cell
            }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAtIndexPath: IndexPath){
        
        if(tableView == self.badTable){
            let indexPath = tableView.indexPathForSelectedRow
            let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
            SharingManager.sharedInstance.bad = (currentCell.textLabel?.text?.lowercased())!
        }
        
        if(tableView == self.goodTable){
            let indexPath = tableView.indexPathForSelectedRow
            let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
            SharingManager.sharedInstance.good = (currentCell.textLabel?.text?.lowercased())!
        }
    }
}

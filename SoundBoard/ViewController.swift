//
//  ViewController.swift
//  SoundBoard
//
//  Created by Derek Jacobs on 2017-04-04.
//  Copyright © 2017 Derek Jacobs. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var audioPlayer : AVAudioPlayer? = nil //need for playback
    
    var sounds : [Sound] = [] //dummy array to fill the tableview
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            sounds = try context.fetch(Sound.fetchRequest()) //grab from core data
            tableView.reloadData() //reload the screen
        } catch {}
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count //standard number in array
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let sound = sounds[indexPath.row]
        
        cell.textLabel?.text = sound.name
        
        return cell
    }
    
    // function for once we click a cell we want to do something
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row] //getting whatever is in that cell
        
        //need to create audio player
        do {
            audioPlayer =  try AVAudioPlayer(data: sound.audio! as Data) //playing NSData as data
            audioPlayer?.play() //play button with this, entire thing is thrown so must have do/ catch
        } catch {}
        tableView.deselectRow(at: indexPath, animated: true) //makes sure it isn't still selected after selection
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // code for deleting things, can be doing edits as well
        
        if editingStyle == .delete {
            print("Yesh Delete")
            let sound = sounds[indexPath.row] // access sound that is in that cell
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // bring context
            context.delete(sound) //delete that sound element 
            (UIApplication.shared.delegate as! AppDelegate).saveContext() // save changes to core data
            do {
                sounds = try context.fetch(Sound.fetchRequest()) //grab from core data
                tableView.reloadData() //reload the screen
            } catch {}
            
            
        }
    }
    
}


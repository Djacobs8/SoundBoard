//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Derek Jacobs on 2017-04-04.
//  Copyright © 2017 Derek Jacobs. All rights reserved.
//

import UIKit
import AVFoundation // importing libraries of code Apple has written already

class SoundViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var audioRecorder : AVAudioRecorder? = nil // needs custom init, NEEDS to be optional
    var audioPlayer : AVAudioPlayer? = nil
    var audioURL : URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setUpRecorder() {
        do {
            // create audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true) // tries and if it fails it stops running and jumps into the catch section
            
            // create url for audio file on the phone
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! //creates array, know the first object is there
            let pathComponents = [basePath, "audio.m4a"] // name for file and attaching it to the array
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)! // mashing name and directory together to give URL
            
            
            // create settings for the audiorecorder
            var settings : [String:Any] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            settings[AVSampleRateKey] = 44100.0
            settings[AVNumberOfChannelsKey] = 2
            
            // create audiorecorder object
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder!.prepareToRecord()
        } catch let error as NSError {
            // display something to user, restart process, get feedback for debugging, can add multiple catch
            print(error)
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording == true {
            // stop recording
            audioRecorder?.stop()
            
            // change button title to "record"
            recordButton.setTitle("Record", for: .normal)
            
            //enable play and add buttons 
            playButton.isEnabled = true
            addButton.isEnabled = true
            
        } else {
            // start the recording
            audioRecorder?.record()
            
            // change the button to "stop"
            recordButton.setTitle("Stop", for: .normal)
        }
        
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
            //recordButton.isEnabled = false // want to have record disabled during play (maybe later?)
        } catch {
            
        }
        
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //where in the data I'm finding these I THINK 
        let sound = Sound(context: context)
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext() // save to core data mang
        
        navigationController!.popViewController(animated: true) // shut that shit down
        
    }
}

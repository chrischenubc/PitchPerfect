//
//  RecordButtonViewController.swift
//  PitchPerfect
//
//  Created by ChenChris on 2017-09-15.
//  Copyright © 2017 ChenChris. All rights reserved.
//

import UIKit
import AVFoundation

class RecordButtonViewController: UIViewController, AVAudioRecorderDelegate {

    
    @IBOutlet weak var TapToRecord: UILabel!
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var StopButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear")
        
        StopButton.isEnabled=false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: action function for Record Button
    @IBAction func RecordButton(_ sender: Any) {
        print("Button has pressed")
        TapToRecord.text="Is Recording...."
        StopButton.isEnabled=true
        RecordButton.isEnabled=false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath as Any)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    // MARK: action function for stop button
    @IBAction func StopButton(_ sender: Any) {
        
        TapToRecord.text="Tap to Record"
        RecordButton.isEnabled=true
        StopButton.isEnabled=false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    // MARK: perform segue to PlaySoundsVC when finish recording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            print("Recording failed")
        }
    }
    
    // MARK: prepare seague
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL=recordedAudioURL
        }
    }
    
    // MARK: ButtonSwitch function to be done
    func ButtonSwitch(_ RecordButtonState:Bool, StopButtonState:Bool) {
        RecordButton.isEnabled = RecordButtonState
        StopButton.isEnabled = StopButtonState
    }
    

}


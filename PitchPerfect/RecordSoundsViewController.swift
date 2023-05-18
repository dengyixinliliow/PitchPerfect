//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by emily deng on 5/2/23.
//

import UIKit
// audio processor library
import AVFoundation

//delegate = 委托 ask the class to do smt and report back when the task finished
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    //give us the instance to user the audio recorder: use it for start and stop recording
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        //view has been loaded into memory
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecordingButton.isEnabled = false
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("view will appear!")
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print("view did appear!")
//    }

    @IBAction func recordAudio(_ sender: Any) {
        configureUI(isRecording: true)
        
        //need a place to store recording
        let dirpath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirpath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
//        print(filePath)
        
        //av audio session is what required to store or play video/audio
        //sharedinstance is default -> audio hardware
        let session = AVAudioSession.sharedInstance()
        //set the session for playing the audio
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //from delegate => report back to class! finished!!!
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    func configureUI(isRecording: Bool) {
           stopRecordingButton.isEnabled = isRecording // to disable the button
           recordButton.isEnabled = !isRecording // to enable the button
           recordingLabel.text = !isRecording ? "Tap to Record" : "Recording in Progress"

       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //make sure is the board we want to use
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}



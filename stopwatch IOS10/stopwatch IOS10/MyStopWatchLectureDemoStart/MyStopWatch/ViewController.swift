//
//  ViewController.swift
//  MyStopWatch
//
//  Created by J.A. Korten on 20-04-17.
//  Copyright © 2017 HAN University of Applied Sciences Educational. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer : Timer?
    var elapsedTimer : Timer?
        
    var startTime : Date? = nil
    var timedTime : Date? = nil

    var diffTime = 0.0 // difference of stopwatch time with current time
    
      @IBOutlet weak var currentTimeLabel: UILabel!
      @IBOutlet weak var elapsedTimeLabel: UILabel!
      @IBOutlet weak var pauseResumeBtn: UIButton!
    @IBOutlet weak var startResetBtn: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This timer is used for displaying current time:
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTime() {
        currentTimeLabel.text = getCurrentTime()
    }
    
    func updateElapsedTime() {
        elapsedTimeLabel.text = getElapsedTime()
    }

    @IBAction func startTimeAction(_ sender: Any) {
        
        if (startResetBtn.currentTitle == "Start") {
            startResetBtn.setTitle("Reset", for: .normal)
              // 1. remember current moment as starting time for stopwatch
            startTime = Date()
            // Reset stopwatch timer (elapsedTimer):
            
            // 2. stop elapsedTimer (invalidate) as precaution
            elapsedTimer?.invalidate()
            // 3. activate elapsedTimer
            elapsedTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
            
            // 4. enable pause button
            pauseResumeBtn.isEnabled = true
          
        } else {
            //if reset..
            startResetBtn.setTitle("Start", for: .normal)
            
            // 1. stop elapsedTimer (invalidate)
            elapsedTimer?.invalidate()
            // 2. set title for pauseResumeBtn to "Pause" precaution
            pauseResumeBtn.setTitle("Pause", for: .normal)
            // 3. disable pause button
            pauseResumeBtn.isEnabled = false
            // 4. set elapsedTimeLabel to "00:00:00:00"
            elapsedTimeLabel.text = "00:00:00:00"
        }
    }
    
    @IBAction func pauseResumeAction(_ sender: UIButton) {
        
        if (pauseResumeBtn.currentTitle == "Pause") {
            pauseResumeBtn.setTitle("Resume", for: .normal)
            // 1. stop elapsedTimer
            elapsedTimer?.invalidate()

        } else {
            let stopWatchInterval = diffTime * -1
            
            // 2. set new startTime using stopWatchInterval 
            // Tip! Date has an overloaded method timeInterval ... since
            startTime = Date(timeInterval: stopWatchInterval, since: Date())
            // 3. set title of pauseResumeBtn to "Pause"
            pauseResumeBtn.setTitle("Pause", for: .normal)
            // 4. stop elapsedTimer (invalidate) as precaution
            elapsedTimer?.invalidate()
            // 5.enable elapsedTimer (and call updateElapsedTime)
                  elapsedTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
            
        }
    }
    
    
    // Time helper methods

    
    func getCurrentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let sHours = String(format: "%02d", hour)
        let sMinutes = String(format: "%02d", minutes)
        let sSeconds = String(format: "%02d", seconds)
        
        return "\(sHours):\(sMinutes):\(sSeconds)"
    }
    
    func getElapsedTime() -> String {
        
        let time = Date().timeIntervalSince(startTime!)
        diffTime = time // difference of stopwatch time with current time
        
        let h = round(time / 3600) // 60 * 60 * 60 = uren
        let sHours = String(h)
        
        let m = (time - (3600*h)) / 60 // minuten
        let sMinutes = String(m)
        let s = Int(round(time)) % 60 // seconden
        let sSeconds = String(s)
        
        let n = Int(round(time*100)) % 60 // milliseconden
        let nSeconds = String(n)
        
        let elapsedTimeString = "\(sHours):\(sMinutes):\(sSeconds):\(nSeconds)"
        
        return elapsedTimeString
    }


}

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        
        return end - start
    }
}


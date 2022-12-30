//
//  ViewController.swift
//  BackgroundTimerThread
//
//  Created by Ariel Waraney on 29/12/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var timerCounting: Bool = false
    var startTime:Date?
    var stopTime:Date?
    
    let userDefaults = UserDefaults.standard
    let START_TIME_KEY = "startTime"
    let STOP_TIME_KEY = "stopTime"
    let COUNTING_KEY = "countingKey"
    
    var scheduledTimer: Timer!
    var countTimerSeconds: Int = 0
    
    let circularProgress = CircularProgressBarView(frame: .zero)
    var circularViewDuration: TimeInterval = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCircularProgressBarView()
        // Do any additional setup after loading the view.
        startTime = userDefaults.object(forKey: START_TIME_KEY) as? Date
        stopTime = userDefaults.object(forKey: STOP_TIME_KEY) as? Date
        timerCounting = userDefaults.bool(forKey: COUNTING_KEY)
        
        //if app re-open after close
        if timerCounting {
            startTimer()
        }
        else {
            stopTimer()
            if let start = startTime {
                if let stop = stopTime {
                    let time = calcRestartTime(start: start, stop: stop)
                    let diff = Date().timeIntervalSince(time)
                    setTimeLabel(Int(diff))
                }
            }
        }
    }
    
    @IBAction func startStopPressed(_ sender: Any) {
        if timerCounting {
            setStopTime(date: Date())
            stopTimer()
        } else {
            if let stop = stopTime {
                let restartTime = calcRestartTime(start: startTime!, stop: stop)
                setStopTime(date: nil)
                setStartTime(date: restartTime)
            }
            else {
                setStartTime(date: Date())
            }
            startTimer()
        }
    }
    
    func calcRestartTime(start: Date, stop: Date) -> Date {
        let diff = start.timeIntervalSince(stop)
        return Date().addingTimeInterval(diff)
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        setStopTime(date: nil)
        setStartTime(date: nil)
        timerLabel.text = makeTimeString(hour: 0, min: 0, sec: 0)
        circularProgress.progressAnimation(duration: 1, value: 0)
        stopTimer()
    }
    
    func setStartTime(date: Date?){
        startTime = date
        userDefaults.set(startTime, forKey: START_TIME_KEY)
    }
    
    func setStopTime(date: Date?){
        stopTime = date
        userDefaults.set(stopTime, forKey: STOP_TIME_KEY)
    }
    
    func setTimerCounting(_ val: Bool){
        timerCounting = val
        userDefaults.set(timerCounting, forKey: COUNTING_KEY)
    }
    
    func stopTimer(){
        if scheduledTimer != nil {
            scheduledTimer.invalidate()
        }
        setTimerCounting(false)
        print("total time : \(countTimerSeconds)")
        startStopButton.setTitle("START", for: .normal)
        startStopButton.setTitleColor(UIColor.systemGreen, for: .normal)
    }
    
    func startTimer(){
        scheduledTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(refreshValue), userInfo: nil, repeats: true)
        setTimerCounting(true)
        startStopButton.setTitle("STOP", for: .normal)
        startStopButton.setTitleColor(UIColor.red, for: .normal)
    }
    
    @objc func refreshValue(){
        if let start = startTime {
            let diff = Date().timeIntervalSince(start)
            setTimeLabel(Int(diff))
            setRingAnimation(Int(diff))
        }
        else {
            stopTimer()
            setTimeLabel(0)
        }
    }
    
    func setRingAnimation(_ val: Int) {
        let time = secondsToHoursMinutesSeconds(val)
        let totalseconds = (time.0 * 3600) + (time.1 * 60) + time.2
        countTimerSeconds = totalseconds
        let progressValue = Float(TimeInterval(totalseconds) / circularViewDuration)
        circularProgress.progressAnimation(duration: 0.1, value: progressValue)
    }
    
    func setTimeLabel(_ val: Int){
        let time = secondsToHoursMinutesSeconds(val)
        let timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        timerLabel.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(_ ms: Int) -> (Int, Int, Int) {
        let hour = ms/3600
        let min = (ms % 3600) / 60
        let sec = (ms % 3600) % 60
        return (hour, min, sec)
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hour)
        timeString += ":"
        timeString += String(format: "%02d", min)
        timeString += ":"
        timeString += String(format: "%02d", sec)
        return timeString
    }
    
    //MARK: - Ring Animation
    func setUpCircularProgressBarView(){
        circularProgress.createCircularPath()
        circularProgress.center = view.center
        view.addSubview(circularProgress)
    }
    
    func getFinalSeconds(_ val: Int) {
        print("total time (seconds): ")
    }
}


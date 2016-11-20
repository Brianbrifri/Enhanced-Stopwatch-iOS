import Foundation

protocol StopwatchModelDelegate: class {
	func lapWasAdded()
	func timerUpdated(with timestamp: TimeInterval)
	func lapUpdated(with timestamp: TimeInterval)
	func updateLapResetButton(forState runningState: RunState)
	func updateStartStopButton(forState runningState: RunState)
	func resetDefaults()
}

extension StopwatchModelDelegate {
    func lapWasAdded() {}
    func timerUpdated(with timestamp: TimeInterval) {}
    func lapUpdated(with timestamp: TimeInterval) {}
    func updateLapResetButton(forState runningState: RunState) {}
    func updateStartStopButton(forState runningState: RunState) {}
    func resetDefaults() {}
}

class StopwatchModel {
	
	var delegate = MulticastDelegate<StopwatchModelDelegate>()
    fileprivate(set) var laps: [TimeInterval] = []
    fileprivate var timer: Timer?
	fileprivate var runState: RunState
	
	fileprivate var startTime: Date?
	fileprivate var lapStartTime: Date?
	fileprivate var masterTimeInterval: TimeInterval = 0
	fileprivate var lapTimeInterval: TimeInterval = 0
    
    fileprivate let quitNotification = Notification.Name(rawValue: "quitNotification")
    
    //public vars to hold the indexes of the fastest and slowest times
    var fastestIndex = 0
    var slowestIndex = 0
	
	init() {
        //Get persistence, get lap data (if any), get saveState and update the app based on its saveState
        let persistence = LapsPersistence()
        laps = persistence.fetchLapData()
        let saveState = persistence.retreiveSaveState()
        print(saveState.time, saveState.lapTime, saveState.runState)
        switch saveState.runState {
        case RunState.reset.rawValue:
            runState = .reset
        case RunState.started.rawValue:
            masterTimeInterval = saveState.time
            lapTimeInterval = saveState.lapTime
            runState = .stopped
            startStopPressed()
        case RunState.stopped.rawValue:
            runState = .stopped
        default:
            runState = .reset
        }
        fastSlowLaps()
        
        //Set up notification center to be able to call the saveState function when the app quits
        let nc = NotificationCenter.default
        nc.addObserver(forName: quitNotification, object: nil, queue: nil, using: catchNotification)
	}
    
    //Function to save the state of the app when the notification gets called
    func catchNotification(notification: Notification) {
        guard let userInfo = notification.userInfo, let message = userInfo["message"] as? String else {
            return
        }
        print(message)
        let persistence = LapsPersistence()
        persistence.updateSaveState(with: masterTimeInterval, lapTime: lapTimeInterval, runState: runState.rawValue)
    }
    
    //Update the buttons in the viewController whenever it is finished loading
    func viewControllerDoneInit() {
        delegate |> { delegate in delegate.updateLapResetButton(forState: runState) }
        delegate |> { delegate in delegate.updateStartStopButton(forState: runState) }
    }
	
	func lapResetPressed() {
		switch (runState) {
		case .started:
			addLap()
		case .stopped:
			runState = .reset
			invalidateTimer()
            delegate |> { delegate in delegate.resetDefaults() }
			return
		case .reset:
			break
		}
		
        delegate |> { delegate in delegate.updateLapResetButton(forState: runState) }
	}
	
	func startStopPressed() {
		switch (runState) {
		case .started:
			//Stop the timer
			if let startDate = startTime, let lapDate = lapStartTime {
				masterTimeInterval += Date().timeIntervalSince(startDate)
				lapTimeInterval += Date().timeIntervalSince(lapDate)
			}
			timer?.invalidate()
			runState = .stopped
		case .stopped:
			runState = .started
			fallthrough
		case .reset:
			startTime = Date()
			lapStartTime = startTime
			timer = Timer(timeInterval: 0.001, target: self, selector: #selector(StopwatchModel.updateTimeInterval(_:)), userInfo: nil, repeats: true)
			RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
			runState = .started
		}
        delegate |> { delegate in delegate.updateStartStopButton(forState: runState) }
        delegate |> { delegate in delegate.updateLapResetButton(forState: runState) }
	}
    
    //Saves the lap to Core Data
    fileprivate func saveLap(lapTime: TimeInterval) {
        let lapsPersistence = LapsPersistence()
        lapsPersistence.insertLapData(from: lapTime)
    }
    
    //Updates the lapArray with any data from Core Data
    fileprivate func updataLapArray() {
        let lapsPersistence = LapsPersistence()
        laps = lapsPersistence.fetchLapData()
    }
    
    //Deletes the data from Core Data if reset is pressed
    fileprivate func deleteLaps() {
        let lapsPersistence = LapsPersistence()
        lapsPersistence.deleteLaps()
        fastestIndex = 0
        slowestIndex = 0
    }
	
	fileprivate func addLap() {
		guard let lapTime = lapStartTime else {
			return
		}
		let value = Date().timeIntervalSince(lapTime) + lapTimeInterval
		lapStartTime = Date()
		lapTimeInterval = 0
        saveLap(lapTime: value)
        updataLapArray()
        checkNewLap(value)
        delegate |> { delegate in delegate.lapWasAdded() }
        delegate |> { delegate in delegate.lapUpdated(with: lapTimeInterval) }
	}
	
	@objc func updateTimeInterval(_ timer: AnyObject) {
		guard let lapTime = lapStartTime,
			let watchTime = startTime else {
			return
		}
		let lapValue = Date().timeIntervalSince(lapTime) + lapTimeInterval
		let stopWatchValue = Date().timeIntervalSince(watchTime) + masterTimeInterval
        delegate |> { delegate in delegate.lapUpdated(with: lapValue) }
        delegate |> { delegate in delegate.timerUpdated(with: stopWatchValue) }
	}
	
	fileprivate func invalidateTimer() {
		timer?.invalidate()
		masterTimeInterval = 0
		lapTimeInterval = 0
        deleteLaps()
        updataLapArray()
	}
    
    //Check to see if a new lap that was added is either the 
    //fastest or slowest and update an index accordingly
    fileprivate func checkNewLap(_ lap: TimeInterval) {
        if lap > laps[slowestIndex] {
            slowestIndex = laps.count - 1
        }
        if lap < laps[fastestIndex] {
            fastestIndex = laps.count - 1
        }
    }
    
    //When the model is initialized, go through the array of laps
    //and set which ones are the fastest and slowest
    fileprivate func fastSlowLaps() {
        for i in 0..<laps.count {
            if laps[i] > laps[slowestIndex] {
                slowestIndex = i
            }
            if laps[i] < laps[fastestIndex] {
                fastestIndex = i
            }
        }
    }
}

import Foundation

protocol StopwatchModelDelegate: class {
	func lapWasAdded()
	func timerUpdated(with timestamp: TimeInterval)
	func lapUpdated(with timestamp: TimeInterval)
	func updateLapResetButton(forState runningState: RunState)
	func updateStartStopButton(forState runningState: RunState)
	func resetDefaults()
}

class StopwatchModel {
	
	weak var delegate: StopwatchModelDelegate?
    fileprivate(set) var laps: [TimeInterval] = []
    fileprivate var timer: Timer?
	fileprivate var runState: RunState
	
	fileprivate var startTime: Date?
	fileprivate var lapStartTime: Date?
	fileprivate var masterTimeInterval: TimeInterval = 0
	fileprivate var lapTimeInterval: TimeInterval = 0
    
    var fastestIndex = 0
    var slowestIndex = 0
	
	init(delegate: StopwatchModelDelegate) {
		self.delegate = delegate
        let persistence = LapsPersistence()
        laps = persistence.fetchLapData()
        switch laps.count {
        case 0:
            runState = .reset
        default:
            runState = .stopped
        }
        fastSlowLaps()
	}
    
    func viewControllerDoneInit() {
        delegate?.updateLapResetButton(forState: runState)
    }
	
	func lapResetPressed() {
		switch (runState) {
		case .started:
			addLap()
		case .stopped:
			runState = .reset
			invalidateTimer()
			delegate?.resetDefaults()
			return
		case .reset:
			break
		}
		
		delegate?.updateLapResetButton(forState: runState)
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
		delegate?.updateStartStopButton(forState: runState)
		delegate?.updateLapResetButton(forState: runState)
	}
    
    fileprivate func saveLap(lapTime: TimeInterval) {
        let lapsPersistence = LapsPersistence()
        lapsPersistence.insertLapData(from: lapTime)
    }
    
    fileprivate func updataLapArray() {
        let lapsPersistence = LapsPersistence()
        laps = lapsPersistence.fetchLapData()
    }
    
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
		delegate?.lapWasAdded()
		delegate?.lapUpdated(with: lapTimeInterval)
	}
	
	@objc func updateTimeInterval(_ timer: AnyObject) {
		guard let lapTime = lapStartTime,
			let watchTime = startTime else {
			return
		}
		let lapValue = Date().timeIntervalSince(lapTime) + lapTimeInterval
		let stopWatchValue = Date().timeIntervalSince(watchTime) + masterTimeInterval
		delegate?.lapUpdated(with: lapValue)
		delegate?.timerUpdated(with: stopWatchValue)
	}
	
	fileprivate func invalidateTimer() {
		timer?.invalidate()
		masterTimeInterval = 0
		lapTimeInterval = 0
        deleteLaps()
        updataLapArray()
	}
    
    fileprivate func checkNewLap(_ lap: TimeInterval) {
        switch laps.count {
        case 0...2:
            if lap > laps[slowestIndex] {
                slowestIndex = laps.count - 1
            } else {
                fastestIndex = laps.count - 1
            }
        default:
            if lap > laps[slowestIndex] {
                slowestIndex = laps.count - 1
            }
            else if lap < laps[fastestIndex] {
                fastestIndex = laps.count - 1
            }
            else {
                print("No change")
            }
        }
    }
    
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

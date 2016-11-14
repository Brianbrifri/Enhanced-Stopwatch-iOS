import UIKit

class StopwatchViewController: UIViewController {

	@IBOutlet weak var lapResetButton: ControlButtonView!
	@IBOutlet weak var startStopButton: ControlButtonView!
	@IBOutlet weak var lapsTableView: UITableView!
    @IBOutlet weak var timerView: UIView!
	
	fileprivate(set) var model: StopwatchModel!
    fileprivate var pageViewController: PageViewController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		model = StopwatchModel(delegate: self)
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "TimerController") as! PageViewController
        self.timerView.addSubview(pageViewController.view)
        pageViewController.view.frame = timerView.frame
		setupDefaults()
	}
    
    
	
	func setupDefaults() {
		lapResetButton.isEnabled = false
		lapResetButton.titleLabel.text = "Lap"
		startStopButton.titleLabel.text = "Start"
        model?.viewControllerDoneInit()
		lapsTableView.reloadData()
	}

	@IBAction func lapResetButtonPressed(_ sender: AnyObject) {
		model.lapResetPressed()
	}
	
	@IBAction func startStopButtonPressed(_ sender: AnyObject) {
		model.startStopPressed()
		lapResetButton.isEnabled = true
	}
	
	fileprivate func formatTimeIntervalToString(_ time: TimeInterval) -> (minutes: String, seconds: String, milliseconds: String) {
		let minutes = (Int(time) / 60) % 60
		let seconds = Int(time) % 60
		let milliSeconds = Int(time * 100) % 100
		return (String(format: "%02d", minutes), String(format: "%02d", seconds), String(format: "%02d", milliSeconds))
	}
}

// MARK: - Table View DataSource Methods
extension StopwatchViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return model.laps.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Lap Cell", for: indexPath) as! LapCellTableViewCell
		
		let reverseIndex = model.laps.count - 1 - (indexPath as NSIndexPath).row
		let lap = model.laps[reverseIndex]
		let formatted = formatTimeIntervalToString(lap)
		cell.lapNumberLabel.text = "Lap \(reverseIndex + 1)"
		cell.lapTimeLabel.text = "\(formatted.minutes):\(formatted.seconds).\(formatted.milliseconds)"
        if model.laps.count > 1 {
            if reverseIndex == model.fastestIndex {
                cell.lapTimeLabel.textColor = UIColor.green
                cell.lapNumberLabel.textColor = UIColor.green
            }
            else if reverseIndex == model.slowestIndex {
                cell.lapTimeLabel.textColor = UIColor.red
                cell.lapNumberLabel.textColor = UIColor.red
            }
            else {
                cell.lapTimeLabel.textColor = UIColor.white
                cell.lapNumberLabel.textColor = UIColor.white
            }
        }

        
		
		return cell
	}
}

// MARK: - Stopwatch Model Delegate Methods
extension StopwatchViewController: StopwatchModelDelegate {
	
	func lapWasAdded() {
		lapsTableView.reloadData()
	}
	
	func timerUpdated(with timestamp: TimeInterval) {

	}
	
	func lapUpdated(with timestamp: TimeInterval) {

	}
	
	func updateLapResetButton(forState runningState: RunState) {
		switch (runningState) {
		case .stopped:
            lapResetButton.isEnabled = true
			lapResetButton.titleLabel.text = "Reset"
		case .started, .reset:
			lapResetButton.titleLabel.text = "Lap"
		}
	}
	
	func updateStartStopButton(forState runningState: RunState) {
		switch (runningState) {
		case .stopped, .reset:
			startStopButton.titleLabel.text = "Start"
			startStopButton.borderColor = UIColor.green
		case .started:
			startStopButton.titleLabel.text = "Stop"
			startStopButton.borderColor = UIColor.red
		}
	}
	
	func resetDefaults() {
		setupDefaults()
	}
}




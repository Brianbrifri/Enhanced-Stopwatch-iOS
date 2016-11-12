import UIKit

class StopwatchViewController: UIViewController {

	@IBOutlet weak var lapMinutesLabel: UILabel!
	@IBOutlet weak var lapSecondsLabel: UILabel!
	@IBOutlet weak var lapMillisecondsLabel: UILabel!
	@IBOutlet weak var minutesLabel: UILabel!
	@IBOutlet weak var secondsLabel: UILabel!
	@IBOutlet weak var millisecondsLabel: UILabel!
	@IBOutlet weak var lapResetButton: ControlButtonView!
	@IBOutlet weak var startStopButton: ControlButtonView!
	@IBOutlet weak var lapsTableView: UITableView!
	
	fileprivate(set) var model: StopwatchModel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		model = StopwatchModel(delegate: self)
		setupDefaults()
	}
	
	func setupDefaults() {
		minutesLabel.text = "00"
		secondsLabel.text = "00"
		millisecondsLabel.text = "00"
		lapMinutesLabel.text = "00"
		lapSecondsLabel.text = "00"
		lapMillisecondsLabel.text = "00"
		lapResetButton.isEnabled = false
		lapResetButton.titleLabel.text = "Lap"
		startStopButton.titleLabel.text = "Start"
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
		
		return cell
	}
}

// MARK: - Stopwatch Model Delegate Methods
extension StopwatchViewController: StopwatchModelDelegate {
	
	func lapWasAdded() {
		lapsTableView.reloadData()
	}
	
	func timerUpdated(with timestamp: TimeInterval) {
		let value = formatTimeIntervalToString(timestamp)
		minutesLabel.text = value.minutes
		secondsLabel.text = value.seconds
		millisecondsLabel.text = value.milliseconds
	}
	
	func lapUpdated(with timestamp: TimeInterval) {
		let value = formatTimeIntervalToString(timestamp)
		lapMinutesLabel.text = value.minutes
		lapSecondsLabel.text = value.seconds
		lapMillisecondsLabel.text = value.milliseconds
	}
	
	func updateLapResetButton(forState runningState: RunState) {
		switch (runningState) {
		case .stopped:
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




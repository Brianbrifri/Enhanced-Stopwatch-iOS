import UIKit


class StopwatchViewController: UIViewController {

	@IBOutlet weak var lapResetButton: ControlButtonView!
	@IBOutlet weak var startStopButton: ControlButtonView!
	@IBOutlet weak var lapsTableView: UITableView!
    @IBOutlet weak var timerView: UIView!
    
	fileprivate(set) var model: StopwatchModel!
    fileprivate var pageViewController: PageViewController!
    fileprivate var currentLapCell: LapCellTableViewCell!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		model = StopwatchModel()
        model.delegate.addDelegate(delegte: self)
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "TimerController") as! PageViewController
        let analogPage = storyboard?.instantiateViewController(withIdentifier: "Analog")
        let digitalPage = storyboard?.instantiateViewController(withIdentifier: "Digital")
        model.delegate.addDelegate(delegte: analogPage as! StopwatchModelDelegate)
        model.delegate.addDelegate(delegte: digitalPage as! StopwatchModelDelegate)
        pageViewController.addChildViewControllers(digitalPage!)
        pageViewController.addChildViewControllers(analogPage!)
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
}

// MARK: - Table View DataSource Methods
extension StopwatchViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.laps.count + 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Lap Cell", for: indexPath) as! LapCellTableViewCell
		
		let reverseIndex = model.laps.count - (indexPath as NSIndexPath).row
        if reverseIndex == model.laps.count {
            cell.lapNumberLabel.text = "Lap \(reverseIndex + 1)"
            cell.lapTimeLabel.text = "00:00.00"
            cell.lapTimeLabel.textColor = UIColor.white
            cell.lapNumberLabel.textColor = UIColor.white
            currentLapCell = cell
        }
        else {
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
        }
		return cell
	}
}

// MARK: - Stopwatch Model Delegate Methods
extension StopwatchViewController: StopwatchModelDelegate {
	
	func lapWasAdded() {
		lapsTableView.reloadData()
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
    
    func lapUpdated(with timestamp: TimeInterval) {
        let formatted = formatTimeIntervalToString(timestamp)
        currentLapCell.lapTimeLabel.text = "\(formatted.minutes):\(formatted.seconds).\(formatted.milliseconds)"
    }
	
	func resetDefaults() {
		setupDefaults()
	}
}


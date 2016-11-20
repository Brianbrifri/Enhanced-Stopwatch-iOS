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
        
        //Get the page controller by ID from the storyboard and attach it
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "TimerController") as! PageViewController
        
        //Get viewControllers from storyboard by ID, add them as delegates to the model delegate
        //and add them to the pageViewController array
        let analogPage = storyboard?.instantiateViewController(withIdentifier: "Analog")
        let digitalPage = storyboard?.instantiateViewController(withIdentifier: "Digital")
        model.delegate.addDelegate(delegte: analogPage as! StopwatchModelDelegate)
        model.delegate.addDelegate(delegte: digitalPage as! StopwatchModelDelegate)
        pageViewController.addChildViewControllers(digitalPage!)
        pageViewController.addChildViewControllers(analogPage!)
        
        //Add the pageControllerView as a subview of the timerView
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
    
    //Return the number of laps in the model + 1 to be able to get an extra cell for the current lap time
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.laps.count + 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Lap Cell", for: indexPath) as! LapCellTableViewCell
		
		let reverseIndex = model.laps.count - (indexPath as NSIndexPath).row
        
        //If the index is at exactly the size of the array of laps, i.e. out of bounds by 1,
        //then use that location in the tableView for the currentLapCell
        if reverseIndex == model.laps.count {
            cell.lapNumberLabel.text = "Lap \(reverseIndex + 1)"
            cell.lapTimeLabel.text = "00:00.00"
            cell.lapTimeLabel.textColor = UIColor.white
            cell.lapNumberLabel.textColor = UIColor.white
            currentLapCell = cell
        }
            
        //Otherwise, proceed as normal and set up the cells
        else {
            let lap = model.laps[reverseIndex]
            let formatted = formatTimeIntervalToString(lap)
            cell.lapNumberLabel.text = "Lap \(reverseIndex + 1)"
            cell.lapTimeLabel.text = "\(formatted.minutes):\(formatted.seconds).\(formatted.milliseconds)"
            if model.laps.count > 1 {
                
                //If index is equal to the saved index of the fastest time, make it green
                if reverseIndex == model.fastestIndex {
                    cell.lapTimeLabel.textColor = UIColor.green
                    cell.lapNumberLabel.textColor = UIColor.green
                }
                
                //If index is equal to the saved index of the slowest time, make it red
                else if reverseIndex == model.slowestIndex {
                    cell.lapTimeLabel.textColor = UIColor.red
                    cell.lapNumberLabel.textColor = UIColor.red
                }
                    
                //Otherwise, make it white
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
            lapResetButton.isEnabled = true
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


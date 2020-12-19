
import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    var roll = RollGroup()
    var lastAdded = 0
    var lastPress = Date()
    var showSettings = false
    var startLocation = CGPoint.zero
    var currentPanGesture = Optional<UIPanGestureRecognizer>.none
    
    @IBOutlet var rollLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var settingsView: UIStackView!
    @IBOutlet var gearIndicator: UIView!
    @IBOutlet var statsIndicator: UIView!
    @IBOutlet var rightIndicator: UIView!
    @IBOutlet var leftIndicator: UIView!
    @IBOutlet var historyContainer: UIView!
    @IBOutlet var historyContainerHeight: NSLayoutConstraint!
    
    var historyVC: HistoryVC!
    
    var orignalTransform : CGAffineTransform = CGAffineTransform()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        historyContainerHeight.constant = historyContainer.frame.height - historyContainer.frame.height.truncatingRemainder(dividingBy: 24)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orignalTransform = totalLabel.transform
        
        updateRollLabel()
        updateTotalLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setColors()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "history" {
            historyVC = (segue.destination as! HistoryVC)
        }
    }
    
    func setColors() {
        view.window?.tintColor = Theme.current.tintColor
        gearIndicator.backgroundColor = Theme.current.tintColor
        statsIndicator.backgroundColor = Theme.current.tintColor
        leftIndicator.backgroundColor = Theme.current.tintColor
        rightIndicator.backgroundColor = Theme.current.tintColor
        view.backgroundColor = Theme.current.backgroundColor
        historyVC.setColors()
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func updateTotalLabel(animate: Bool = true) {
        totalLabel.text = roll.totalString()
        if animate {
            totalLabel.transform = self.orignalTransform.scaledBy(x: 1.3, y: 1.3)
            UIView.animate(withDuration: 0.75, animations: { [self] in
                totalLabel.transform = self.orignalTransform
            })
        }
    }
    
    func updateRollLabel() {
        rollLabel.text = roll.rollString()
    }
    
    fileprivate func addCurrentRollToHistory(isNewGroup: Bool) {
        if isNewGroup {
            historyVC.data.append(roll)
            historyVC.insertTop()
        } else {
            historyVC.data[historyVC.data.count - 1] = roll
            historyVC.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
        }
    }
    
    @IBAction func addDice(_ sender: UITapGestureRecognizer) {
        let die = sender.view!.tag
        
        let isNewGroup = lastAdded != die || lastPress.timeIntervalSinceNow < -0.75
        
        if isNewGroup {
            roll = RollGroup()
        }
        lastPress = Date()
        
        roll.rolls.append(Roll(die: die))
        updateRollLabel()
        updateTotalLabel()
        
        addCurrentRollToHistory(isNewGroup: isNewGroup)
        
        lastAdded = die
    }
    
    @IBAction func swipeUp(_ sender: UIPanGestureRecognizer) {
        guard currentPanGesture == nil || sender == currentPanGesture else { return }
        let die = sender.view!.tag
        
        switch sender.state {
        case .began:
            currentPanGesture = sender
            roll = RollGroup()
            startLocation = sender.location(in: self.view)
            
        case .changed:
            let currentLocation = sender.location(in: view)
            let dy =  self.startLocation.y - currentLocation.y
            
            let groupSize = max(1, Int(dy / 20.0))
            
            while roll.rolls.count > groupSize {
                roll.rolls.removeLast()
            }
            while roll.rolls.count < groupSize {
                roll.rolls.append(Roll(die: die))
            }
            updateRollLabel()
        default:
            updateTotalLabel()
            addCurrentRollToHistory(isNewGroup: true)
            currentPanGesture = nil
        }
        lastAdded = die
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            
            let velocity = gestureRecognizer.velocity(in: gestureRecognizer.view)
            return abs(velocity.x) < abs(velocity.y)
        }
        return true
    }
    
    @IBAction func toggleSettings(_ sender: Any) {
        showSettings.toggle()
        settingsView.isHidden = !showSettings
        gearIndicator.isHidden = !showSettings
    }
    
    @IBAction func toggleColor(_ sender: Any) {
        Theme.current.toggle()
        setColors()
    }
    
    @IBAction func toggleStats(_ sender: Any) {
        historyContainer.isHidden.toggle()
        statsIndicator.isHidden.toggle()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let extraWidth = scrollView.contentSize.width - scrollView.frame.width
        leftIndicator.alpha = scrollView.contentOffset.x / extraWidth
        rightIndicator.alpha = 1 - scrollView.contentOffset.x / extraWidth
    }
    
    fileprivate func snapScrollToEdge(_ scrollView: UIScrollView) {
        let extraWidth = scrollView.contentSize.width - scrollView.frame.width
        let snapRight = scrollView.contentOffset.x > extraWidth / 2
        scrollView.setContentOffset(CGPoint(x: snapRight ? extraWidth : 0, y: 0), animated: true)
//        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0) { [self] in
//            leftIndicator.alpha = snapRight ? 1.0 : 0.0
//            rightIndicator.alpha = snapRight ? 0.0 : 1.0
//        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        snapScrollToEdge(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapScrollToEdge(scrollView)
    }
}

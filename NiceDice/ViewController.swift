
import UIKit

class ViewController: UIViewController {

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
    
    var orignalTransform : CGAffineTransform = CGAffineTransform()
    
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
    
    func setColors() {
        view.window?.tintColor = Theme.current.tintColor
        gearIndicator.backgroundColor = Theme.current.tintColor
        view.backgroundColor = Theme.current.backgroundColor
        
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
    
    @IBAction func addDice(_ sender: UITapGestureRecognizer) {
        let die = sender.view!.tag
        
        if lastAdded != die || lastPress.timeIntervalSinceNow < -0.75 {
            roll = RollGroup()
        }
        lastPress = Date()
        
        roll.rolls.append(Roll(die: die))
        updateRollLabel()
        updateTotalLabel()
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
            currentPanGesture = nil
        }
        lastAdded = die
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
        let vc = HistoryTVC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}


import UIKit
import CoreData

class ViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    var rollGroup: RollGroup?
    var lastAdded = 0
    var lastPress = Date()
    var currentPanGesture = Optional<UIPanGestureRecognizer>.none
    var swipeUpInitiated = false
    
    @IBOutlet var rollLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var settingsView: UIStackView!
    @IBOutlet var gearIndicator: UIView!
    @IBOutlet var statsIndicator: UIView!
    @IBOutlet var rightIndicator: UIView!
    @IBOutlet var leftIndicator: UIView!
    @IBOutlet var historySection: UIView!
    @IBOutlet var historyContainer: UIView!
    @IBOutlet var historyContainerHeight: NSLayoutConstraint!
    @IBOutlet var diceWidth: NSLayoutConstraint!
    @IBOutlet var diceScrollView: UIScrollView!
    @IBOutlet var labelPadding: NSLayoutConstraint!
    @IBOutlet var colorView: UIView!

    var historyStore: NSPersistentContainer!
    var historyVC: HistoryVC!
    
    var orignalTransform : CGAffineTransform = CGAffineTransform()
    var forgroundObserver: NSObjectProtocol?

    lazy var historyResults: NSFetchedResultsController<RollGroup> = {
        let request = NSFetchRequest<RollGroup>(entityName: "RollGroup")

        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        let controller = NSFetchedResultsController<RollGroup>(
            fetchRequest: request,
            managedObjectContext: historyStore.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = historyVC
        return controller
    }()

    deinit {
        if let forgroundObserver = forgroundObserver {
            NotificationCenter.default.removeObserver(forgroundObserver)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        historySection.layoutIfNeeded()
        let oldConstant = historyContainerHeight.constant
        let newConstant = historySection.frame.height - historySection.frame.height.truncatingRemainder(dividingBy: 24)
        if oldConstant != newConstant {
            historyContainerHeight.constant = newConstant
        }

        adjustLayoutForScreenSize()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        try? historyResults.performFetch()
        historyVC.tableView.reloadData()
        forgroundObserver = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] notification in
            try? self?.historyResults.performFetch()
            self?.historyVC.tableView.reloadData()
            self?.historyVC.tableView.layoutIfNeeded()
            self?.historyVC.tableView?.setContentOffset(.zero, animated: true)
        }

        if #available(iOS 10.3, *) {
            if UIApplication.shared.supportsAlternateIcons {
                let gesture = UILongPressGestureRecognizer(target: self, action: #selector(matchAppIcon))
                colorView.addGestureRecognizer(gesture)
            }
        }

        rollGroup = historyResults.fetchedObjects?.first
        orignalTransform = totalLabel.transform
        
        updateRollLabel()
        updateTotalLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "history" {
            historyVC = (segue.destination as! HistoryVC)
            historyVC.historyStore = historyStore
            historyVC.historyResults = historyResults
        }
    }

    func adjustLayoutForScreenSize() {
        let multiplier: CGFloat
        if Device.size() >= .screen6_5Inch && view.window!.bounds.size.width > 400 {
            multiplier = 1/7
            rightIndicator.isHidden = true
            leftIndicator.isHidden = true
        } else {
            multiplier = 1/6
            rightIndicator.isHidden = false
            leftIndicator.isHidden = false
        }
        let newConstraint = diceWidth.constraintWithMultiplier(multiplier)
        diceScrollView.removeConstraint(diceWidth)
        diceScrollView.addConstraint(newConstraint)
        diceScrollView.layoutIfNeeded()
        diceWidth = newConstraint

        if Device.size() <= .screen4Inch { // SE first gen
            labelPadding.constant = -15
        }
    }

    func updateUI() {
        settingsView.isHidden = !Settings.showSettings
        gearIndicator.isHidden = !Settings.showSettings
        historyContainer.isHidden = !Settings.showHistory
        statsIndicator.isHidden = !Settings.showHistory
        setColors()
    }
    
    func setColors() {
        view.window?.tintColor = Settings.theme.tintColor
        gearIndicator.backgroundColor = Settings.theme.tintColor
        statsIndicator.backgroundColor = Settings.theme.tintColor
        leftIndicator.backgroundColor = Settings.theme.tintColor
        rightIndicator.backgroundColor = Settings.theme.tintColor
        view.backgroundColor = Settings.theme.backgroundColor
        historyVC.setColors()
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func updateTotalLabel(animate: Bool = true) {
        totalLabel.text = rollGroup?.totalString() ?? "--"
        if animate {
            totalLabel.transform = self.orignalTransform.scaledBy(x: 1.3, y: 1.3)
            UIView.animate(withDuration: 0.75, animations: { [self] in
                totalLabel.transform = self.orignalTransform
            })
        }
    }
    
    func updateRollLabel() {
        rollLabel.text = rollGroup?.rollString() ?? ""
    }
    
    @IBAction func addDice(_ sender: UITapGestureRecognizer) {
        let die = sender.view!.tag
        
        let isNewGroup = lastAdded != die || lastPress.timeIntervalSinceNow < -0.75
        
        if isNewGroup {
            rollGroup = RollGroup(context: historyStore.viewContext)
            rollGroup!.date = Date()
        }
        lastPress = Date()

        let roll = Roll(context: historyStore.viewContext)
        roll.date = Date()
        roll.die = Int16(die)
        roll.side = Int16.random(in: 1...roll.die)
        roll.group = rollGroup

        updateRollLabel()
        updateTotalLabel()
        
        lastAdded = die

        try? historyStore.viewContext.save()
    }
    
    @IBAction func swipeUp(_ sender: UIPanGestureRecognizer) {
        guard currentPanGesture == nil || sender == currentPanGesture else { return }
        let die = sender.view!.tag
        lastAdded = 0
        switch sender.state {
        case .began:
            currentPanGesture = sender
        case .changed:
            let dy = -sender.translation(in: sender.view).y
            guard dy >= 20.0 else { return }

            if !swipeUpInitiated {
                swipeUpInitiated = true
                diceScrollView.panGestureRecognizer.state = .failed
                rollGroup = RollGroup(context: historyStore.viewContext)
                rollGroup?.date = Date()
            }
            let groupSize = max(1, Int(dy / 20.0))


            while rollGroup!.rolls?.count ?? 0 > groupSize {
                let roll = rollGroup!.rolls!.anyObject()! as! Roll
                rollGroup!.removeFromRolls(roll)
            }
            while rollGroup!.rolls?.count ?? Int.max < groupSize {
                let roll = Roll(context: historyStore.viewContext)
                roll.die = Int16(die)
                roll.side = 0
                rollGroup!.addToRolls(roll)
            }
            updateRollLabel()
        default:
            currentPanGesture = nil

            guard swipeUpInitiated else { return }

            for case let roll as Roll in rollGroup!.rolls! {
                roll.side = Int16.random(in: 1...roll.die)
            }
            updateTotalLabel()
            historyVC.reloadFirstCell()
            swipeUpInitiated = false
        }

        try? historyStore.viewContext.save()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    @IBAction func toggleSettings(_ sender: Any) {
        Settings.showSettings.toggle()
        updateUI()
    }
    
    @IBAction func toggleColor(_ sender: Any) {
        Settings.theme.toggle()
        updateUI()
    }
    
    @IBAction func toggleStats(_ sender: Any) {
        Settings.showHistory.toggle()
        updateUI()
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
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        snapScrollToEdge(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapScrollToEdge(scrollView)
    }

    @available(iOS 10.3, *)
    @objc func matchAppIcon() {
        let theme = Settings.theme
        let iconName = theme == .black ? nil : theme.rawValue
        guard UIApplication.shared.alternateIconName != iconName else { return }
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        menu.addAction(UIAlertAction(title: "Change App Icon", style: .default) { action in
            UIApplication.shared.setAlternateIconName(iconName)
        })
        menu.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        menu.view.tintColor = .systemBlue
        menu.popoverPresentationController?.sourceView = colorView
        menu.popoverPresentationController?.sourceRect = colorView.bounds

        present(menu, animated: true)
    }
}

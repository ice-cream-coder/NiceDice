
import UIKit
import CoreData

class HistoryVC: UITableViewController, NSFetchedResultsControllerDelegate {

    var historyStore: NSPersistentContainer!
    var historyResults: NSFetchedResultsController<RollGroup>!
    var beganUpdates = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.identifier)
        tableView.separatorStyle = .none
        tableView.layer.borderWidth = 1
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        
        setColors()
    }
    
    func setColors() {
        tableView.layer.borderColor = Settings.theme.tintColor.cgColor
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        24
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        historyResults.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyResults.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
        let rollGroup = historyResults.object(at: indexPath)
        cell.rollLabel.text = rollGroup.rollString()
        cell.totalLabel.text = rollGroup.totalString()

        cell.backgroundColor = .clear

        cell.rollView.backgroundColor = Settings.theme.tintColor
        cell.rollView.tintColor = Settings.theme.backgroundColor

        cell.resultView.backgroundColor = Settings.theme.backgroundColor
        cell.resultView.tintColor = Settings.theme.tintColor


        cell.resultDivider.backgroundColor = Settings.theme.tintColor
        if indexPath.row != (historyResults.sections?[indexPath.section].numberOfObjects ?? 0) - 1 {
            cell.rollDivider.backgroundColor = Settings.theme.backgroundColor
        } else {
            cell.rollDivider.backgroundColor = Settings.theme.tintColor
        }

        return cell
    }
    
    fileprivate func snapScrollToCellEdge() {
        let offBy = tableView.contentOffset.y.truncatingRemainder(dividingBy: 24)
        let offset: CGFloat
        if offBy < 12 {
            offset = offBy
        } else {
            offset = offBy - 24
        }
        let newContentOffset = CGPoint(x: tableView.contentOffset.x,
                                       y: tableView.contentOffset.y - offset)
        tableView.setContentOffset(newContentOffset, animated: true)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        snapScrollToCellEdge()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapScrollToCellEdge()
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if tableView.contentOffset == .zero {
            beganUpdates = true
            tableView.beginUpdates()
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard beganUpdates else { return }
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .top)
        case .update:
            tableView.reloadRows(at: [newIndexPath!], with: .none)
        case .delete:
            tableView.deleteRows(at: [newIndexPath!], with: .none)
        default:
            tableView.reloadData()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if beganUpdates {
            tableView.endUpdates()
        } else {
            tableView.reloadData()
            tableView.layoutIfNeeded()
            tableView.setContentOffset(.zero, animated: true)
        }
        beganUpdates = false
        saveContext()
    }

    func reloadFirstCell() {
        guard tableView(tableView, numberOfRowsInSection: 0) > 0 else { return }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        tableView.endUpdates()
    }

    private func saveContext() {
        do {
            if historyStore.viewContext.hasChanges {
                try historyStore.viewContext.save()
            }
        } catch {
            // Intentionally left blank
        }
    }
}

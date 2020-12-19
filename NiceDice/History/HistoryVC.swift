
import UIKit

class HistoryVC: UITableViewController {
    
    var data: [RollGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.identifier)
        tableView.separatorStyle = .none
        tableView.layer.borderWidth = 1
        tableView.backgroundColor = .clear

        setColors()
    }
    
    func setColors() {
        tableView.layer.borderColor = Theme.current.tintColor.cgColor
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
        
        let rollGroup = data[data.count - 1 - indexPath.row]
        
        cell.rollLabel.text = rollGroup.rollString()
        cell.totalLabel.text = rollGroup.totalString()
        
        cell.backgroundColor = .clear
        
        cell.rollView.backgroundColor = Theme.current.tintColor
        cell.rollView.tintColor = Theme.current.backgroundColor
        
        cell.resultView.backgroundColor = Theme.current.backgroundColor
        cell.resultView.tintColor = Theme.current.tintColor
        
        if indexPath.row != data.count - 1 {
            cell.rollDivider.backgroundColor = Theme.current.backgroundColor
            cell.resultDivider.backgroundColor = Theme.current.tintColor
        } else {
            cell.rollDivider.backgroundColor = .clear
            cell.resultDivider.backgroundColor = .clear
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
    
    func insertTop() {
        if tableView.contentOffset == .zero {
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        } else {
            tableView.reloadData()
            tableView.layoutIfNeeded()
            tableView.setContentOffset(.zero, animated: true)
        }
    }
}

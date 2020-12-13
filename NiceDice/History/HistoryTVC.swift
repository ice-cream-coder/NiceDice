
import UIKit

class HistoryTVC: UITableViewController {
    
    var data = [
        RollGroup(rolls: [Roll(die: 4), Roll(die: 4), Roll(die: 4), Roll(die: 4)]),
        RollGroup(rolls: [Roll(die: 6), Roll(die: 6), Roll(die: 6), Roll(die: 6)]),
        RollGroup(rolls: [Roll(die: 10), Roll(die: 10)]),
        RollGroup(rolls: [Roll(die: 20)])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.identifier)
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
        
        let rollGroup = data[indexPath.row]
        cell.rollLabel.text = rollGroup.rollString()
        cell.totalLabel.text = rollGroup.totalString()
        
        return cell
    }
}

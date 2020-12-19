
import UIKit

class HistoryCell: UITableViewCell {
    
    lazy var rollLabel: TintedLabel = {
        let label = TintedLabel()
        label.font = UIFont(name: "Acumin Pro Wide Regular", size: 15)
        return label
    }()
    
    lazy var rollView: UIView = {
        let view = UIView()
        view.addSubview(rollLabel)
        rollLabel.pinCenter()
        return view
    }()
    
    lazy var rollDivider: UIView = {
        let view = UIView()
        view.constrain(height: 1)
        return view
    }()
    
    lazy var totalLabel: TintedLabel = {
        let label = TintedLabel()
        label.font = UIFont(name: "Acumin Pro Wide Regular", size: 15)
        return label
    }()
    
    lazy var resultView: UIView = {
        let view = UIView()
        view.addSubview(totalLabel)
        totalLabel.pinCenter()
        return view
    }()
    
    lazy var resultDivider: UIView = {
        let view = UIView()
        view.constrain(height: 1)
        return view
    }()
    
    lazy var stack: UIStackView = {
        let leftStack = UIStackView()
        leftStack.axis = .vertical
        leftStack.addArrangedSubview(rollView)
        leftStack.addArrangedSubview(rollDivider)
        
        let rightStack = UIStackView()
        rightStack.axis = .vertical
        rightStack.addArrangedSubview(resultView)
        rightStack.addArrangedSubview(resultDivider)
        
        let stack = UIStackView()
        stack.addArrangedSubview(leftStack)
        stack.addArrangedSubview(rightStack)
        NSLayoutConstraint.activate([
            leftStack.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.5),
            rightStack.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.5)
        ])
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(stack)
        stack.pinEdges()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import Foundation
import UIKit
import SnapKit

protocol CounterDelegate: AnyObject {
    func didChanged(count: UInt, identifier: Int?)
}

class Counter: UIView {
    
    // MARK: - Data types
    enum Style {
        case forCollection
        case forTable
    }
    
    // MARK: - Views
    private lazy var minusButton: UIButton = {
        let view = UIButton()
        switch style {
        case .forTable:
            view.setImage(UIImage(systemName: "minus"), for: .normal)
            view.tintColor = K.Design.primaryTextColor
        case .forCollection:
            view.setImage(UIImage(systemName: "minus"), for: .normal)
            view.tintColor = K.Design.secondTextColor
        }
        view.addTarget(self, action: #selector(minusButtonAction), for: .touchUpInside)
        return view
    }()
    
    private lazy var plusButton: UIButton = {
        let view = UIButton()
        switch style {
        case .forTable:
            view.setImage(UIImage(systemName: "plus"), for: .normal)
            view.tintColor = K.Design.primaryTextColor
        case .forCollection:
            view.setImage(UIImage(systemName: "plus"), for: .normal)
            view.tintColor = K.Design.secondTextColor
        }
        view.addTarget(self, action: #selector(plusButtonAction), for: .touchUpInside)
        return view
    }()
    
    private lazy var countLabel: UILabel = {
        let view = UILabel()
        switch style {
        case .forTable:
            view.font = .systemFont(ofSize: 16.0, weight: .bold)
        case .forCollection:
            view.font = .systemFont(ofSize: 14.0, weight: .regular)
        }
        view.textColor = K.Design.primaryTextColor
        view.textAlignment = .center
        view.text = "0"
        return view
    }()
    
    private var stackView: UIStackView!
    
    // MARK: - Properties
    private var style: Style
    
    private var identifier: Int?
    
    private var count: UInt = 0 {
        didSet {
            countLabel.text = "\(count)"
            delegate?.didChanged(count: count, identifier: identifier)
        }
    }
    
    weak var delegate: CounterDelegate?
    
    // MARK: - Lifecycle
    private override init(frame: CGRect) {
        style = .forTable
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Counter.init(coder:) has not been implemented")
    }
    
    convenience init(with style: Style, identifier: Int? = nil) {
        self.init(frame: .zero)
        self.style = style
        self.identifier = identifier
        setupView()
    }
    
    // MARK: - Public methods
    // Setter method for the identifier
    func setIdentifier(_ identifier: Int?) {
        self.identifier = identifier
    }
    
    // Getter method for the identifier
    func getIdentifier() -> Int? {
        return identifier
    }
}


// MARK: - Setup Cell
private extension Counter {
    func setupView() {
        backgroundColor = .clear
        
        addSubview()
        setupLayout()
        
    }
}

// MARK: - Setting
private extension Counter {
    func addSubview() {
        
        stackView = UIStackView(arrangedSubviews: [minusButton, countLabel, plusButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0.0
        
        addSubview(stackView)
    }
}

// MARK: - Setup Layout
private extension Counter {
    private func setupLayout() {
        let size = CGSize(width: 72.0, height: 24.0)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(size)
        }
    }
}

// MARK: - Logic
private extension Counter {
    @objc func minusButtonAction() {
        guard count > 0 else { return }
        count -= 1
        delegate?.didChanged(count: count, identifier: identifier)
    }
    
    @objc func plusButtonAction() {
        count += 1
        delegate?.didChanged(count: count, identifier: identifier)
    }
}

extension Counter {
    func setCounterValue(with count: UInt) {
        self.count = count
    }
    
    func prepareForReuse() {
        countLabel.text = nil
    }
}

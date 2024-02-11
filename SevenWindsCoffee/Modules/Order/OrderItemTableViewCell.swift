//
//  OrderItemTableViewCell.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 09/02/2024.
//

import UIKit
import SnapKit

class OrderTableViewCell: UITableViewCell {
    
    public static var identifier: String {
        get {
            return "OrderTableViewCell"
        }
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private properties
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = K.Design.cellColor
        view.layer.cornerRadius = 5
        view.layer.shadowColor = K.Design.separatorLineColor?.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 1
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = K.Design.primaryTextColor
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = K.Design.secondTextColor
        return label
    }()
    
    private lazy var stepper: Counter = {
        let view = Counter(with: .forTable)
        view.delegate = self
        return view
    }()
    
    private var vStack: UIStackView!
    private var hStack: UIStackView!
    
    private var countHandler: ((UInt) -> Void)?
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        priceLabel.text = nil
        stepper.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
    }
    
    // MARK: - Public methods
    func configure(with item: OrderEntityElement) {
        nameLabel.text = item.item.name
        priceLabel.text = "\(String(item.item.price)) рублей"
        stepper.setCounterValue(with: item.count)
    }
}

// MARK: - Setup Cell
private extension OrderTableViewCell {
    func setupCell() {
        backgroundColor = .clear
        
        addSubview()
        setupLayout()
    }
}

// MARK: - Setting
private extension OrderTableViewCell {
    func addSubview() {
        addSubview(view)
        
        vStack = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        vStack.axis = .vertical
        vStack.spacing = 5
        vStack.alignment = .leading
        
        hStack = UIStackView(arrangedSubviews: [vStack, stepper])
        hStack.axis = .horizontal
//        hStack.spacing = 140
        hStack.distribution = .fillProportionally
        hStack.alignment = .center
        
        view.addSubview(hStack)
    }
}

// MARK: - Setup Layout
private extension OrderTableViewCell {
    func setupLayout() {
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(349)
            make.height.equalTo(71)
            make.bottom.equalToSuperview().inset(5)
        }
        
        stepper.snp.makeConstraints { make in
            make.width.equalTo(70)
        }

        hStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        
    }
}

// MARK: - CounterDelegate
extension OrderTableViewCell: CounterDelegate {
    func didChanged(count: UInt, identifier: Int?) {
        //
    }
}

#Preview(traits: .defaultLayout, body: {
    let view = OrderTableViewCell()
    view.configure(with: OrderEntityElement(item: MenuItemsEntityElement(id: 1, name: "AmericanoAmericano Americano", imageURL: "", price: 200), count: 1))
    return view
})

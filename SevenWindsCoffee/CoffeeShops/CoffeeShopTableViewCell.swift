//
//  CoffeeShopTableViewCell.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import UIKit
import SnapKit

class CoffeeShopTableViewCell: UITableViewCell {
    
    public static var identifier: String {
        get {
            return "CoffeeShopTableViewCell"
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
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = K.Design.secondTextColor
        return label
    }()
    
    private var vStack: UIStackView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        locationLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
    }
    

    
    // MARK: - Public methods
    func configure(with shop: CoffeeShopsEntityElement) {
        nameLabel.text = shop.name
        locationLabel.text = "20 км от вас"
    }
}

// MARK: - Setup Cell
private extension CoffeeShopTableViewCell {
    func setupCell() {
        backgroundColor = .clear
        
        addSubview()
        setupLayout()
        
    }
}

// MARK: - Setting
private extension CoffeeShopTableViewCell {
    func addSubview() {
        addSubview(view)

        
        vStack = UIStackView(arrangedSubviews: [nameLabel, locationLabel])
        vStack.axis = .vertical
        vStack.spacing = 5
        vStack.alignment = .leading
        
        view.addSubview(vStack)
        
    }
}

// MARK: - Setup Layout
private extension CoffeeShopTableViewCell {
    func setupLayout() {
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(349)
            make.height.equalTo(71)
            make.bottom.equalToSuperview().inset(5)
        }

        vStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
    }
}


#Preview(traits: .defaultLayout, body: {
    let view = CoffeeShopTableViewCell()
    view.configure(with: CoffeeShopsEntityElement(id: 1, name: "Mac caffee", point: Point(latitude: "8218122", longitude: "32323")))
    return view
})

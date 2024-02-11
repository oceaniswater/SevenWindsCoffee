//
//  MenuItemTableViewCell.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 08/02/2024.
//

import UIKit
import SnapKit
import SDWebImage

protocol MenuCellDelegate: AnyObject {
    func didCountChanged(count: UInt, identifier: Int?)
}

class MenuItemCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: MenuCellDelegate?
    
    public static var identifier: String {
        get {
            return "MenuItemCollectionViewCell"
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private properties
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = K.Design.secondBackroundColor
        view.layer.cornerRadius = 5
        view.layer.shadowColor = K.Design.separatorLineColor?.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 2
        return view
    }()
    
    private let productImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowColor = K.Design.separatorLineColor?.cgColor
        return view
    }()
    
    private let loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .gray)
        loader.hidesWhenStopped = true
        return loader
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = K.Design.secondTextColor
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = K.Design.primaryTextColor
        return label
    }()
    
    private lazy var stepper: Counter = {
        let view = Counter(with: .forCollection)
        view.delegate = self
        return view
    }()
    
    private var vStack: UIStackView!
    private var hStack: UIStackView!
    
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
    func configure(with item: MenuItemsEntityElement) {
        nameLabel.text = item.name
        priceLabel.text = "\(String(item.price)) руб"
        stepper.setIdentifier(item.id)
        
        loaderView.startAnimating()
        
        // Use SDWebImage to load and cache the image
        productImageView.sd_setImage(with: URL(string: item.imageURL)) { [weak self] (image, error, _, _) in
            guard let self = self else { return }
            
            // Hide the loader once the image is loaded
            loaderView.stopAnimating()
            
            // Handle errors or additional setup if needed
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Setup Cell
private extension MenuItemCollectionViewCell {
    func setupCell() {
        backgroundColor = .clear
        
        addSubview()
        setupLayout()
    }
}

// MARK: - Setting
private extension MenuItemCollectionViewCell {
    func addSubview() {
        addSubview(view)
        view.addSubview(productImageView)
        view.addSubview(loaderView)
        
        hStack = UIStackView(arrangedSubviews: [priceLabel, stepper])
        hStack.axis = .horizontal
        hStack.spacing = 0
        hStack.distribution = .fillEqually
        hStack.alignment = .leading
        
        vStack = UIStackView(arrangedSubviews: [nameLabel, hStack])
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.spacing = 5
        vStack.alignment = .leading
        
        view.addSubview(vStack)
        
    }
}

// MARK: - Setup Layout
private extension MenuItemCollectionViewCell {
    func setupLayout() {
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        productImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(137)
            make.width.equalTo(165)
        }
        
        loaderView.snp.makeConstraints { make in
            make.center.equalTo(productImageView.snp.center)
        }
        
        vStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}

// MARK: - CounterDelegate
extension MenuItemCollectionViewCell: CounterDelegate {
    func didChanged(count: UInt, identifier: Int?) {
        delegate?.didCountChanged(count: count, identifier: identifier)
    }
}

#Preview(traits: .defaultLayout, body: {
    let view = MenuItemCollectionViewCell()
    view.configure(with: MenuItemsEntityElement(id: 1, name: "Americano Americano Americano", imageURL: "https://upload.wikimedia.org/wikipedia/commons/9/9a/Espresso_and_napolitains.jpg", price: 200))
    return view
})


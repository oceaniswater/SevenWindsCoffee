//
//  MapView.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 10/02/2024.
//

import UIKit
import YandexMapsMobile

protocol MapViewProtocol: AnyViewProtocol {
    var presenter: MapPresenterProtocol? {get set}
    func fetchShopSuccess()
    func showFetchError(message: String)
    func unauthorisedUser()
}

class MapViewController: TemplateViewController {
    var presenter: MapPresenterProtocol?
    
    // MARK: - Public methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter?.fetchCoffeeShops()
    }
    
    // MARK: - Private methods
    /// Sets the map to specified point, zoom, azimuth and tilt
    private func move(to cameraPosition: YMKCameraPosition = K.Coordinates.cameraPosition) {
        map.move(with: cameraPosition, animation: YMKAnimation(type: .smooth, duration: 1.0))
    }
    
    /// Adds a placemark to the map
    private func addPlacemark() {
        guard let shops = presenter?.shops else { return }
        
        for shop in shops {
            guard let lat = Double(shop.point.latitude),
                  let lon = Double(shop.point.longitude) else { return }
            
            let point = YMKPoint(latitude: lat, longitude: lon)
            
            guard let image = UIImage(named: "placemark") else { return }
            let placemark = map.mapObjects.addPlacemark()
            placemark.geometry = point
            placemark.setIconWith(image)
            placemark.userData = shop.id
            // Add text with style to the placemark
            placemark.setTextWithText(
                shop.name,
                style: YMKTextStyle(
                    size: 10.0,
                    color: .black,
                    outlineColor: .white,
                    placement: .top,
                    offset: 0.0,
                    offsetFromIcon: true,
                    textOptional: false
                )
            )
            
            // Make placemark draggable
            placemark.isDraggable = true
    
            // Add placemark tap handler
            placemark.addTapListener(with: mapObjectTapListener)
        }
    }
    
    // MARK: - Private properties
    private var mapView: YMKMapView!
    private var map: YMKMap!
    
    /// Handles map object taps
    private lazy var mapObjectTapListener: YMKMapObjectTapListener = MapObjectTapListener(controller: self)
    
    // MARK: - Private nesting
    
    /// Handles map object taps
    final private class MapObjectTapListener: NSObject, YMKMapObjectTapListener {
        init(controller: UIViewController) {
            self.controller = controller
        }
        
        func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
            guard let controller = controller as? MapViewController,
                  let id = mapObject.userData else { return false }
            
            controller.presenter?.tapOnPlacemark(id: id as! Int)
            
            return true
        }
        
        private weak var controller: UIViewController?
    }
}

// MARK: - MapViewProtocol
extension MapViewController: MapViewProtocol {
    func fetchShopSuccess() {
        DispatchQueue.main.async {
            self.addPlacemark()
        }
    }
    
    func showFetchError(message: String) {
        //
    }
    
    func unauthorisedUser() {
        AlertPresenter.present(from: self, with: "Ошибка авторизации", message: "Зарегистрируйтесь или войдите с помощью существущего логина и пароля.", action: UIAlertAction(title: "Ок", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }))
    }
}

// MARK: - Setup View
private extension MapViewController {
    func setupView() {
        navigationItem.title = "Ближайшие кофейни"
        
        addSubview()
        setupLayout()
        
        // Interface to manipulate with the map
        map = mapView.mapWindow.map
        
        // Additional map setup
        move()
    }
}

// MARK: - Setting
private extension MapViewController {
    func addSubview() {
        mapView = YMKMapView(frame: view.frame)
        view.addSubview(mapView)
    }
}

// MARK: - Setup Layout
private extension MapViewController {
    func setupLayout() {
        mapView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

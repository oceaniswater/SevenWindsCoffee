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
    private func move(to cameraPosition: YMKCameraPosition = Const.cameraPosition) {
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
    /// - Note: This should be declared as property to store a strong reference
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
    
    private enum Const {
        static let point = YMKPoint(latitude: 44.83, longitude: 44.82)
        static let cameraPosition = YMKCameraPosition(target: point, zoom: 9.0, azimuth: 150.0, tilt: 30.0)
    }
}

extension MapViewController: MapViewProtocol {
    func fetchShopSuccess() {
        DispatchQueue.main.async {
            self.addPlacemark()
        }
    }
    
    func showFetchError(message: String) {
        //
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
        // Create new map view
        mapView = YMKMapView(frame: view.frame)
        
        // Add map to the view
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

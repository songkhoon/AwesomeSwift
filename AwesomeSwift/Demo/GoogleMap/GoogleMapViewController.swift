//
//  ViewController.swift
//  GoogleMap
//
//  Created by jeff on 21/02/2017.
//  Copyright © 2017 jeff. All rights reserved.
//  3.1177475,101.6328545
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class GoogleMapViewController: UIViewController {

    let googleAPIKey = "AIzaSyAu4k299EkF6hFutjejImSZlUDKqR6Xm30"
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var markerList:[GMSMarker] = []
    let normalMarker = #imageLiteral(resourceName: "kfc-icon-pin-small")
    let selectedMarker = #imageLiteral(resourceName: "kfc-icon-pin-big")
    
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    var containerViews:[UIView] = []
    var addresses:[GMSPlaceLikelihood] = []
    var nearbyKFCStoreList:[StoreData] = []
    let containerCellId = String(describing: MapContentCell.self)
    let mapAddressCellId = String(describing: MapAddressCell.self)
    
    var resultsViewController = GMSAutocompleteResultsViewController()
    var searchController: UISearchController?
    var resultView: UITextView?
    
    let container:UICollectionView = {
        let layoutFlow = UICollectionViewFlowLayout()
        layoutFlow.scrollDirection = .vertical
        layoutFlow.minimumLineSpacing = 0
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutFlow)
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    let mapViewContainer:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var currentAddressView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        view.backgroundColor = UIColor.white
        self.currentAddress.frame = view.frame
        view.addSubview(self.currentAddress)
        return view
    }()
    
    let currentAddress:UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "current address"
        return view
    }()
    
    let centerMarker:UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "location-marker"))
        return view
    }()
    
    let kfcStoreList:[StoreData] = {
        let storeURL = URL(string: "https://dynalist.io/u/fBKexhLgM4O3WEvBieaSgW6s/storelist.json")
        var list:[StoreData] = []
        do {
            let data = try Data(contentsOf: storeURL!)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [Any]
            
            for jsonData in json {
                if let jsonData = jsonData as? [String:Any] {
                    list.append(StoreData(jsonData))
                }
            }
        } catch {
            print("kfc store list error. \(error.localizedDescription)")
        }
        return list
    }()
    
    lazy var containerGuide:UILayoutGuide = {
        let layoutGuide = UILayoutGuide()
        self.view.addLayoutGuide(layoutGuide)
        layoutGuide.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        layoutGuide.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        layoutGuide.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        layoutGuide.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        return layoutGuide
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GMSServices.provideAPIKey(googleAPIKey)
        GMSPlacesClient.provideAPIKey(googleAPIKey)

        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        setupSearchBar()
        setupContainer()
        setupMapView()
        setupLocationManager()
        
    }
    
    func handleBack() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Setup
    private func setupSearchBar() {
        resultsViewController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "MY"
        
        resultsViewController.autocompleteFilter = filter
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.delegate = self
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }
    
    private func setupContainer() {
        
        self.view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: containerGuide.topAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: containerGuide.leadingAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: containerGuide.widthAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: containerGuide.heightAnchor).isActive = true
        
        containerViews = [mapViewContainer,currentAddressView]
        container.register(MapContentCell.self, forCellWithReuseIdentifier: containerCellId)
        container.register(MapAddressCell.self, forCellWithReuseIdentifier: mapAddressCellId)
        container.dataSource = self
        container.delegate = self
        
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()

    }
    
    private func setupMapView() {

        let defaultLocation = CLLocation()
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        
        let containerFrame = CGRect(x: 0, y: 0, width: containerGuide.layoutFrame.width, height: containerGuide.layoutFrame.height / 2)
        mapView = GMSMapView.map(withFrame: containerFrame, camera: camera)
        
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        mapViewContainer.frame = containerFrame
        mapViewContainer.addSubview(mapView)
        mapView.isHidden = true
        
        centerMarker.isHidden = true

        mapViewContainer.addSubview(centerMarker)
        let markerWeight:CGFloat = 50
        centerMarker.translatesAutoresizingMaskIntoConstraints = false
        centerMarker.centerXAnchor.constraint(equalTo: mapViewContainer.centerXAnchor).isActive = true
        centerMarker.centerYAnchor.constraint(equalTo: mapViewContainer.centerYAnchor, constant: -markerWeight/2).isActive = true
        centerMarker.widthAnchor.constraint(equalToConstant: markerWeight).isActive = true
        centerMarker.heightAnchor.constraint(equalToConstant: markerWeight).isActive = true

    }
    
    func updateMarker() {
        nearbyKFCStoreList = []
        for data in kfcStoreList {
            if let latitude = data.latitude, let longitude = data.longitude {
                if (mapView.projection.contains(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))){
                    nearbyKFCStoreList.append(data)
                    if markerList.index(where: {$0.position.latitude == latitude && $0.position.longitude == longitude}) == nil {
                        // no found in the list
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        marker.title = data.name
                        marker.snippet = data.address
                        marker.icon = normalMarker
                        marker.tracksViewChanges = false
                        marker.map = mapView
                        markerList.append(marker)
                    }
                }
            }
        }
        container.reloadData()
    }
    
    func showStoreMarker() {
        for data in kfcStoreList {
            if let latitude = data.latitude, let longitude = data.longitude {
                if markerList.index(where: {$0.position.latitude == latitude && $0.position.longitude == longitude}) == nil {
                    // no found in the list
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    marker.title = data.name
                    marker.snippet = data.address
                    marker.icon = normalMarker
                    marker.tracksViewChanges = false
                    marker.isFlat = true
                    marker.map = mapView
                    markerList.append(marker)
                }
            }
        }
    }
    
    private func showSydney() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
    }

    func updateCurrentLocation() {
        
        placesClient.currentPlace { (placeLikelihoodList, error) in
            if error != nil {
                print("Pick Place error: \(error?.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                self.addresses = placeLikelihoodList.likelihoods
                self.container.reloadData()
                
                if placeLikelihoodList.likelihoods.count > 0 {
                    let likelihoods = placeLikelihoodList.likelihoods.sorted( by: {$0.likelihood > $1.likelihood} )
                    let place = likelihoods[0].place
                    print("Current Place name \(place.name) at likelihood \(likelihoods[0].likelihood)")
                    print("Current Place address \(place.formattedAddress)")
                    print("Current Place attributions \(place.attributions)")
                    print("Current PlaceID \(place.placeID)")
                    self.currentAddress.text = place.formattedAddress
                }
            } else {
                self.addresses = []
            }
        }
    }
    
    func placePickerLocation(_ latitude:Double, _ longiture:Double) {
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longiture)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001,
                                               longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001,
                                               longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace { (place, error) in
            if error != nil {
                print("Pick Place error: \(error?.localizedDescription)")
            }
            
            guard let place = place else {
                print("No place selected")
                return
            }
            print("Place name \(place.name)")
            print("Place address \(place.formattedAddress)")
            print("Place attributions \(place.attributions)")
            self.currentAddress.text = place.formattedAddress
        }
    }
    
    func updateCenterAddress(_ address:String) {
        self.currentAddress.text = address
    }
    
    func getAddressForLatLng(_ latitude: Double, _ longitude: Double) -> String? {
        let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?key=\(googleAPIKey)&latlng=\(latitude),\(longitude)")
        
        do {
            let data = try Data(contentsOf: url!)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
            if let results = json["results"] as? [Any] {
                if results.count > 0, let address = results[0] as? [String:Any] {
                    if let formattedAddress = address["formatted_address"] as? String {
                        return formattedAddress
                    }
                }
            }
            
        } catch {
            print("getAddressForLatLng", error.localizedDescription)
        }
        return nil
    }
    
    func getPlaceAutocomplete(_ title:String) {
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "MY"
        placesClient.autocompleteQuery(title, bounds: nil, filter: nil) { (results, error) in
            if error != nil {
                print("autocomplete \(error?.localizedDescription)")
                return
            }
            
            if let results = results {
                for result in results {
                    if let placeID = result.placeID {
                        print(placeID)
                    }
                }
            }
        }
    }
    
    // Populate the array with the list of likely places.
    func listLikelyPlaces() {
        // Clean up from previous sessions.
        likelyPlaces.removeAll()
        
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    self.likelyPlaces.append(place)
                }
            }
        })
    }
    
    func navigateTo(_ data:StoreData) {
        if let selectedMarker = mapView.selectedMarker {
            selectedMarker.icon = normalMarker
        }
        
        if let marker = markerList.first(where: { $0.position.latitude == data.latitude && $0.position.longitude == data.longitude }) {
            marker.icon = selectedMarker
            mapView.selectedMarker = marker
        }
        
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: data.latitude!, longitude: data.longitude!))
    }

}




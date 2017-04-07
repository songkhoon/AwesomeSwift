//
//  GoogleMapViewController+GoogleMap.swift
//  MyLearnOfSwift
//
//  Created by jeff on 22/02/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

// MARK:- UICollectionViewDataSource
extension GoogleMapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return containerViews.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == containerViews.count {
            // show address view on last item
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mapAddressCellId, for: indexPath) as! MapAddressCell
            cell.nearbyStore = nearbyKFCStoreList
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: containerCellId, for: indexPath) as! MapContentCell
            cell.content = containerViews[indexPath.row]
            return cell
        }
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension GoogleMapViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == containerViews.count {
            return CGSize(width: containerGuide.layoutFrame.size.width, height: containerGuide.layoutFrame.size.height * 0.2)
        } else {
            let view = containerViews[indexPath.row]
            return view.frame.size
        }
    }
}

// MARK:- CLLocationManagerDelegate
extension GoogleMapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            centerMarker.isHidden = false
            updateCurrentLocation()
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

// MARK:- GMSMapViewDelegate
extension GoogleMapViewController:GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        updateMarker()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if let address = getAddressForLatLng(position.target.latitude, position.target.longitude) {
            updateCenterAddress(address)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let selectedMarker = mapView.selectedMarker {
            selectedMarker.icon = normalMarker
        }
        marker.icon = selectedMarker
        mapView.selectedMarker = marker
        return true
    }
    
}

// MARK:- GMSAutocompleteResultsViewControllerDelegate
extension GoogleMapViewController:GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        if let placeID = prediction.placeID {
            
            placesClient.lookUpPlaceID(placeID) { (place, error) in
                if error != nil {
                    print("lookUpPlaceID error \(error?.localizedDescription)")
                }
                if let place = place {
                    self.placePickerLocation(place.coordinate.latitude, place.coordinate.longitude)
                }
            }
            
            
        }
        return true
    }
}

// MARK:- UISearchBarDelegate
extension GoogleMapViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getPlaceAutocomplete(searchText)
    }
}

// MARK:- UISearchResultsUpdating
extension GoogleMapViewController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("updateSearchResults ")
    }
}

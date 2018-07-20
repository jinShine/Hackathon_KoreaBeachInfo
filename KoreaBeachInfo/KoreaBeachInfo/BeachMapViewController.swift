//
//  BeachMapViewController.swift
//  KoreaBeachInfo
//
//  Created by 김승진 on 2018. 7. 20..
//  Copyright © 2018년 김승진. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

final class KoreakBeachInfo: MKPointAnnotation {
    var exhibition: [String]!
    var phoneNumber: String!
    var url: URL!
}

class BeachMapViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    
    private let beacnAnnotationID = "kbeacnAnnotationViewID"
    
    var regionName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        locationManager.delegate = self
        checkAuthorizationStatus()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("region!!!!!!!!!!!: ",regionName)
        BeachInfoHTTP.fetch(regionName: regionName) { (Info) in
            let values = Info as BeachInfo
            
            for index in 0..<values.oceanBeachsInfo.item.count {
                if let beachId = values.oceanBeachsInfo.item[index].beachId,
                    let sidoName = values.oceanBeachsInfo.item[index].sidoName,
                    let gugunName = values.oceanBeachsInfo.item[index].gugunName,
                    let staName = values.oceanBeachsInfo.item[index].staName,
                    let beachWidtd = values.oceanBeachsInfo.item[index].beachWidtd,
                    let beachLength = values.oceanBeachsInfo.item[index].beachLength,
                    let beacnKnd = values.oceanBeachsInfo.item[index].beacnKnd,
                    let linkAddr = values.oceanBeachsInfo.item[index].linkAddr,
                    let linkName = values.oceanBeachsInfo.item[index].linkName,
//                    let beachImage = values.oceanBeachsInfo.item[index].beachImage,
                    let linkTel = values.oceanBeachsInfo.item[index].linkTel,
                    let latitude = values.oceanBeachsInfo.item[index].latitude,
                    let longitude = values.oceanBeachsInfo.item[index].longitude
                {
                    
                    print(beachId)
                    print(sidoName)
                    print(gugunName)
                    print(staName)
                    print(beachWidtd)
                    print(beachLength)
                    print(beacnKnd)
                    print(linkAddr)
                    print(linkName)
//                    print(beachImage)
                    print(linkTel)
                    print(latitude)
                    print(longitude)
                    
                    let annotations = KoreakBeachInfo()
                    annotations.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    annotations.title = "\(staName) 해수욕장"
                    annotations.subtitle = gugunName
                    annotations.url = URL(string: linkAddr)
                    
//                    museum2.phoneNumber = "02-399-1000"
//                    museum2.exhibition = ["2018 그랜드 Summer 클래식", "사랑의 묘약"]
//                    museum2.url = URL(string: "http://www.sejongpac.or.kr")!
                    
                    self.mapView.addAnnotation(annotations)
                }
            }
        }
        
    }
    
    private func checkAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined: // 유저가 아직 권한을 선택하지 않은 상태
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied: // 위치서비스가 거부되었을때
            // Disable location features
            break
        case .authorizedWhenInUse: // 앱이 실행하는 동안에 위치서비스를 실행
            // Enable basic location features
            // enableMyWhenInUseFeatures()
            fallthrough
        case .authorizedAlways: // 항상 위치서비스를 실행
            // Enable any of your app's location features
            // enableMyAlwaysFeatures()
            startUpdatingLocation()
        }
    }
    
    private func startUpdatingLocation() {
        let status = CLLocationManager.authorizationStatus()
        guard status == .authorizedAlways || status == .authorizedWhenInUse,
            CLLocationManager.locationServicesEnabled()
            else { return }
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10.0
        locationManager.startUpdatingLocation() // 위치를 업데이트해라 -> didUpdateLocations 델리게이트로 정보가 간다.
    }
    
    @IBAction func mapTypeSwitch(_ sender: UISwitch) {
        if sender.isOn { self.mapView.mapType = .standard}
        else { self.mapView.mapType = .satellite }
    }
}

extension BeachMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let current = locations.last!
        if (abs(current.timestamp.timeIntervalSinceNow) < 10) {
            let coordinate = current.coordinate
            // span : 화면에 보이는 범위를 조절 0.01은 가까이서 보인다.
//            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
//            let region = MKCoordinateRegion(center: coordinate, span: span)
//            mapView.setRegion(region, animated: true)
            
            let annotation = Annotation(title: "현재 위치", coordinate: coordinate)
            if let anno = mapView.annotations.first {
                mapView.removeAnnotation(anno)
            }
            mapView.addAnnotation(annotation)
        }
    }
}

extension BeachMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is KoreakBeachInfo {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: beacnAnnotationID)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: beacnAnnotationID)
            } else {
                annotationView?.annotation = annotation
            }
            
            annotationView!.image = UIImage(named: "Parasol")
            annotationView?.frame.size = CGSize(width: 30, height: 30)
            annotationView!.canShowCallout = true
            
            let addButton = UIButton(type: UIButtonType.contactAdd)
            addButton.tag = 0
            annotationView?.leftCalloutAccessoryView = addButton
            
            let infoButton = UIButton(type: UIButtonType.infoDark)
            infoButton.tag = 1
            annotationView?.rightCalloutAccessoryView = infoButton
            return annotationView
        }
        return MKAnnotationView(frame: .zero)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? KoreakBeachInfo else { return }
        print("Annotation Info : \(annotation.title ?? ""), \(annotation.exhibition), \(annotation.phoneNumber)")
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let museum = view.annotation as? KoreakBeachInfo else { return }
        print("title : \(museum.title ?? ""), tag :",control.tag)
        
        let safariVC = SFSafariViewController(url: museum.url)
        present(safariVC, animated: true, completion: nil)
    }
}

class Annotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}

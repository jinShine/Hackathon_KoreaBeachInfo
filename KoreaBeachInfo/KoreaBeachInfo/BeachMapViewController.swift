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
import NVActivityIndicatorView


final class KoreakBeachInfo: MKPointAnnotation {
    var id: Int!
    var exhibition: [String]!
    var phoneNumber: String!
    var url: URL!
}

class BeachMapViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    
    private let beacnAnnotationID = "kbeacnAnnotationViewID"
    
    var parsingData: [BeachInfo.ItemInfo.Item] = []
    var regionName: String = ""
    var activityIndicator : NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 20, y: self.view.center.y, width: 50, height: 50))
        activityIndicator.type = .lineScalePulseOutRapid
        activityIndicator.color = UIColor.red
        
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        locationManager.delegate = self
        checkAuthorizationStatus()
        
        
        //카메라 포지션 위치
        currentCameraPosition(region: regionName)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BeachInfoHTTP.fetch(regionName: regionName) { (Info) in
            let values = Info as BeachInfo
            self.parsingData = values.oceanBeachsInfo.item
            
//            let mirror = Mirror(reflecting: values.oceanBeachsInfo.item[0])
//            for x in mirror.children {
//                if let value = x.value as? String {
//                    print(value)
//                }
//                if let name = x.label as? String {
//                    print(name)
//                }
//            }
            
            
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
//                    let linkTel = values.oceanBeachsInfo.item[index].linkTel,
                    let latitude = values.oceanBeachsInfo.item[index].latitude,
                    let longitude = values.oceanBeachsInfo.item[index].longitude
                {

                    let annotations = KoreakBeachInfo()
                    annotations.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    annotations.title = "\(staName) 해수욕장"
                    annotations.subtitle = gugunName
                    annotations.url = URL(string: linkAddr)
                    annotations.id = index
                    
                    self.mapView.addAnnotation(annotations)
                }
            }
            
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func currentCameraPosition (region regionName: String) {
        
        let center:CLLocationCoordinate2D
        
        switch regionName {
        case "인천":
            center = CLLocationCoordinate2DMake(37.37081760, 126.64705450)
        case "충남":
            center = CLLocationCoordinate2DMake(36.64538930, 126.41439690)
        case "전북":
            center = CLLocationCoordinate2DMake(35.65137270, 126.52680700)
        case "전남":
            center = CLLocationCoordinate2DMake(34.62350490, 126.62193100)
        case "제주":
            center = CLLocationCoordinate2DMake(33.43698830, 126.58751400)
        case "경남":
            center = CLLocationCoordinate2DMake(34.96549420, 128.22146450)
        case "부산":
            center = CLLocationCoordinate2DMake(35.17514820, 129.07894730)
        case "울산":
            center = CLLocationCoordinate2DMake(35.49125620, 129.35166740)
        case "경북":
            center = CLLocationCoordinate2DMake(36.30666870, 129.31308070)
        case "강원":
            center = CLLocationCoordinate2DMake(37.66246380, 128.77879880)
        default:
            center = CLLocationCoordinate2DMake(37.55839650, 126.99847480)
        }
        
        let span = MKCoordinateSpanMake(0.9, 0.9)
        let region = MKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)
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
            
            let addButton = UIButton(type: UIButtonType.infoDark)
            addButton.tag = 0
            annotationView?.leftCalloutAccessoryView = addButton
            
            let infoButton = UIButton(type: UIButtonType.contactAdd)
            infoButton.tag = 1
            annotationView?.rightCalloutAccessoryView = infoButton
            return annotationView
        }
        return MKAnnotationView(frame: .zero)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? KoreakBeachInfo else { return }

        let camera = MKMapCamera()
        camera.centerCoordinate = CLLocationCoordinate2D(latitude: Double(self.parsingData[annotation.id].latitude!), longitude: Double(self.parsingData[annotation.id].longitude!))
        camera.altitude = 200
        camera.pitch = 70.0
        mapView.setCamera(camera, animated: true)

    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let annotation = view.annotation as? KoreakBeachInfo else { return }
        
        if control.tag == 1{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let InfoPopUpVC = storyboard.instantiateViewController(withIdentifier: "InfoPopUpVC")
    
            let deliveryData = InfoPopUpVC as! InfoPopUpViewController
            deliveryData.selectedData = [self.parsingData[annotation.id]]
    
            InfoPopUpVC.modalPresentationStyle = .overCurrentContext
    
            present(InfoPopUpVC, animated: true) { }
        } else {
            let safariVC = SFSafariViewController(url: annotation.url)
            present(safariVC, animated: true, completion: nil)
        }
        

        
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

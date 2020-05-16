//
//  MapViewController.swift
//  map-start
//
//  Created by karlis.berzins on 25/03/2020.
//  Copyright © 2020 berzinsk. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapViewController: UIViewController, MKMapViewDelegate,filterDelegate {
   
    
  @IBOutlet var mapView: MKMapView!
    
  var ref: DatabaseReference!

  let locationManager = CLLocationManager()
  var tenkmFromLoc = false
  var noDescription = false
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ref = Database.database().reference()
    //Testing adding annotations
    ref.child("Annotations").child("TestValue").setValue(["Latitude":0.00,"Longitude":0.00])
    
    
    
    
    
    updateMap()
 
  }
    func updateMap () {
        
    //Delete old annotations
        let annotations = self.mapView.annotations
        if (annotations.count>0) {
           for annotation in annotations {
                   self.mapView.removeAnnotation(annotation)
           }
       }
        
        
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        addPointsManualy()
        addPointsDatabase()
         
        if (noDescription == true) {
            deleteAnnotWithDescription()
        }
        
        if (tenkmFromLoc == true) {
            deleteAnnotAboveTenKm()
        }
        
    }
    
    func addPointsManualy () {
        let firstPoint = MKPointAnnotation()
         firstPoint.coordinate = CLLocationCoordinate2D(latitude: 57.542059, longitude: 25.417272)
         firstPoint.title = "Maxima xx"
         firstPoint.subtitle = "Viens no lielākajiem veikaliem Valmierā."
         
         let secondPoint = MKPointAnnotation()
         secondPoint.coordinate = CLLocationCoordinate2D(latitude: 56.836140, longitude: 24.555149)
         secondPoint.title = "Zilie kalni"
         secondPoint.subtitle = "Forša vieta kur pavadīt laiku vasarā. Apksatīt Ogres dabu!"

         let thirdPoint = MKPointAnnotation()
         thirdPoint.coordinate = CLLocationCoordinate2D(latitude: 57.306182, longitude: 25.269327)
         thirdPoint.title = "Cēsis"
         thirdPoint.subtitle = "Maza tūristu pilsēta. Ar jauku vecpilsētu un pili."

        
         let forthPoint = MKPointAnnotation()
         forthPoint.coordinate = CLLocationCoordinate2D(latitude: 57.275334, longitude: 22.025278)
         forthPoint.title = "Kubuš veikals"
         forthPoint.subtitle = "Kubuš veikals nekurienes vidū."
            
         let fifthPoint = MKPointAnnotation()
        fifthPoint.coordinate = CLLocationCoordinate2D(latitude: 56.955354, longitude: 24.130030)
        fifthPoint.title = "Mēness aptieka"
        
        mapView.addAnnotation(fifthPoint)
         mapView.addAnnotation(forthPoint)
         mapView.addAnnotation(thirdPoint)
         mapView.addAnnotation(secondPoint)
         mapView.addAnnotation(firstPoint)
        
    }
    
    func addPointsDatabase() {
        ref.child("Annotations").observe(.value){
            snapshot in let myDataDict = snapshot.value as? [String: AnyObject] ?? [:]
            // Gets all the longitudes And Latitudes of database objects
            for annotation in myDataDict {
                var latitude: Double
                var longitude: Double
                latitude = annotation.value.object(forKey: "Latitude") as! Double
                longitude = annotation.value.object(forKey: "Longitude") as! Double
                let point = MKPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.mapView.addAnnotation(point)
            }
        }
        
    }
    
    
    func deleteAnnotWithDescription() {
        //print("Delete annotations with descriptions ")
        let annotations = self.mapView.annotations
               if (annotations.count>0) {
                  for annotation in annotations {
                    if (annotation.subtitle ?? nil) == nil {
                        //print("Deleted annotation")
                          self.mapView.removeAnnotation(annotation)
                    }
                  }
              }
    }
    
    func deleteAnnotAboveTenKm() {
      //  print("Delete annotations with descriptions ")
        let userLoc = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        
        let annotations = self.mapView.annotations
               if (annotations.count>0) {
                  for annotation in annotations {
                    let loc = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                    if ((userLoc.distance(from: loc))>10000){
                        //print(userLoc.distance(from: loc))
                          self.mapView.removeAnnotation(annotation)
                    }
                  }
              }
    }
    
  func drawRoute(to: CLLocationCoordinate2D) {
    let sourcePlacemark = MKPlacemark(coordinate: mapView.userLocation.coordinate)
    let destPlacemark = MKPlacemark(coordinate: to)

    let directionRequest = MKDirections.Request()
    directionRequest.source = MKMapItem(placemark: sourcePlacemark)
    directionRequest.destination = MKMapItem(placemark: destPlacemark)
    directionRequest.transportType = .automobile

    let directions = MKDirections(request: directionRequest)

    directions.calculate { response, error in
      if let response = response, let route = response.routes.first {
        self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
      }
    }
  }
    
    func update10kmFromLoc(disable10kmFromLoc: Bool) {
        tenkmFromLoc = disable10kmFromLoc
        updateMap()
          // print(disable10kmFromLoc)
       }
       
       func updateDesc(disableNoDescription: Bool) {
        noDescription = disableNoDescription
        updateMap()
           //print(disableNoDescription)
       }
       
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let vc = segue.destination as? FilterViewController {
           vc.delegate = self
         }
       }
    

   /* func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (annotation.title == "Kubuš veikals"){
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if ((annotationView) != nil) {
//            annotationView?.annotation = annotation
        }
        else{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
            
           
            annotationView?.isEnabled = true
            annotationView?.canShowCallout = true
            
        }
            return annotationView
        }
        
        return nil
    }*/

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = .red
    renderer.lineWidth = 2

    return renderer
  }

  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    //print("didSelect called")
    if let coordinate = view.annotation?.coordinate {
      //print("DidSelect: \(coordinate)")
      drawRoute(to: coordinate)
    }
  }
}

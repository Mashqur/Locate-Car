

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var carLocation: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        carLocation.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        //var flag = false
        
        //MARK: IF MAP VIEW IS FIRST VIEW
//        NotificationCenter.default.addObserver(forName: PlaceMarkersController.PLACE_MARKER_ADDED_NOTIFICATION, object: nil, queue: nil) {
//            notification in
//            let location:PlaceMarker = notification.object as! PlaceMarker
//            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.x!, location.y!)
//            //self.carLocation.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, 30000, 30000), animated: true)
//            let currentCarLocationPin: CarLocationPin = CarLocationPin(title: location.name!, subTitle: location.address!, coordinate: coordinate)
//            self.carLocation.addAnnotation(currentCarLocationPin)
//
//            if(!flag) {
//                self.carLocation.setRegion(MKCoordinateRegionMakeWithDistance(coordinate, 30000, 30000), animated: true)
//            }
//            flag = true
//        }
        
        //MARK: IF MAP VIEW IS SECOND VIEW
        let locations = PlaceMarkersController.sharePlaceMarkers();
        let regionCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(locations[0].x!, locations[0].y!)
        self.carLocation.setRegion(MKCoordinateRegionMakeWithDistance(regionCoordinate, 30000, 30000), animated: true)
        
        for location in locations {
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.x!, location.y!)
            let currentCarLocationPin: CarLocationPin = CarLocationPin(title: location.name!, subTitle: location.address!, coordinate: coordinate)
            self.carLocation.addAnnotation(currentCarLocationPin)
        }
    }
    
    var annotationsToRemove: [MKAnnotation] = []

    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("current count" , carLocation.annotations.count)
            annotationsToRemove = carLocation.annotations.filter { $0 !== view.annotation}
            carLocation.removeAnnotations(annotationsToRemove)
        }
    
    
    public func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView){
        carLocation.addAnnotations(annotationsToRemove)
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let annotationIdentifier = "Identifier"
        var annotationView: MKAnnotationView?
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        annotationView?.canShowCallout = true
        annotationView?.image = UIImage(named: "map-marker-128")
        let transformImage = CGAffineTransform(scaleX: 0.4, y: 0.4)
        annotationView?.transform = transformImage
        
        return annotationView
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


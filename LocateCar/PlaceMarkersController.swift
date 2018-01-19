

import Foundation
class PlaceMarkersController:NSObject {
    
    public static let PLACE_MARKER_ADDED_NOTIFICATION = NSNotification.Name("PLACE_MARKER_ADDED_NOTIFICATION")
    static var placeMarkerArray = [PlaceMarker]()
    
    class func sharePlaceMarkers() -> [PlaceMarker]{
        return placeMarkerArray
    }
    
    class func addPlaceMarker(placeMarker: PlaceMarker) {
        placeMarkerArray.append(placeMarker)
        
        NotificationCenter.default.post(name:PLACE_MARKER_ADDED_NOTIFICATION , object: placeMarker)
    }
    
    class func loadPlaceMarkers() {
        let url = URL(string: "http://data.m-tribes.com/locations.json")
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: url!) { (data, response, error) in
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let placemarks = json["placemarks"] as? [[String: Any]] {
                    for marker in placemarks {
                        let location = PlaceMarker()
                        location.address = marker["address"] as? String
                        location.engineType = marker["engineType"] as? String
                        location.exterior = marker["exterior"] as? String
                        location.fuel = marker["fuel"] as? Int
                        location.interior = marker["interior"] as? String
                        location.name = marker["name"] as? String
                        location.vin = marker["vin"] as? String
                        let coordinates = marker["coordinates"] as! NSArray
                        location.x = coordinates[1] as? Double;
                        location.y = coordinates[0] as? Double;
                        location.z = coordinates[2] as? Double;
                        addPlaceMarker(placeMarker: location)
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()        
    }
}

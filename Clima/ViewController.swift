import UIKit
import CoreLocation

class ViewController: UIViewController{
    
    
    
    var climaManager = ClimaManager()
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var buscarTF: UITextField!
    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var temperaturaLabel: UILabel!
    @IBOutlet weak var climaImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        
        //solicita el permiso del usuario
        locationManager.requestWhenInUseAuthorization()
        
        //solicita la ubicacion
        locationManager.requestLocation()
        
        climaManager.delegado = self
        buscarTF.delegate = self
        
    }
    
    @IBAction func obtenerUbicacionBtn(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}


//MARK:- Protocolo CLLocationManager para obtener ubicacion del usuario

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Se obtuvo la ubicacion")
        
        if let ubicaciones = locations.last{
            locationManager.stopUpdatingLocation()
            let latitud = ubicaciones.coordinate.latitude
            let longitud = ubicaciones.coordinate.longitude
            
            //llamar a climaManager con los datos de latitud y longitud
            
            climaManager.fetchClima(lat: latitud, long: longitud)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
//MARK:-Método para actualizar UI

extension ViewController: ClimaManagerDelegate{
    
    func huboError(cualError: Error){
        print(cualError.localizedDescription)
        
        DispatchQueue.main.sync{
            self.ciudadLabel.text = cualError.localizedDescription
        }
    }
    
    func actualizarClima(clima: ClimaModelo) {
        
        DispatchQueue.main.async {
            
            self.temperaturaLabel.text = String(clima.temperaturaCelsius)+" °c"
            self.climaImageView.image = UIImage(named: clima.condicionClima)
            self.ciudadLabel.text = clima.nombreCiudad
        }
        
        
    }
    
}

extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ciudadLabel.text = buscarTF.text
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if buscarTF.text != ""{
            return true
        }
        else{
            buscarTF.placeholder = "Escribe una ciudad"
            return false
        }
    }

    @IBAction func buscarBtn(_ sender: UIButton) {
        ciudadLabel.text = buscarTF.text
        climaManager.fetchClima(nombreCiudad: buscarTF.text!)
        
    }
    
}


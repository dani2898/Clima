import UIKit
import CoreLocation

class ViewController: UIViewController{
    
    
    
    var climaManager = ClimaManager()
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var buscarTF: UITextField!
    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var temperaturaLabel: UILabel!
    @IBOutlet weak var climaImageView: UIImageView!
    @IBOutlet weak var tempMinimaLabel: UILabel!
    @IBOutlet weak var humedadLabel: UILabel!
    
    @IBOutlet weak var velVientoLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var tempMaximaLabel: UILabel!
    @IBOutlet weak var bgImageView: UIImageView!
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
            let alert = UIAlertController(title: "Error", message: "Error en la ciudad, revise que esté escrito correctamente.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func actualizarClima(clima: ClimaModelo) {
        
        DispatchQueue.main.async {
            
            self.temperaturaLabel.text = "Temp: "+String(clima.temperaturaCelsius)+" °C"
            self.climaImageView.image = UIImage(named: clima.condicionClima)
            self.bgImageView.image = UIImage(named: clima.bgClima)
            self.ciudadLabel.text = "Ciudad: "+clima.nombreCiudad
            self.descripcionLabel.text = clima.descripcionClima.capitalized
            self.velVientoLabel.text = "Velocidad viento: "+String(clima.vientoVel)
            self.tempMinimaLabel.text = "T. Min: "+String(clima.temperaturaMinima)+"°C"
            self.tempMaximaLabel.text = "T. Max: " + String(clima.temperaturaMaxima)+"°C"
        }
        
        
    }
    
}

extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // ciudadLabel.text = buscarTF.text
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
        
        climaManager.fetchClima(nombreCiudad: buscarTF.text!)
        buscarTF.text=""
        
    }
    
}


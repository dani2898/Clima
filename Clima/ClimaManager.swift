import Foundation

protocol ClimaManagerDelegate{
    func actualizarClima(clima: ClimaModelo)
    
    func huboError(cualError: Error)
}

struct ClimaManager{
    
    var delegado: ClimaManagerDelegate?
    
    let climaUrl = "https://api.openweathermap.org/data/2.5/weather?APPID=5c038e9d43cb3d7e8f4b2de54c7d55ee&units=metric&lang=es"
    
    func fetchClima(nombreCiudad: String){
        let urlString = "\(climaUrl)&q=\(nombreCiudad)"
        
        print(urlString)
        
        realizarSolicitud(urlString: urlString)
    }
    
    func realizarSolicitud(urlString: String){
        //Crear url
        if let url = URL(string: urlString){
            //crear url session
            let session = URLSession(configuration: .default)
            
            //Asignar tarea a la sesión
            
            let tarea = session.dataTask(with: url)  {(data, respuesta, error) in
                if error != nil {
                    self.delegado?.huboError(cualError: error!)
                    
                    return
                }
                
                if let datosSeguros = data {
                    //Decodificar el objeto Json de la api
                    if let clima = self.parseJSON(climaData: datosSeguros){
                        self.delegado?.actualizarClima(clima: clima)
                    }
                
                }
            }
            
            //Empezar la tarea
            tarea.resume()
        }
        
        
    }
    
    func parseJSON(climaData: Data) -> ClimaModelo?{
        let decoder = JSONDecoder()
        do {
            let dataDecodificada = try decoder.decode(ClimaData.self, from: climaData)
            
            let id = dataDecodificada.weather[0].id
            let nombre = dataDecodificada.name
            let descripcion = dataDecodificada.weather[0].description
            let temperatura = dataDecodificada.main.temp
            
            let objClima = ClimaModelo(condicionID: id, nombreCiudad: nombre, descripcionClima: descripcion, temperaturaCelsius: temperatura)
            
            return objClima
            
        } catch  {
            self.delegado?.huboError(cualError: error)
            return nil
        }
       
    }
    
}

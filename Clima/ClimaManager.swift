import Foundation

struct ClimaManager{
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
                    print(error!)
                    return
                }
                
                if let datosSeguros = data {
                    //Decodificar el objeto Json de la api
                    self.parseJSON(climaData: datosSeguros)
                }
            }
            
            //Empezar la tarea
            tarea.resume()
        }
        
        
    }
    
    func parseJSON(climaData: Data){
        let decoder = JSONDecoder()
        do {
            let dataDecodificada = try decoder.decode(ClimaData.self, from: climaData)
            print(dataDecodificada.name)
            print(dataDecodificada.cod)
            print(dataDecodificada.main.humidity)
            print(dataDecodificada.weather[0].description)
            print("Latitud: \(dataDecodificada.coord.lat), longitud: \(dataDecodificada.coord.lon)")
        } catch  {
            print(error)
        }
       
    }
    
}

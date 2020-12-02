import Foundation

struct ClimaModelo{
    let condicionID: Int
    let nombreCiudad: String
    let descripcionClima: String
    let temperaturaCelsius: Double
    
    //crear propiedad computada
    
    var condicionClima: String{
        switch condicionID{
        case 200...232:
            return "storm"
        case 701...781:
            return  "fog"
        case 800:
            return "sun"
        default:
            return "clouds"
            
        }
    }
    
    var temperaturaDecimal: String{
        return String(format: "%.1f", temperaturaCelsius)
    }
    
}

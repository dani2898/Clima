import Foundation

struct ClimaModelo{
    let condicionID: Int
    let nombreCiudad: String
    let descripcionClima: String
    let temperaturaCelsius: Double
    let vientoVel: Double
    let temperaturaMinima: Double
    let temperaturaMaxima: Double
    
    //crear propiedad computada
    
    var condicionClima: String{
        switch condicionID{
        case 200...232:
            return "storm"
        case 300...321:
            return "drizzle"
        case 500...531:
            return "rain"
        case 600...622:
            return "snow"
        case 701...781:
            return  "mist"
        case 800:
            return "clear"
        default:
            return "clouds"
            
        }
    }
    
    var bgClima: String{
        switch condicionID{
        case 200...232:
            return "storm1"
        case 300...321:
            return "drizzle1"
        case 500...531:
            return "rain1"
        case 600...622:
            return "snow1"
        case 701...781:
            return  "mist1"
        case 800:
            return "clear1"
        default:
            return "clouds1"
            
        }
    }
    
    var temperaturaDecimal: String{
        return String(format: "%.1f", temperaturaCelsius)
    }
    
}

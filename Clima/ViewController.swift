//
//  ViewController.swift
//  Clima
//
//  Created by Mac13 on 22/11/20.
//  Copyright © 2020 daniela_villa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, ClimaManagerDelegate{
    
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
          self.ciudadLabel.text = clima.condicionClima
        }
        
        
    }
    
    
    var climaManager = ClimaManager()
    
    @IBOutlet weak var buscarTF: UITextField!
    @IBOutlet weak var ciudadLabel: UILabel!
    @IBOutlet weak var temperaturaLabel: UILabel!
    @IBOutlet weak var climaImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        climaManager.delegado = self
        buscarTF.delegate = self
        
    }
    
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


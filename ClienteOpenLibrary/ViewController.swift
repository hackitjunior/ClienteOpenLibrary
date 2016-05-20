//
//  ViewController.swift
//  ClienteOpenLibrary
//
//  Created by hackitjunior on 5/19/16.
//  Copyright © 2016 hackitjunior. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var isbn: UITextField!
    @IBOutlet weak var respuestaTextView: UITextView!
    
    /*
     Metodo para limpiar el isbn y pantalla de salida
     */
    @IBAction func limpiar(sender: AnyObject) {
        self.isbn.text!=""
        self.respuestaTextView.text=""
    }
    
    /*
     Metodo para realizar la llamada al sitio de manera asincrona
     */
    @IBAction func buscar(sender: AnyObject) {
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"+self.isbn.text!
        let url = NSURL(string: urls)
        let sesion = NSURLSession.sharedSession()
        let bloque={ (datos:NSData?, resp: NSURLResponse?, error:NSError?) -> Void in
            
            if (error != nil){
                
                //Muestra una alerta con el contenido del error.
                let alert = UIAlertController(title: "Ha ocurrido un error", message: String(error!), preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }else{
                
                let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                dispatch_sync(dispatch_get_main_queue()){
                    self.respuestaTextView.text=String(texto!)
                }
            }
        }
        
        let dt = sesion.dataTaskWithURL(url!,completionHandler:bloque)
        dt.resume()
        
    }
    
    /*
     Manejador para el evento cuando se de tap en el boton del teclado
     */
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == isbn {
            self.buscar(textField)
            self.isbn.resignFirstResponder();
            return false
        }
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isbn.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     func sincrono() {
     let urls = "https://openlibrary.org/"
     let url = NSURL(string: urls)
     let datos:NSData?=NSData(contentsOfURL: url!)
     let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
     print(texto)
     }
     
     func asincrono() {
     let urls = "https://openlibrary.org/"
     let url = NSURL(string: urls)
     let sesion = NSURLSession.sharedSession()
     let bloque={ (datos:NSData?, resp: NSURLResponse?, error:NSError?) -> Void in
     let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
     print(texto)
     }
     
     let dt = sesion.dataTaskWithURL(url!,completionHandler:bloque)
     dt.resume()
     print("Hola")
     }
     */

}
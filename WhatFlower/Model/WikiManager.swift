//
//  WikiManager.swift
//  WhatFlower
//
//  Created by Mayur Vaity on 20/05/24.
//

import Foundation

protocol WikiManagerDelegate {
    func didUpdateWiki(_ wikiManager: WikiManager, wiki: WikiModel)
    func didFailWithError(error: Error)
}

struct WikiManager {
    
    let wikiURL = "https://en.wikipedia.org/w/api.php?"
    
    var delegate: WikiManagerDelegate?
    
    var parameterDictinary: [String : String] = ["format": "json",
                                                 "action" : "query",
                                                 "titles" : "",
                                                 "exintro" : "",
                                                 "prop" : "extracts",
                                                 "explaintext" : "",
                                                 "indexpageids" : "",
                                                 "redirects" : "1"]
    
    //calculated variable for final URL
    var finalURL: String {
        get {
            var string1 = wikiURL
            for key in parameterDictinary.keys {
                string1 = string1 + "&" + key + "=" + parameterDictinary[key]!
            }
            return string1
        }
    }
    
    //method (actual POC from VC) , name to be changed later on
    mutating func getFinalURL(flowerName: String) {
        
        print("flowerName: \(flowerName)")
        let flowerNameAscii = flowerName.replacingOccurrences(of: " ",with: "%20")
        parameterDictinary["titles"] = flowerNameAscii
        
        print(finalURL)
        performRequest(with: finalURL)
    }
    
    //to perform API request
    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give a session a task
            let task = session.dataTask(with: url) { data, response, error in
                //handling error if url returns any error
                if error != nil {
                    //print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                //when url does not return an error, and returns data - below code is used to process it
                if let safeData = data {
                    //JSON formatted data received - and we need to parse it using below code
                    if let wiki = self.parseJSON(safeData) {
                        
                        //if parsed data is OK - and got it in WeatherModel object, then we need to use it in VC
                        //VC will adopt a protocol (WeatherManagerDelegate) and this below code will call the method inside it (which is created in the VC)
                        self.delegate?.didUpdateWiki(self, wiki: wiki)
                        
                    }
                }
            }
            
            //4. Start the task
            task.resume()
            
        }
    }
    
    //below fn is used decode data received in JSON format, and then to convert it into a WeatherModel object
    func parseJSON(_ wikiData: Data) -> WikiModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData =  try decoder.decode(WikiData.self, from: wikiData)
            let pageid = decodedData.query.pageids[0]
          
            
            let wiki = WikiModel(pageid: pageid)
            return wiki
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
    
}

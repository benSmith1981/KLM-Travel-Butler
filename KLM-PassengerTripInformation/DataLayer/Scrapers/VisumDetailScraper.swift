import Foundation
import Kanna
import Alamofire

class VisumDetailScraper {
    typealias htmlParseResponse = (Any?) -> Void
    
    public static func getVisumDetailInfo(countryCode: String, onCompletion: @escaping htmlParseResponse){
        let airportCodeLocal = Bundle.main.url(forResource: "EnglishDutchCountryName", withExtension: "json")
        
        Alamofire.request(airportCodeLocal!,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default).responseJSON { (response) in
                            
                            switch response.result {
                            case .success(let jsonData):
                                if let dutchCountryDict = jsonData as? NSDictionary {
                                    self.getCountryCodeAndName(from: dutchCountryDict, comparedWith: countryCode, onCompletion: { (result) in
                                        onCompletion(result)
                                    })
                                }
                                
                            case .failure(let error):
                                print("error \(error)")
                            }
        }
    }
    
    private static func getCountryCodeAndName(from countryNameDictionary: NSDictionary, comparedWith countryCode: String, onCompletion: @escaping htmlParseResponse){
        
        var dutchCountryName: String?
        
        for (key, value) in countryNameDictionary{
            if countryCode == String(describing: key) {
                dutchCountryName = String(describing: value)
                self.scrape(country: dutchCountryName!, onCompletion: { (result) in
                    onCompletion(result)
                })
            }
        }
    }
    
    
    
    private static func scrape(country: String, onCompletion: @escaping htmlParseResponse) {
        let url = "https://www.nederlandwereldwijd.nl/reizen/reisadviezen/\(country.lowercased())"
        
        Alamofire.request(url).responseString { response in
            print("Alamofire.request(url): \(response.result.isSuccess)")
            if response.result.isSuccess == false {
                onCompletion(nil)
            }
            if let html = response.result.value {
                self.parseVisum(html: html, country: country, onCompletion: { (result) in
                    onCompletion(result)
                })
            }
        }
    }
    
    private static func parseVisum(html: String, country: String, onCompletion: @escaping htmlParseResponse) {
        
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            var visaInfo = ""
            var visaStrings: [String] = []
            for visumDetail in doc.css("div[class^='topic']"){
                visaInfo = visumDetail.text!
                visaStrings.append(visaInfo)
            }
            
            let afg = visaStrings.contains(where: { (elementString) -> Bool in
                
                if elementString.contains("Reisdocumenten en visa") {
                    
                    let tempString = String(elementString)
                    
                    let detailVisaText = cleanVisaDetailString(tempString: tempString)
                    
                    onCompletion(detailVisaText)
                    
                    return true
                } else {
                    onCompletion(nil)
                    return false
                }
            })
        }
        
    }
    
    private static func cleanVisaDetailString(tempString: String) -> String{
        
        if let range = tempString.range(of: "Reisdocumenten en visa\n        \n            ") {
            
            let indexOfString = range.upperBound
            let firstPartRemoved = String(tempString[indexOfString...])
            let newRange = firstPartRemoved.range(of: ".Naar boven")
            let newIndexOfString = newRange!.lowerBound
            let lastPartRemoved = String(firstPartRemoved[...newIndexOfString])
//            let visaDetailString = lastPartRemoved.condenseWhitespace()
            
            return lastPartRemoved
        }
        return ""
    }
    
}

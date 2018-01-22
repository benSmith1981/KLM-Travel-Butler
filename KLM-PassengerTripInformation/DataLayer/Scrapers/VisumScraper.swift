import Foundation
import Kanna
import Alamofire

struct VisaData {
    var needVisaOrNot: Bool
    var countryCode: String
    var country: String
}

class VisumScraper {
    public static var sharedInstance = VisumScraper()
    private init() {}
    
    typealias htmlParseResponse = (VisaData?) -> Void
    var visaData = VisaData.init(needVisaOrNot: false, countryCode: "", country: "")

    public func getCountryFromAirportCode(airportCode: String, onCompletion: @escaping htmlParseResponse){
        let airportCodeLocal = Bundle.main.url(forResource: "airportCode", withExtension: "json")

        Alamofire.request(airportCodeLocal!,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default).responseJSON { (response) in
                            
                            switch response.result {
                            case .success(let jsonData):
                                if let codeArray = jsonData as? NSArray {
                                    self.checkAirportCodeIsEmpty(in: codeArray, with: airportCode, onCompletion: { (result) in
                                        onCompletion(result)
                                    })
                                }
                                
                            case .failure(let error):
                                print("error \(error)")
                            }
        }
    }
    
    private func checkAirportCodeIsEmpty(in codeArray: NSArray, with airportCode: String, onCompletion: @escaping htmlParseResponse){
        
        if airportCode != ""{
            for i in codeArray{
                if let airportCountryData = i as? NSDictionary{
                    self.getCountryCodeAndName(from: airportCountryData, comparedWith: airportCode, onCompletion: { (result) in
                        onCompletion(result)
                    })
                }
            }
        } else if airportCode == ""{
            onCompletion(nil)
        }
    }
    
    
    private func getCountryCodeAndName(from airportCountryData: NSDictionary, comparedWith airportCode: String, onCompletion: @escaping htmlParseResponse){
        
        
        if airportCode == airportCountryData["airportCode"] as? String{
            visaData.country = (airportCountryData["countryName"] as? String)!
            visaData.countryCode = (airportCountryData["countryCode"] as? String)!

            self.scrape(onCompletion: { (result) in
                onCompletion(result)
            })
        }
    }
    
    private func scrape(onCompletion: @escaping htmlParseResponse) {
        let url = "https://\(visaData.country.lowercased()).travisa.com/TVSVisaInstructions.aspx?CountryID=\(visaData.countryCode)&ResidenceID=US&CitizenshipID=NL&TravelerTypeID=TO&PartnerID=TA"
        
        Alamofire.request(url).responseString { response in
            print("Alamofire.request(url): \(response.result.isSuccess)")
            if response.result.isSuccess == false {
                onCompletion(nil)
            }
            if let html = response.result.value {
                self.parseVisum(html: html, onCompletion: { (result) in
                    onCompletion(result)
                })
            }
        }
    }
    
    private func parseVisum(html: String, onCompletion: @escaping htmlParseResponse) {
        
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            var visaInfo = ""
            var visaStrings: [String] = []
            
            for schipholData in doc.css("h2"){
                visaInfo = schipholData.text!
                visaStrings.append(visaInfo)
            }
            
            let afg = visaStrings.contains(where: { (elementString) -> Bool in
                
                if elementString.contains("Yes - A visa is required for travel to \(visaData.country.capitalizingFirstLetter())") {
                    
//                    let tempString = String(elementString)
//                    let finalString = String(tempString.prefix(3))
                    
                    visaData.needVisaOrNot = true
                    
                    onCompletion(visaData)
                    return true
                } else {
                    visaData.needVisaOrNot = false
                    onCompletion(visaData)
                }
                return false
            })
        }
    }
}

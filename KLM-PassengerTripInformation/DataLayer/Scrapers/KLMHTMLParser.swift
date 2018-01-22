import Foundation
import Kanna
import Alamofire

class KLMHTMLParser {
    typealias htmlParsrResponse = (Any?) -> Void
    typealias imageResponse = ([String]?, [String]?) -> Void
    
    //https://www.schiphol.nl/en/departures/flight/D20171120EZY8868/
    //call this with the url that you want to scrape
    
    static func scrape(url: String, onCompletion: @escaping htmlParsrResponse) {
        //we get an alamofire response string, so all the HTML...
        Alamofire.request(url).responseString { response in
            if response.result.isSuccess == false {
                onCompletion(nil)
            }
            if let html = response.result.value {
                self.parseSchiphol(html: html, onCompletion: { (result) in
                    onCompletion(result)
                })
            }
        }
    }
    
    //INSPECT THE PAGE SOURCE TO FIGURE OUT WHAT TAGS TO PARSE
    // view-source:https://www.schiphol.nl/en/departures/flight/D20171120EZY8868/
    //Get the contents of a div with ID = divDescription
    static func parseSchiphol(html: String, onCompletion: @escaping htmlParsrResponse){

        var obj = SchipholDataObject.init(waitTime: "", departTime: "", gate: "", checkInDesk: "", date: "", destination: "")
        var schipholArray: [String] = []
        var flightDataArray: [String] = []
        
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {

            for schipholData in doc.css("span[class^='clock__amount']") {
                var tempTime = schipholData.text!
                obj.waitTime = tempTime.removeReduntantChars()
            }
            
            for schipholData in doc.css("div[class^='time']") {
                var tempTime = schipholData.text!
                obj.departTime = tempTime.removeReduntantChars()
            }
            
            for schipholData in doc.css("span[class^='time-table__bd']") {
                var temp = schipholData.text!
                schipholArray.append(temp.removeReduntantChars())
            }
            
            for schipholData in doc.css("span[class^='flight-details__bd']") {
                var temp = schipholData.text!
                flightDataArray.append(temp.removeReduntantChars())
            }
            
            if schipholArray.count >= 4{
                obj.gate = schipholArray[4]
                obj.checkInDesk = schipholArray[3]
                obj.date = schipholArray[0]
                obj.destination = flightDataArray[0]
            } else {
                obj.gate = ""
                obj.checkInDesk = ""
                obj.date = ""
                obj.destination = ""
                obj.waitTime = ""
                obj.departTime = ""
            }
            
            onCompletion(obj)
        }
    }
}

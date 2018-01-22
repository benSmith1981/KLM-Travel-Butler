import Foundation

extension String{
    
    mutating func removeReduntantChars() -> String{
        self = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self = self.replacingOccurrences(of: "<[^]>]+>/", with: "", options: .regularExpression, range: nil)
        return self
    }
    
    mutating func removeNewLines() -> String {
        self = self.replacingOccurrences(of: "\n", with: "")
        return self
    }
    
    mutating func morphDate() -> String{
        self = self.replacingOccurrences(of: "-", with: "", options: .regularExpression, range: nil)
        return self
    }
    
    mutating func removeSpaces() -> String{
        self = self.replacingOccurrences(of: " ", with: "", options: .regularExpression, range: nil)
        return self
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func removeAirportCode() -> String{
        self = String(dropLast(5))
        return self
    }
    
    mutating func destinationToAirportCode() -> String{
        self = self.removeReduntantChars()
        self = self.removeSpaces()
        self = self.replacingOccurrences(of: ")", with: "")
        self = self.replacingOccurrences(of: "(", with: "")
        self = String(self.suffix(3))
        
        return self
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
}

import UIKit

 // SWAPPI base URL  =  https://swapi.co/api/
 /*Attributes
 "films": "https://swapi.co/api/films/",
 "people": "https://swapi.co/api/people/",
 "planets": "https://swapi.co/api/planets/",
 "species": "https://swapi.co/api/species/",
 "starships": "https://swapi.co/api/starships/",
 "vehicles": "https://swapi.co/api/vehicles/"
 
 */
struct People: Decodable {
    let name: String
    let films : [URL]
}

struct Film :Decodable {
    var title: String
    var opening_crawl: String
    var release_date : String
}

class SWAPIService {
    static private let baseURL = URL(string: "https://swapi.co/api/")
    static private let personPathCompopnent = "people"
    

    static func fetchPerson (id:Int,completion:@escaping(People?)->Void){
        guard let baseURL = baseURL else{ return completion(nil) }
        let peopleURL = baseURL.appendingPathComponent(personPathCompopnent)
        let finalURL = peopleURL.appendingPathComponent(String(id))
        
        print(finalURL)
    
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error{
                print("error!! \(error.localizedDescription )" )
                return completion(nil)
            }
            
            guard let data = data else{ return completion(nil) }
            do{
                let decoder = try JSONDecoder().decode(People.self, from: data)
                completion(decoder)
            } catch{
                print("error!!\(error.localizedDescription)")
                return completion(nil)
                
            }
            
        }.resume()
    } // end of Fetch
    
    
}// end of Class

SWAPIService.fetchPerson(id: 32) { (people) in
    if let people = people{
        print (people)
    }
}

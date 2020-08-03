import UIKit

// model

struct Person: Decodable{
    let name: String
    let films: [URL]
    
}

struct Film: Decodable{
    let title:  String
    let opening_crawl: String
    let release_date: String
}

class SwappiService{
    static let baseURL = URL(string: "http://swapi.dev/api/")
    static let filmEndpoint = "films"
    static let personEndpoint = "people"
    
    static func fetchPerson( personID: Int, completion: @escaping (Person?) -> Void) {
        guard let baseURL  = baseURL else{return completion(nil)}
        let personIDURL = baseURL.appendingPathComponent(personEndpoint)
        let finalURL = personIDURL.appendingPathComponent("\(personID)")
        print (finalURL)
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error{
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }else {guard let data = data else{return completion(nil)}
                //decode data
                do{
                    let person = try JSONDecoder().decode(Person.self, from: data)
                    return completion(person)
                }catch {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    return  completion(nil)
                }
                
            }
        }.resume()
        
        
        
    }
    static func fetchFilm(url:URL, completion: @escaping (Film?) -> Void) {
        let finalURL = url
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }else{
                guard let data = data else{ return completion(nil)}
                    
                    do{
                        let film = try JSONDecoder().decode(Film.self, from: data)
                        return completion(film)
                    }catch {
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                        return completion(nil)
                    }
                }
            }.resume()
        }
        
    }// End of class
    
    SwappiService.fetchPerson(personID: 1) { (persons) in
    guard let persons = persons else {return}
    print(persons.name)
    persons.films.forEach { (url) in
        SwappiService.fetchFilm(url: url) { (film) in
    guard let film = film else {return}
    print("\n"+"\n"+film.title+"\n")
    print(film.release_date+"\n")
    print(film.opening_crawl)
    }
}
}

import Foundation

protocol HttpService {
    func call<T : Decodable>(url: String, _ type: T.Type, execute work: @escaping (_ response: T) -> Void)
}

class MeteoHttpService : HttpService {
    func call<T : Decodable>(url: String, _ type: T.Type, execute work: @escaping (_ response: T) -> Void) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
            guard let data = data else {return}
            
            do {
                let response = try JSONDecoder().decode(type, from: data)
                DispatchQueue.main.async { work(response) }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}

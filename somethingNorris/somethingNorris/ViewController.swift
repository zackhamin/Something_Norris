//
//  ViewController.swift
//  chuckNorrisOne
//
//  Created by Ishaq Amin on 28/01/2020.
//  Copyright © 2020 Ishaq Amin. All rights reserved.
//
//
//  ViewController.swift
//  chuckNorris
//
//  Created by Ishaq Amin on 27/01/2020.
//  Copyright © 2020 Ishaq Amin. All rights reserved.
//

import UIKit


// MARK: - Welcome
struct Welcome: Codable {
    let type: String
    let value: Value
}

// MARK: - Value
struct Value: Codable {
    let id: Int
    let joke: String
    let categories: [String]
}

enum ApiError: Error {
    case noDateError
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var jokeOutLabel: UILabel!
    
    @IBOutlet weak var firstNameInputLabel: UITextField!
    
    @IBOutlet weak var secondNameInputlabel: UITextField!
    
    @IBAction func nameButton(_ sender: UIButton) {
        guard let firstName = firstNameInputLabel.text else { return }
        guard let lastName = secondNameInputlabel.text else { return }
        
        fetchJokesJSON(firstName: firstName , lastName: lastName ) { [weak self] (res) in
            self?.handleJokesResponse(res)
        }
    }
        
    fileprivate func fetchJokesJSON(firstName: String?, lastName: String?, completion: @escaping (Result<Welcome, Error>) -> ()) {
        
        var urlString = "http://api.icndb.com/jokes/random?"
        
        if let firstName = firstName {
            urlString.append("firstName=\(firstName)")
        }
        
        if let lastName = lastName {
            urlString.append("&lastName=\(lastName)")
        }
        
        guard let url = URL(string: urlString) else {return}
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                completion(.failure(err))
                return
            }
            
            guard let data = data else {
                completion(.failure(ApiError.noDateError))
                return
            }
            
            do {
                let jokes = try JSONDecoder().decode(Welcome.self, from:data)
                completion(.success(jokes))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    
    fileprivate func handleJokesResponse(_ res: Result<Welcome, Error>) {
        DispatchQueue.main.async {
            switch res {
            case .success(let welcome):
                self.jokeOutLabel.text = welcome.value.joke
                print(welcome.value.joke)
            case .failure(let err):
                print("Sorry, we are all laughed out! \(err)")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}





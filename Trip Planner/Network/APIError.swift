//
//  APIError.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//


import Foundation

enum APIError: Error {
    case urlError, serverError(String), decodingError, unknown
}

class APIClient {
    private let baseURL: URL

    init(baseURL: String) {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid base URL")
        }
        self.baseURL = url
    }

    func fetchTrips(completion: @escaping (Result<[Trip], APIError>) -> Void) {
        let url = baseURL.appendingPathComponent("/tripList")
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        
        print(url.path())

        URLSession.shared.dataTask(with: req) { data, resp, err in
            if let err = err {
                completion(.failure(.serverError(err.localizedDescription))); return
            }
            guard let data = data else { completion(.failure(.unknown)); return }

            do {
                let trips = try JSONDecoder().decode([Trip].self, from: data)
                completion(.success(trips))
            } catch {
                do {
                    let wrapper = try JSONDecoder().decode([String: [Trip]].self, from: data)
                    if let list = wrapper["trips"] {
                        completion(.success(list))
                    } else {
                        completion(.failure(.decodingError))
                    }
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }

    func fetchTrip(id: String, completion: @escaping (Result<Trip, APIError>) -> Void) {
        let url = baseURL.appendingPathComponent("/trips/\(id)")
        var req = URLRequest(url: url); req.httpMethod = "GET"
        URLSession.shared.dataTask(with: req) { data, resp, err in
            if let err = err { completion(.failure(.serverError(err.localizedDescription))); return }
            guard let data = data else { completion(.failure(.unknown)); return }
            do {
                let trip = try JSONDecoder().decode(Trip.self, from: data)
                completion(.success(trip))
            } catch { completion(.failure(.decodingError)) }
        }.resume()
    }

    func createTrip(_ trip: Trip, completion: @escaping (Result<Trip, APIError>, String) -> Void) {
        let url = baseURL.appendingPathComponent("/createTrip")
        var req = URLRequest(url: url); req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let data = try JSONEncoder().encode(trip)
            req.httpBody = data
        } catch {
            completion(.failure(.decodingError), "Failed to encode trip"); return
        }
        URLSession.shared.dataTask(with: req) { data, resp, err in
            if let err = err { completion(.failure(.serverError(err.localizedDescription)), "Failed to create trip"); return }
            guard let data = data else { completion(.failure(.unknown), "Failed to create trip"); return }
            do {
                completion(.success(trip), "Trip created successfully")
            } catch {
                completion(.failure(.decodingError), err.debugDescription)
            }
        }.resume()
    }
}

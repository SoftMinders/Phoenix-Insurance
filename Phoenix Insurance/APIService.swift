//
//  APIService.swift
//  Phoenix Insurance
//
//  Created by Soft Minders on 25/01/25.
//

import Foundation

// Singleton for API requests
class APIService {
    static let shared = APIService() // Singleton instance
    private init() {} // Prevent instantiation from outside

    private let baseURL = "http://197.225.162.115/practice/api"

    // Generic API request function
    private func performRequest<T: Decodable>(
        endpoint: String,
        method: String = "POST",
        requestBody: Data? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Updated Content-Type

        if let body = requestBody {
            request.httpBody = body
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            // Print raw response for debugging
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw Response: \(rawResponse)")
            }

            // Attempt decoding only if the response seems valid
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(APIError.decodingFailed))
            }
        }.resume()
    }

    // MARK: - API Method Example
    func login(username: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        // Prepare the body as form data (key-value pairs)
        let body = "username=\(username)&password=\(password)"
        guard let requestBody = body.data(using: .utf8) else {
            completion(.failure(APIError.encodingFailed))
            return
        }

        // Call performRequest with the updated body
        performRequest(endpoint: "/apilogin", method: "POST", requestBody: requestBody, responseType: LoginResponse.self, completion: completion)
    }

    // Fetch user profile
    func fetchDashboardData(brn: String,ucode: String, completion: @escaping (Result<DashboardResponse, Error>) -> Void) {
        let body = "brn=\(brn)&ucode=\(ucode)"
        print("Payload: \(body)")
        guard let requestBody = body.data(using: .utf8) else {
            completion(.failure(APIError.encodingFailed))
            return
        }

        // Call performRequest with the updated body
        performRequest(endpoint: "/apidashboard", method: "POST", requestBody: requestBody, responseType: DashboardResponse.self, completion: completion)
    }

    // Fetch other items
    func fetchItems(completion: @escaping (Result<[Item], Error>) -> Void) {
        performRequest(endpoint: "/items", responseType: [Item].self, completion: completion)
    }
}

// MARK: - Models

//=======================================================Login Start=============================================================[
struct LoginResponse: Codable {
    let user: User
    let success: Int
    let message: String
}

struct User: Codable {
    let ucode: String
    let fname: String
    let sname: String
    let username: String
    let brn: String
    let type: String
    let email: String
    let djoined: String
}

//=======================================================Login=============================================================[
//=======================================================Dashboard Start=============================================================[
struct DashboardResponse: Decodable {
    let current: CurrentData
    let target: TargetData
    let ren_m: RenMData
    let ren_nm: RenNMData?
    let ren_ach_m: RenAchMData
    let ren_ach_nm: RenAchNMData
    let new_ach_m: NewAchMData
    let new_ach_nm: NewAchNMData
    let m_pros: MProsData
    let n_pros: NProsData
    let com: ComData
    let cdr: CDRData
    let fq: FQData
    let lf: LFData
    let mdr: MDRData
    let nfq: NFQData
    let rfq: RFQData
    let fd: FDData
    let debtors_summ: DebtorsSummData
    let success: String
}

struct CurrentData: Decodable {
    let NEW_PREMIUM: String
    let NEW_POL_NO: String
    let RENEWAL_PREMIUM: String
    let RENEWAL_POL_NO: String
    let ENDORSEMENT_PREMIUM: String
    let ENDORSEMENT_POL_NO: String
    let CANCEL_PREMIUM: String
    let CANCEL_POL_NO: String
    let TOTAL_PREMIUM: String
    let TOTAL_POL_NO: String
}

struct TargetData: Decodable {
    let mc: String
    let m3: String
    let mn: String
    let tot_prem: String
    let tr_mot: String
    let tr_non: String
    let tot_target: String
    let per_mot: String
    let per_non: String
    let per_total: String
    let p_comm: String
}

struct RenMData: Decodable {
    let REN_PREM: String
}

struct RenNMData: Decodable {
    let REN_PREM: String?
}

struct RenAchMData: Decodable {
    let ACH_REN_M: String
}

struct RenAchNMData: Decodable {
    let ACH_REN_NM: String
}

struct NewAchMData: Decodable {
    let ACH_NEW_M: String
}

struct NewAchNMData: Decodable {
    let ACH_NEW_NM: String
}

struct MProsData: Decodable {
    let PREMIUM: String
}

struct NProsData: Decodable {
    let PREMIUM: String
}

struct ComData: Decodable {
    let COMM: String
}

struct CDRData: Decodable {
    let DAILY_CALL: String
}

struct FQData: Decodable {
    let FQ: String
}

struct LFData: Decodable {
    let LAPSED: String
}

struct MDRData: Decodable {
    let DAILY_CALL: String
}

struct NFQData: Decodable {
    let FQ: String
}

struct RFQData: Decodable {
    let FQ: String
}

struct FDData: Decodable {
    let FD: String
}

struct DebtorsSummData: Decodable {
    let DAYS_60: String
    let DAYS_90: String
    let DAYS_180: String
    let DAYS_360: String
    let DAYS_TOTAL: String
}
//=======================================================Dashboard=============================================================[

struct Item: Codable {
    let id: Int
    let name: String
    let price: Double
}

// MARK: - API Errors
enum APIError: LocalizedError {
    case invalidURL
    case noData
    case decodingFailed
    case encodingFailed
    case invalidResponseFormat
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The API URL is invalid."
        case .noData: return "No data received from the server."
        case .decodingFailed: return "Failed to decode the API response."
        case .encodingFailed: return "Failed to encode the request body."
        case .invalidResponseFormat: return "Mismatch in Content-Type from Server"
        case .invalidResponse: return "Invalid response from the server"
        }
    }
}

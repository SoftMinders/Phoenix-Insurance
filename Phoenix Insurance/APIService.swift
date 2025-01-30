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

    // Do Login
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
    // Fetch Dashboard Data
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
    // Fetch All Contacts
    func fetchAllContactsData(ucode: String, completion: @escaping (Result<ContactResponse, Error>) -> Void) {
        let body = "ucode=\(ucode)"
        print("Payload: \(body)")
        guard let requestBody = body.data(using: .utf8) else {
            completion(.failure(APIError.encodingFailed))
            return
        }

        // Call performRequest with the updated body
        performRequest(endpoint: "/getAllContacts", method: "POST", requestBody: requestBody, responseType: ContactResponse.self, completion: completion)
    }
    //Fetch Single Contact Data
    func fetchSingleContactsData(cust_id: String, completion: @escaping (Result<SingleContactResponse, Error>) -> Void) {
        let body = "cust_id=\(cust_id)"
        print("Payload: \(body)")
        guard let requestBody = body.data(using: .utf8) else {
            completion(.failure(APIError.encodingFailed))
            return
        }

        // Call performRequest with the updated body
        performRequest(endpoint: "/getSingleContact", method: "POST", requestBody: requestBody, responseType: SingleContactResponse.self, completion: completion)
    }
    //Fetch New Business Followup List
    func fetchNewBusinessFollowups(ucode: String, completion: @escaping (Result<NewBusinessFollowupsResponse, Error>) -> Void) {
        let body = "ucode=\(ucode)"
        print("Payload: \(body)")
        guard let requestBody = body.data(using: .utf8) else {
            completion(.failure(APIError.encodingFailed))
            return
        }

        // Call performRequest with the updated body
        performRequest(endpoint: "/getNewBusinessFollowUps", method: "POST", requestBody: requestBody, responseType: NewBusinessFollowupsResponse.self, completion: completion)
    }
    //Fetch Single Business Followup
    func fetchSingleNewBusinessFollowups(bus_id: String, completion: @escaping (Result<NewBusinessFollowupsSingleResponse, Error>) -> Void) {
        let body = "bus_id=\(bus_id)"
        print("Payload: \(body)")
        guard let requestBody = body.data(using: .utf8) else {
            completion(.failure(APIError.encodingFailed))
            return
        }

        // Call performRequest with the updated body
        performRequest(endpoint: "/grtSingleBusinessFollowUp", method: "POST", requestBody: requestBody, responseType: NewBusinessFollowupsSingleResponse.self, completion: completion)
    }
    //Fetch Single Renewal Data
    func fetchSingleRenewalPolicy(ucode: String, vehicle_id: String, completion: @escaping (Result<SingleRenewalResultResponse, Error>) -> Void) {
        let body = "ucode=\(ucode)&vehicle_id=\(vehicle_id)"
        print("Payload: \(body)")
        guard let requestBody = body.data(using: .utf8) else {
            completion(.failure(APIError.encodingFailed))
            return
        }

        // Call performRequest with the updated body
        performRequest(endpoint: "/getRenewalResult", method: "POST", requestBody: requestBody, responseType: SingleRenewalResultResponse.self, completion: completion)
    }
    //Fetch All Renewal Followups
    func fetchRenewalPolicyFollowups(ucode: String, completion: @escaping (Result<RenewalFollowupsResponse, Error>) -> Void) {
        let body = "ucode=\(ucode)"
        print("Payload: \(body)")
        guard let requestBody = body.data(using: .utf8) else {
            completion(.failure(APIError.encodingFailed))
            return
        }

        // Call performRequest with the updated body
        performRequest(endpoint: "/getRenewalFollowUpList", method: "POST", requestBody: requestBody, responseType: RenewalFollowupsResponse.self, completion: completion)
    }
    //Fetch All Renewal List
    func fetchRenewalPolicyList(ucode: String, date_from: String, date_to: String, completion: @escaping (Result<RenewalListDataResponse, Error>) -> Void) {
        let body = "ucode=\(ucode)&date_from=\(date_from)&date_to=\(date_to)"
        print("Payload: \(body)")
        guard let requestBody = body.data(using: .utf8) else {
            completion(.failure(APIError.encodingFailed))
            return
        }
        // Call performRequest with the updated body
        performRequest(endpoint: "/getRenewalList", method: "POST", requestBody: requestBody, responseType: RenewalListDataResponse.self, completion: completion)
    }

}

// MARK: - Models
//=======================================================Renewal List Data Start=============================================================
struct RenewalListDataResponse: Codable {
    var renew_list: [RenewList]
    var success: String
    var from: String
    var to: String
}
struct RenewList: Codable, Identifiable  {
    var id: String { POL_POLICY_NO }
    
    var POL_POLICY_NO: String
    var POL_PRD_CODE: String?
    var POL_CLA_CODE: String?
    var DES: String?
    var RISK: String?
    var MAKE: String?
    var MODEL: String?
    var CAP: String?
    var YOM: String?
    var V_LEVEL: String?
    var P_FROM: String?
    var P_TO: String?
    var CUST_NAME: String?
    var CUST_ADDR: String?
    var TEL: String?
    var POL_PREMIUM: String?
    
    enum CodingKeys: String, CodingKey {
        case POL_POLICY_NO, POL_PRD_CODE, POL_CLA_CODE, DES, RISK, MAKE, MODEL, CAP, YOM, V_LEVEL, P_FROM, P_TO, CUST_NAME, CUST_ADDR, TEL, POL_PREMIUM
    }
}
//=======================================================Renewal List Data End=============================================================
//=======================================================Renewal Followups Start=============================================================
struct RenewalFollowupsResponse: Codable {
    var business: [RenewalFollowupBusinesses]
    var success: String
}
struct RenewalFollowupBusinesses: Codable, Identifiable  {
    var id: String { MTB_SEQ }
    
    var MTB_SEQ: String
    var MTB_MMC_ID: String?
    var MTB_FOLLOW_UP_DATE: String?
    var CONTACT: String?
    var MMC_MOBILENO: String?
    var MTB_VEHI_NO: String?
    var CLASS: String?
    var PRODUCT: String?
    var MTB_TYPE_OF_PROSPECTIVE: String?
    var MTB_POL_NO: String?
    
    enum CodingKeys: String, CodingKey {
        case MTB_SEQ, MTB_MMC_ID, MTB_FOLLOW_UP_DATE, CONTACT, MMC_MOBILENO, MTB_VEHI_NO, CLASS, PRODUCT, MTB_TYPE_OF_PROSPECTIVE, MTB_POL_NO
    }
}
//=======================================================Renewal Followups End=============================================================
//=======================================================Single Renewal List Start=============================================================
struct SingleRenewalResultResponse: Codable {
    var veh_details: VehicleDetails
    var success: String
}
struct VehicleDetails: Codable {
    let VEH_NO: String
    let POL_POLICY_NO: String
    let CUST_NAME: String
    let TEL: String
    let POL_PERIOD_FROM: String
    let POL_PERIOD_TO: String
    let POL_DAYS: String
    let POL_CLA_CODE: String
    let POL_PRD_CODE: String
    let POL_SUM_INSURED: String
    let CLASS: String
    let PRODUCT: String
}
//=======================================================Single Renewal List End=============================================================
//=======================================================New Business Followups Single Start=============================================================
struct NewBusinessFollowupsSingleResponse: Codable {
    var business: SingleBusiness
    var success: String
}
struct SingleBusiness: Codable  {
    var MTB_SEQ: String
    var MTB_MMC_ID: String
    var MTB_FOLLOW_UP_DATE: String
    var CONTACT: String
    var MMC_MOBILENO: String
    var MTB_VEHI_NO: String
    var CLASS: String
    var PRODUCT: String
    var MTB_TYPE_OF_PROSPECTIVE: String
}
//=======================================================New Business Followups Single End=============================================================
//=======================================================New Business Followups Start=============================================================
struct NewBusinessFollowupsResponse: Codable {
    var business: [Businesses]
    var success: String
    var user_code: String
}
struct Businesses: Codable, Identifiable  {
    var id: String { MTB_SEQ }
    
    var MTB_SEQ: String
    var MTB_MMC_ID: String?
    var MTB_FOLLOW_UP_DATE: String?
    var CONTACT: String?
    var MMC_MOBILENO: String?
    var MTB_VEHI_NO: String?
    var CLASS: String?
    var PRODUCT: String?
    var MTB_TYPE_OF_PROSPECTIVE: String?
    
    enum CodingKeys: String, CodingKey {
        case MTB_SEQ, MTB_MMC_ID, MTB_FOLLOW_UP_DATE, CONTACT, MMC_MOBILENO, MTB_VEHI_NO, CLASS, PRODUCT, MTB_TYPE_OF_PROSPECTIVE
    }
}
//=======================================================New Business Followups End=============================================================
//=======================================================All Contacts Start=============================================================
// Define the structure of a contact based on the API response
struct SingleContactResponse: Codable {
    var contactval: SingleContact
    var contactref: [String] // You can modify this based on the actual structure of `contactref`
    var contactinfo: ContactInfo
    var success: String
}

struct ContactInfo: Codable {
    var MTB_POL_NO: String?
    var MTB_VEHI_NO: String?
    var MTB_PREMIUM: String?
    var MTQ_PERIOD_FORM: String?
    var MTQ_PERIOD_TO: String?
    var MTB_STATUS: String?
    var MTB_BUS_STATUS: String?
}
struct SingleContact: Identifiable, Codable {
    var id: String { return MMC_ID }
    var MMC_ID: String
    var MMC_SURNAME: String
    var MMC_FIRSTNAME: String
    var MMC_INITIALS: String?
    var MMC_TITLE: String?
    var MMC_MOBILENO: String?
    var MMC_EMAIL: String?
    var MMC_ADDRESS1: String?
    var MMC_ADDRESS2: String?
    var MMC_ADDRESS3: String?
    var MMC_CITY: String?
    var MMC_DISTRICT: String?
    var MMC_BUSINESS_OCC: String?
    var MMC_STATUS: String?
    var MMC_BRN: String?
    var MMC_SOURCE_OF_FUND: String?
}
struct ContactResponse: Codable {
    let contacts: [APIContact]
    let success: String
}
struct APIContact: Codable, Identifiable {
    var id: String { MMC_ID } // ✅ Ensures each contact has a unique identifier

    let MMC_ID: String
    let MMC_SURNAME: String
    let MMC_FIRSTNAME: String
    let MMC_TITLE: String?
    let MMC_NICNO: String?
    let MMC_PHONENO: String?
    let MMC_MOBILENO: String?
    let MMC_EMAIL: String?
    let MMC_ADDRESS1: String?
    let MMC_ADDRESS2: String?
    let MMC_ADDRESS3: String?
    let MMC_CITY: String?
    let MMC_DISTRICT: String?
    let MMC_BUSINESS_OCC: String?
    let MMC_REF_ID: String?
    let MMC_MECODE: String?
    let CREATED_BY: String?
    let CREATED_DATE: String?
    let MODIFY_BY: String?
    let MODIFY_DATE: String?
    let MMC_STATUS: String?
    let MMC_BRN: String?
    let MMC_SOURCE_OF_FUND: String?

    // ✅ Explicitly define CodingKeys to match API JSON keys
    enum CodingKeys: String, CodingKey {
        case MMC_ID, MMC_SURNAME, MMC_FIRSTNAME, MMC_TITLE, MMC_NICNO, MMC_PHONENO,
             MMC_MOBILENO, MMC_EMAIL, MMC_ADDRESS1, MMC_ADDRESS2, MMC_ADDRESS3,
             MMC_CITY, MMC_DISTRICT, MMC_BUSINESS_OCC, MMC_REF_ID, MMC_MECODE,
             CREATED_BY, CREATED_DATE, MODIFY_BY, MODIFY_DATE, MMC_STATUS, MMC_BRN, MMC_SOURCE_OF_FUND
    }
}

//=======================================================All Contacts End=============================================================
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

//=======================================================Login=============================================================
//=======================================================Dashboard Start=============================================================
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
//=======================================================Dashboard=============================================================

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

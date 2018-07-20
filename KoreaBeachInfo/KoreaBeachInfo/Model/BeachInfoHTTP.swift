//
//  BeachInfoHTTP.swift
//  KoreaBeachInfo
//
//  Created by 김승진 on 2018. 7. 20..
//  Copyright © 2018년 김승진. All rights reserved.
//

import Foundation
import Alamofire

struct BeachInfoHTTP {
    
    static func fetch(regionName name: String, completion: @escaping (BeachInfo) -> Void) {
        
        let urlString = "http://apis.data.go.kr/1192000/OceansBeachInfoService/getOceansBeachInfo?serviceKey=Gr4546g9MxhBz8aFSpMIwmc36UWeZSStZdtrH%2FpMZcbf1ix50w50b2n5ZJ8QmrHtYqldkC5D8q9cWYDjGXpkEw%3D%3D"
        let url = URL(string: urlString)!
        
        let parameters: Parameters = [
            //      "serviceKey": "Gr4546g9MxhBz8aFSpMIwmc36UWeZSStZdtrH%2FpMZcbf1ix50w50b2n5ZJ8QmrHtYqldkC5D8q9cWYDjGXpkEw%3D%3D",
            "pageNo": 1,
            "startPage": 1,
            "numOfRows": 999,
            "pageSize": 10,
            "SIDO_NM":name,
            "resultType": "json",
            ]
        
        Alamofire
            .request(url, method: .get, parameters: parameters)
            .validate(statusCode: 200..<400)
            .responseData(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    do {
                        let result = try JSONDecoder().decode(BeachInfo.self, from: value)
                        completion(result)
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            })
    }

}

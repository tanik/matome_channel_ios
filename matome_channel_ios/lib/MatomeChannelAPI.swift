//
//  matome_channel_api.swift
//  matome_channel_ios
//
//  Created by TanimotoKouichi on 2017/06/23.
//  Copyright © 2017年 Kouichi Tanimoto. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

enum Response<ResultMapper>{
    case Result(ResultMapper)
    case Error(Error)
}

public class MatomeChannelAPI {
    static let baseURL = "https://m-ch.xyz/backend";

    private func request<T>(
        _ path: String,
        method: HTTPMethod = .get,
        params: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        mapper: Mapper<T>,
        success: @escaping (_ result: T) -> Void,
        failure: ((_ error : Error) -> Void)? = nil
    ) -> Void {
        Alamofire.request(
            "\(MatomeChannelAPI.baseURL)\(path)",
            method: method,
            parameters: params,
            encoding: encoding,
            headers: headers
        ).validate().responseString { response in
            switch(response.result){
            case .success:
                guard let data = response.result.value else {
                    print("response value is empty")
                    return
                }
                let result = mapper.map(JSONString: data)
                success(result!)
            case .failure(let error):
                print(error)
                failure?(error)
            }
        }
    }

    func getBoards(params : Parameters? = nil,
                   success: @escaping (_ boardList: BoardList) -> Void,
                   failure: ((_ error : Error) -> Void)? = nil ) -> Void {
        let mapper = Mapper<BoardList>()
        request("/boards",
            params: params,
            mapper: mapper,
            success: success,
            failure: failure
        )
    }

    func getBoard(_ id: Int,
                   params : Parameters? = nil,
                   success: @escaping (_ board: Board) -> Void,
                   failure: ((_ error : Error) -> Void)? = nil ) -> Void {
        let mapper = Mapper<Board>()
        request("/boards/\(id)",
                params: params,
                mapper: mapper,
                success: success,
                failure: failure
        )
    }
}

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

enum MapperType{
    case Object
    case Array
}

public class MatomeChannelAPI {
    static let baseURL = "https://m-ch.xyz/backend";

    // TODO
    // Alamofireの処理もうちょいなんとか共通化とかしたいンゴ・・・
    // ジェネリクスとかでうまいことできるはずや・・・
    private func _af_request(
        _ path: String,
        method: HTTPMethod = .get,
        params: Dictionary<String, Any> = [:],
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil
    ) -> DataRequest {
        return  Alamofire.request(
                    "\(MatomeChannelAPI.baseURL)\(path)",
                    method: method,
                    parameters: params,
                    encoding: encoding,
                    headers: headers
        ).validate().response { response in
            // any common process
        }
    }

    private func request<T>(
        _ path: String,
        method: HTTPMethod = .get,
        params: Dictionary<String, Any> = [:],
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        mapper: Mapper<T>,
        success: @escaping (_ result: T) -> Void,
        failure: ((_ error : Error) -> Void)? = nil
    ) -> Void {
        _af_request(
            path,
            method: method,
            params: params,
            encoding: encoding,
            headers: headers
        ).responseObject { (response: DataResponse<T>) in
            switch(response.result){
            case .success:
                guard let data = response.result.value else {
                    print("response value is empty")
                    return
                }
                success(data)
            case .failure(let error):
                failure?(error)
            }
        }
    }

    private func requestArray<T>(
        _ path: String,
        method: HTTPMethod = .get,
        params: Dictionary<String, Any> = [:],
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        mapper: Mapper<T>,
        success: @escaping (_ result: [T]) -> Void,
        failure: ((_ error : Error) -> Void)? = nil
        ) -> Void {
        _af_request(
            path,
            method: method,
            params: params,
            encoding: encoding,
            headers: headers
        ).responseArray { (response: DataResponse<[T]>) in
            switch(response.result){
            case .success:
                guard let data = response.result.value else {
                    print("response value is empty")
                    return
                }
                success(data)
            case .failure(let error):
                failure?(error)
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////
    // Category
    //////////////////////////////////////////////////////////////////////////
    func getCategories(params : Dictionary<String, Any> = [:],
                       success: @escaping (_ categories: [Category]) -> Void,
                       failure: ((_ error : Error) -> Void)? = nil ) -> Void {
        let mapper = Mapper<Category>()
        requestArray("/categories",
                     params: params,
                     mapper: mapper,
                     success: success,
                     failure: failure
        )
    }

    //////////////////////////////////////////////////////////////////////////
    // Board
    //////////////////////////////////////////////////////////////////////////
    func getBoards(params : Dictionary<String, Any> = [:],
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
                   params : Dictionary<String, Any> = [:],
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

    func createBoard(title: String,
                     category_id: Int,
                     name: String,
                     content: String,
                     params : Dictionary<String, Any> = [:],
                     success: @escaping (_ board: Board) -> Void,
                     failure: ((_ error : Error) -> Void)? = nil ) -> Void {
        let mapper = Mapper<Board>()
        let params = [
            "board": [
                "title": title,
                "category_id": category_id,
                "comments_attributes": [[
                    "name": name,
                    "content": content
                ]]
            ]
        ] as [String : Any]
        request("/boards",
                method: .post,
                params: params,
                mapper: mapper,
                success: success,
                failure: failure
        )
    }

    //////////////////////////////////////////////////////////////////////////
    // Comment
    //////////////////////////////////////////////////////////////////////////
    func getBoardComments(_ board_id: Int,
                  lt_id: Int? = nil,
                  gt_id: Int? = nil,
                  params : Dictionary<String, Any> = [:],
                  success: @escaping (_ comments: [Comment]) -> Void,
                  failure: ((_ error : Error) -> Void)? = nil ) -> Void {
        let mapper = Mapper<Comment>()
        var url = ""
        if (lt_id != nil) && (gt_id != nil) {
            url = "/boards/\(board_id)/comments/gtlt/\(gt_id!)/\(lt_id!)"
        }else if (gt_id != nil) {
            url = "/boards/\(board_id)/comments/gt/\(gt_id!)"
        }else if (lt_id != nil) {
            url = "/boards/\(board_id)/comments/lt/\(lt_id!)"
        }else{
            url = "/boards/\(board_id)/comments"
        }
        requestArray(url,
            params: params,
            mapper: mapper,
            success: success,
            failure: failure
        )
    }

    func createComment(board_id: Int,
                       name: String,
                       content: String,
                       success: @escaping (_ comment: Comment) -> Void,
                       failure: ((_ error : Error) -> Void)? = nil ) -> Void {
        let mapper = Mapper<Comment>()
        let params = [
            "comment": [
                "name": name,
                "content": content
            ]
        ] as [String : Any]
        request("/boards/\(board_id)/comments",
            method: .post,
            params: params,
            mapper: mapper,
            success: success,
            failure: failure
        )
    }
}

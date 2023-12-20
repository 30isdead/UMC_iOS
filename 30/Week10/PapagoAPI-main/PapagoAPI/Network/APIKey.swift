//
//  APIKey.swift
//  PapagoAPI
//
//  Created by Dongwan Ryoo on 12/18/23.
//
//보통 Key는 type property로 지정 후 관리
//github 업로드 할 때 ignore 처리 해야함.

import Foundation

import Alamofire
import SwiftyJSON

struct APIKey {
    static let NAVERKey: HTTPHeaders = [
        "X-Naver-Client-Id":"AgYuS7RHdaVG_CeyBRSz",
        "X-Naver-Client-Secret":"lTxxiEj0ZH"
    ]
}

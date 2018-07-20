//
//  BeachInfo.swift
//  KoreaBeachInfo
//
//  Created by 김승진 on 2018. 7. 20..
//  Copyright © 2018년 김승진. All rights reserved.
//

import Foundation

struct BeachInfo: Decodable {
    
    let oceanBeachsInfo : ItemInfo
    
    private enum RootKeys: String, CodingKey {
        case oceanBeachsInfo = "getOceansBeachInfo"
    }
    
    struct ItemInfo: Decodable {
        
        let item: [Item]
        
        private enum ItemKeys: String, CodingKey {
            case item
        }
        
        struct Item: Decodable {
            let beachId: String?
            let sidoName: String?
            let gugunName: String?
            let staName: String?
            let beachWidtd: Double?
            let beachLength: Double?
            let beacnKnd: String?
            let linkAddr: String?
            let linkName: String?
            let beachImage: String?
            let linkTel: String?
            let latitude: Double?
            let longitude: Double?
            
            private enum Itemkeys: String, CodingKey {
                case beachId = "beach_id"
                case sidoName = "sido_nm"
                case gugunName = "gugun_nm"
                case staName = "sta_nm"
                case beachWidtd = "beach_wid"
                case beachLength = "beach_len"
                case beacnKnd = "beach_knd"
                case linkAddr = "link_addr"
                case linkName = "link_nm"
                case beachImage = "beach_img"
                case linkTel = "link_tel"
                case latitude = "lat"
                case longitude = "lon"
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: Itemkeys.self)
                self.beachId = try container.decodeIfPresent(String.self, forKey: .beachId)
                self.sidoName = try container.decodeIfPresent(String.self, forKey: .sidoName)
                self.gugunName = try container.decodeIfPresent(String.self, forKey: .gugunName)
                self.staName = try container.decodeIfPresent(String.self, forKey: .staName)
                self.beachWidtd = try container.decodeIfPresent(Double.self, forKey: .beachWidtd)
                self.beachLength = try container.decodeIfPresent(Double.self, forKey: .beachLength)
                self.beacnKnd = try container.decodeIfPresent(String.self, forKey: .beacnKnd)
                self.linkAddr = try container.decodeIfPresent(String.self, forKey: .linkAddr)
                self.linkName = try container.decodeIfPresent(String.self, forKey: .linkName)
                self.beachImage = try container.decodeIfPresent(String.self, forKey: .beachImage)
                self.linkTel = try container.decodeIfPresent(String.self, forKey: .linkTel)
                self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
                self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
            }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: ItemKeys.self)
            self.item = try container.decode([Item].self, forKey: .item)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        self.oceanBeachsInfo = try container.decode(ItemInfo.self, forKey: .oceanBeachsInfo)
        
    }
}



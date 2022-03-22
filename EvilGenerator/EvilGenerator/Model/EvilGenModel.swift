//
//  EvilGenModel.swift
//  EvilGenerator
//
//  Created by Майлс on 17.03.2022.
//

import Foundation

/*
 {
    "number":"123",
    "language":"en",
    "insult":"You're a failed abortion whose birth certificate is an apology from the condom factory.",
    "created":"2022-03-16 11:31:29",
    "shown":"188343",
    "createdby":"",
    "active":"1",
    "comment":""
 }
 */

struct EvilGenModel: Codable {
    let number: String
    let language: String
    let insult: String
    let created: String
    let shown: String
    let createdby: String
    let active: String
    let comment: String
}

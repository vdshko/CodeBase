//
//  GlobalFunctions.swift
//  CodeBase
//
//  Created by Vladyslav Shkodych on 25.03.2023.
//

import Foundation

func fileName(file: String = #fileID) -> String {
    return file.components(separatedBy: "/").last ?? ""
}

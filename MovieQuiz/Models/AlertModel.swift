//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Yura on 19.11.24.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}

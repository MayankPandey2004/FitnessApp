//
//  Double+Ext.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 30/11/25.
//

import Foundation

extension Double {
    func formattedNumberString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        return formatter.string(from: NSNumber(floatLiteral: self)) ?? "0"
    }
}

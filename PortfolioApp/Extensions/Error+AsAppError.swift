//
//  Error+AsAppError.swift
//  UberClone
//
//  Created by Vinh Phan on 15/11/25.
//

import Foundation

extension Error? {
  func asAppError() -> AppError {
    guard let error = self else { return DefaultAppError.empty }

    if let appError = error as? AppError {
      return appError
    }

    return DefaultAppError.empty
  }
}

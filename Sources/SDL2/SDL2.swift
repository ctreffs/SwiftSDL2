//
//  SDL2.swift
//
//
//  Created by Christian Treffs on 03.11.19.
//

@_exported import CSDL2

extension SDL_KeyCode: Equatable {}
extension SDL_KeyCode: Hashable {}


@_transparent 
public func SDL_Flag<I: FixedWidthInteger, R: RawRepresentable>(_ flag: R) -> I where R.RawValue: FixedWidthInteger {
    I(flag.rawValue)
}
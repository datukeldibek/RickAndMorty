//
//  Delegate.swift
//  RickAndMorty
//
//  Created by Jarae on 27/7/23.
//

import Foundation

protocol CharacterDelegate: AnyObject {
    func didReceiveCharacter(_ id: Int)
    func removeCharacter(_ id: Int)
}


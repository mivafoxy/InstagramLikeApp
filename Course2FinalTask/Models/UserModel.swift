//
//  UserModel.swift
//  Course2FinalTask
//
//  Created by Milandr on 27.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

// Класс обертка над типом данных DataProvider.User
// Создан для обхода ошибки
// unknown class _TtC16Course2FinalTask21ProfileViewController in Interface Builder file.
// Возникает, если напрямую делать поле во ViewController

import Foundation
import UIKit
import DataProvider

class UserModel {
    
    public let isCurrentUser: Bool
    
    public var id: String
    
    public var userPosts: [Post]
    
    /// Имя аккаунта пользователя
    public var username: String

    /// Полное имя пользователя пользователя
    public var fullName: String

    /// Аватар пользователя
    public var avatar: UIImage?

    /// Свойство, отображающее подписан ли текущий пользователь на этого пользователя
    public var currentUserFollowsThisUser: Bool

    /// Свойство, отображающее подписан ли этот пользователь на текущего пользователя
    public var currentUserIsFollowedByThisUser: Bool

    /// Количество подписок этого пользователя
    public var followsCount: Int

    /// Количество подписчиков этого пользователя
    public var followedByCount: Int
    
    public init(_ user: User, _ posts: [Post], _ isCurrentUser: Bool) {
        username = user.username
        fullName = user.fullName
        avatar = user.avatar
        currentUserFollowsThisUser = user.currentUserFollowsThisUser
        currentUserIsFollowedByThisUser = user.currentUserIsFollowedByThisUser
        followsCount = user.followsCount
        followedByCount = user.followedByCount
        id = user.id.rawValue
        userPosts = posts
        self.isCurrentUser = isCurrentUser
    }
}

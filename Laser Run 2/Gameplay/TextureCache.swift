//
//  TextureCache.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 21/01/2024.
//

import SpriteKit

class TextureCache {
    static let shared = TextureCache()
    private var textures: [String: SKTexture] = [:]

    private init() {}

    func preloadTextures(objectName: String, completion: @escaping () -> Void) {
          let textureNames = [objectName, objectName + " Yellow"]
          var texturesToPreload = [SKTexture]()

          for name in textureNames {
              let texture = SKTexture(imageNamed: name)
              texturesToPreload.append(texture)
          }

          SKTexture.preload(texturesToPreload, withCompletionHandler: {
              for name in textureNames {
                let texture = SKTexture(imageNamed: name)
                self.textures[name] = texture
              }
              completion()
          })
      }


    func getTexture(name: String) -> SKTexture? {
        return textures[name]
    }
}

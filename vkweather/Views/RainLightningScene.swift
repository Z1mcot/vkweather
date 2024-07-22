//
//  RainLightningScene.swift
//  vkweather
//
//  Created by Richard Dzubko on 22.07.2024.
//

import Foundation
import SpriteKit

class RainLightningScene: SKScene {

    static var shared = RainLightningScene()

    let rainEmitter = SKEmitterNode(fileNamed: "Particles/Rain.sks")!

    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        self.addChild(rainEmitter)

        rainEmitter.position.y = self.frame.maxY
        rainEmitter.particlePositionRange.dx = self.frame.width * 2.5
    }

}

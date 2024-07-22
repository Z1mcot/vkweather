//
//  ParticleView.swift
//  vkweather
//
//  Created by Richard Dzubko on 22.07.2024.
//

import UIKit
import SpriteKit

class ParticleView: UIView {
    @IBOutlet weak var rainScene: SKView!
    @IBOutlet weak var mistScene: SKView!
    
    private var rainParticleBirthrate: CGFloat
    private var rainParticleSpeed: CGFloat
    
    private var mistParticleBirthrate: CGFloat
    
    //MARK:  NIB Related
    static let nibName = "ParticleView"
    
    required init?(coder: NSCoder) {
        rainParticleBirthrate = 0
        rainParticleSpeed = 0
        mistParticleBirthrate = 0
        super.init(coder: coder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        rainParticleBirthrate = 0
        rainParticleSpeed = 0
        mistParticleBirthrate = 0
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: ParticleView.nibName, bundle: nil)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as?
                            UIView else {fatalError("Unable to convert nib")}

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)
        
        rainScene.makeBackgroundTransparent()
        mistScene.makeBackgroundTransparent()
    }
}

//MARK: - Weather Delegate
extension ParticleView: WeatherModelChangeDelegate {
    func onModelChanged(_ weather: Weather) {
        switch weather {
        case .misty:
            mistParticleBirthrate = 50
            rainParticleSpeed = 0
            rainParticleBirthrate = 0
        case .sunny, .cloudy:
            rainParticleSpeed = 0
            rainParticleBirthrate = 0
            mistParticleBirthrate = 0
        case .rainy:
            rainParticleBirthrate = 150
            rainParticleSpeed = 340
            mistParticleBirthrate = 0
        case .stormy:
            rainParticleBirthrate = 250
            rainParticleSpeed = 540
        }
        DispatchQueue.main.async {
            self.rainScene.animateParticleChange(particleBirthrate: self.rainParticleBirthrate, particleSpeed: self.rainParticleSpeed)
        }
        DispatchQueue.main.async {
            self.mistScene.animateParticleChange(particleBirthrate: self.mistParticleBirthrate, particleSpeed: 0)
        }
    }
    
    
}

extension SKView {
    func animateParticleChange(particleBirthrate: CGFloat, particleSpeed: CGFloat) {
        guard let rainEmitters = self.scene?.children as? [SKEmitterNode] else {
            assertionFailure("Couldn't find particleEmitter")
            return
        }
        
        rainEmitters.forEach {
            emmiter in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                    emmiter.particleBirthRate = particleBirthrate
                    emmiter.particleSpeed = particleSpeed
                })
            }
        }
    }
    
    func makeBackgroundTransparent() {
        self.allowsTransparency = true
        self.backgroundColor = .clear
        self.scene?.backgroundColor = .clear
    }
}

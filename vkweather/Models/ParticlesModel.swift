//
//  ParticleViewModel.swift
//  vkweather
//
//  Created by Richard Dzubko on 22.07.2024.
//

import Foundation

struct ParticlesModel {
    private var rainParticleBirthrate: CGFloat
    private var rainParticleSpeed: CGFloat
    private var mistParticleBirthrate: CGFloat
    
    init(rainParticleBirthrate: CGFloat = 0, rainParticleSpeed: CGFloat = 0, mistParticleBirthrate: CGFloat = 0) {
        self.rainParticleBirthrate = rainParticleBirthrate
        self.rainParticleSpeed = rainParticleSpeed
        self.mistParticleBirthrate = mistParticleBirthrate
    }
}

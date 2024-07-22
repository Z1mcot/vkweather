//
//  WeatherViewController.swift
//  vkweather
//
//  Created by Richard Dzubko on 20.07.2024.
//

import UIKit
import SpriteKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var rainScene: ParticleView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var buttonsScrollView: UIScrollView!
    @IBOutlet weak var skyboxView: UIView!
    @IBOutlet weak var colorFilterView: UIView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    var model = WeatherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonsScrollView.layer.cornerRadius = 5
        buttonsScrollView.layer.masksToBounds = true
        
        weatherLabel.adjustsFontSizeToFitWidth = true
        
        model.addDelegate(self)
        model.addDelegate(rainScene)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createClouds()
        
        model.setRandomWeather()
    }
    
    @IBAction func selectWeather(_ sender: UIButton) {
        let newWeather = Weather(rawValue: sender.tag)
        assert(newWeather != nil, "Trying to access nonexitant weather type")
        
        model.changeWeather(to: newWeather!)
    }
    
    private func createCloud(startingPosition: CGPoint, destination: CGPoint, width: Double = 150) {
        let size = CGSize(width: width, height: width * 0.66)
        let rect = CGRect(origin: startingPosition, size: size)
        
        let newCloudView = CloudView(frame: rect, start: startingPosition, destination: destination)
        
        skyboxView.addSubview(newCloudView)
        
        model.addDelegate(newCloudView)
    }
    
    private func createClouds() {
        guard let screenBounds = view.window?.screen.bounds else {
            assertionFailure("Cannot determine screen size")
            return
        }
        
        let minX: Double = 0
        let maxX = max(screenBounds.width, screenBounds.height)
        
        for i in 0...36 {
            let y = Double.random(in: 16...116)
            
            let cloudWidth = Double.random(in: 150...200)
            
            var startingPosition: CGPoint
            var destination: CGPoint
            
            let placeLeftOfScreen = i % 2 == 0
            startingPosition = CGPoint(
                x: placeLeftOfScreen ? minX - cloudWidth
                                     : maxX,
                y: y)
            destination = CGPoint(x: Double.random(in: -16...maxX + 16),
                                  y: y)
            
            createCloud(startingPosition: startingPosition, destination: destination, width: cloudWidth)
        }
    }
    
    //MARK: Animations
    private func animateBackgroundTransition(isRaining: Bool) {
        let resource: ImageResource = isRaining ? .backgroundWithWater : .background
        let newImage = UIImage(resource: resource)
        UIView.transition(with: backgroundImage,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { self.backgroundImage.image = newImage },
                          completion: nil)
    }
    
    private func animateButtonColorChange(buttonView: UIButton) {
        let isSelected = buttonView.tag == self.model
            .currentWeather
            .rawValue
        
        var finalBackgroundColor: UIColor = .unselectedBackground
        var finalForegroundColor: UIColor = .unselectedForeground
        
        if isSelected {
            finalBackgroundColor = .selectedBackground
            finalForegroundColor = .selectedForeground
        }
        
        UIView.transition(with: backgroundImage,
                          duration: 0.25,
                          options: .transitionCrossDissolve) {
            buttonView.backgroundColor = finalBackgroundColor
            buttonView.configuration?.baseForegroundColor = finalForegroundColor
        }
    }
    
    private func setColorFilter() {
        switch model.currentWeather {
        case.rainy:
            colorFilterView.backgroundColor = .rainColorFilter
        case .stormy:
            colorFilterView.backgroundColor = .stormColorFilter
        default:
            colorFilterView.backgroundColor = .clear
        }
    }
    
    private func animateLabelTextChange() {
        weatherLabel.text? = ""
        
        for (i, letter) in model.currentWeather.description.enumerated() {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(i), repeats: false) {
                _ in
                self.weatherLabel.text?.append(letter)
            }
        }
    }
}

//MARK: - Weather Delegate
extension WeatherViewController: WeatherModelChangeDelegate {
    func onModelChanged(_ weather: Weather) {
        let isRaining = [.rainy, .stormy].contains(weather)
        
        let uiUpdateQueue = DispatchQueue.main
        
        buttonsScrollView.subviews.forEach {
            button in
            uiUpdateQueue.async {
                guard let castedButton = button as? UIButton else {
                    assertionFailure("Found a nonbutton object in buttonScrollView. Got: \(button.description)")
                    return
                }
                
                self.animateButtonColorChange(buttonView: castedButton)
            }
        }
        
        uiUpdateQueue.async {
            self.animateBackgroundTransition(isRaining: isRaining)
        }
        uiUpdateQueue.async {
            self.setColorFilter()
        }
        uiUpdateQueue.async {
            self.animateLabelTextChange()
        }
        
        
    }
}

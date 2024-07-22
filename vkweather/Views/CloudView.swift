//
//  Cloud.swift
//  vkweather
//
//  Created by Richard Dzubko on 22.07.2024.
//

import UIKit

class CloudView: UIView {
    @IBOutlet weak var cloudImage: UIImageView!
    
    private var start: CGPoint
    private var destination: CGPoint
    
    private func animateCloudChange(_ resource: ImageResource) {
        let newImage = UIImage(resource: resource)
        UIView.transition(with: cloudImage,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { self.cloudImage.image = newImage },
                          completion: nil)
    }
    
    private func animateCloudMovement(_ movePoint: CGPoint) {
        let frameSize = frame.size
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.frame = CGRect(origin: movePoint, size: frameSize)
        })
    }
    
    
    
    init(frame: CGRect, start: CGPoint, destination: CGPoint) {
        self.destination = destination
        self.start = frame.origin
        super.init(frame: frame)
        
        initSubviews()
    }
    
    //MARK:  NIB Related
    static let nibName = "CloudView"
    
    required init?(coder: NSCoder) {
        destination = CGPoint()
        start = CGPoint()
        super.init(coder: coder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        destination = CGPoint()
        start = CGPoint()
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: CloudView.nibName, bundle: nil)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as?
                            UIView else {fatalError("Unable to convert nib")}

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        addSubview(view)
    }
}

//MARK: - Weather Delegate
extension CloudView: WeatherModelChangeDelegate {
    func onModelChanged(_ weather: Weather) {
        var imageResource: ImageResource = .cloud
        var movePoint: CGPoint = start
        switch weather {
        case .sunny, .misty:
            break
        case .cloudy:
            movePoint = destination
        case .rainy:
            imageResource = .rainyCloud
            movePoint = destination
        case .stormy:
            imageResource = .stormyCloud
            movePoint = destination
        }
        DispatchQueue.main.async {
            self.animateCloudChange(imageResource)
        }
        DispatchQueue.main.async {
            self.animateCloudMovement(movePoint)
        }
    }
    
    
}

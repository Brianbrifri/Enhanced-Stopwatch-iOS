import UIKit

@IBDesignable
class ControlButtonView: UIControl {
	
	fileprivate(set) var titleLabel = UILabel()
	override var isEnabled: Bool {
		didSet {
			if isEnabled {
				borderLayer.strokeColor = borderColor?.cgColor
				titleLabel.textColor = UIColor.black
			} else {
				borderLayer.strokeColor = UIColor.lightGray.cgColor
				titleLabel.textColor = UIColor.lightGray
			}
		}
	}
	
	@IBInspectable var typeTitle: String? {
		didSet {
			titleLabel.text = typeTitle
		}
	}
	@IBInspectable var borderColor: UIColor? = UIColor.bone {
		didSet{
			borderLayer.strokeColor = borderColor?.cgColor
		}
	}
	fileprivate let borderLayer = CAShapeLayer()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		backgroundColor = UIColor.bone
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor.bone
	}
	
	override func draw(_ rect: CGRect) {
		setupView()
	}
	
	override func prepareForInterfaceBuilder() {
		backgroundColor = UIColor.bone
		setupView()
	}
	
	func setupView() {
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = CGPath(ellipseIn: bounds, transform: nil)
		layer.mask = shapeLayer
		
		borderLayer.path = CGPath(ellipseIn: CGRect.init(x: 1.25, y: 1.25, width: bounds.width - 2.5, height: bounds.height - 2.5), transform: nil)
		borderLayer.strokeColor = borderColor?.cgColor
		borderLayer.lineWidth = 2.5
		borderLayer.fillColor = UIColor.clear.cgColor
		layer.addSublayer(borderLayer)
		
		addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.textAlignment = .center
		titleLabel.textColor = UIColor.black
		
		titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		titleLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.9).isActive = true
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		let location = touch.location(in: touch.window)
		let touchTarget = convert(bounds, to: nil)
		
		if location.x > touchTarget.origin.x && location.x < (touchTarget.width + touchTarget.origin.x)
			&& location.y > touchTarget.origin.y && location.y < (touchTarget.height + touchTarget.origin.y) {
				backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
		} else {
			backgroundColor = UIColor.bone
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		backgroundColor = UIColor.bone
		guard let touch = touches.first else {
			return
		}
		let location = touch.location(in: touch.window)
		let touchTarget = convert(bounds, to: nil)
		
		if location.x > touchTarget.origin.x && location.x < (touchTarget.width + touchTarget.origin.x)
			&& location.y > touchTarget.origin.y && location.y < (touchTarget.height + touchTarget.origin.y) {
				
			sendActions(for: UIControlEvents.touchUpInside)
		}
	}
}


import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var animatibleView: UIView!
    @IBOutlet weak var slider: UISlider!

    var animator: UIViewPropertyAnimator = UIViewPropertyAnimator()
    let dimension: CGFloat = 60.0

    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = 0

        animatibleView.layer.cornerRadius = 10.0
    }

    @IBAction func sliderDidEndEditing(_ sender: Any) {
        if slider.value < 1.0 {
            slider.value = 1
            startAnimation(duration: 0.2)
        }
    }

    @IBAction func sliderValueChanged(_ slider: UISlider) {
        self.moveXByValue()
        self.rotateAndScaleWithValue()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        slider.sizeToFit()
        let sliderHeight = slider.frame.height
        let leading = view.directionalLayoutMargins.leading
        slider.frame = CGRectMake(leading, 300.0, view.frame.width - 2 * leading, sliderHeight)
    }

    func positionBaseValue(_ sliderValue: CGFloat) -> CGFloat { // для центра
        let availableWidth = view.frame.width - 2 * view.directionalLayoutMargins.leading - animatibleView.frame.width
        return sliderValue * availableWidth + view.directionalLayoutMargins.leading + 0.5 * animatibleView.frame.width
    }

    func rotateAndScaleWithValue() {
        let value = CGFloat(slider.value)
        let newScale = 1 + (value * CGFloat(0.5))
        let scaleTransofrm = CGAffineTransform(scaleX: newScale, y: newScale)

        let angle = CGFloat(1.5708 * value)
        let rotationTransform = CGAffineTransform(rotationAngle: angle)

        animatibleView.transform = scaleTransofrm.concatenating(rotationTransform)
    }

    func moveXByValue() {
        let value = CGFloat(slider.value)
        let positionX = positionBaseValue(value)
        animatibleView.center = CGPointMake(positionX, animatibleView.center.y)
    }

    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()

        let leading = view.directionalLayoutMargins.leading
        animatibleView.frame = CGRectMake(leading, 150, dimension, dimension)
    }

    func startAnimation(duration: TimeInterval) {
        if animator.state  == .active {
            animator.stopAnimation(true)
        }
        
        animator = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut) { [weak self] in
            guard let self else { return }
            rotateAndScaleWithValue()
            moveXByValue()
        }

        animator.startAnimation()
    }
 }

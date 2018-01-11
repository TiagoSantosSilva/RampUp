//
//  RamPickerViewController.swift
//  RampUp
//
//  Created by Tiago Santos on 10/01/18.
//  Copyright © 2018 Tiago Santos. All rights reserved.
//

import UIKit
import SceneKit

class RampPickerViewController: UIViewController {

    var sceneView: SCNView!
    var size: CGSize!
    weak var rampPlacerViewController: RampPlacerViewController!
    
    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.insertSubview(sceneView, at: 0)
        view.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.borderWidth = 3.0
        
        let scene = SCNScene(named: "art.scnassets/ramps.scn")!
        sceneView.scene = scene
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
        
        createSceneObjects(scene: scene)
        preferredContentSize = size
    }
    
    func createSceneObjects(scene: SCNScene) {
        let pipeNode = Ramp.getPipe()
        scene.rootNode.addChildNode(pipeNode)
        
        let pyramidNode = Ramp.getPyramid()
        scene.rootNode.addChildNode(pyramidNode)
        
        let quarterNode = Ramp.getQuarter()
        scene.rootNode.addChildNode(quarterNode)
    }
    
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let sceneViewPoint = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(sceneViewPoint, options: [:])
        
        if hitResults.count > 0 {
            let node = hitResults[0].node
            print(node.name!)
            rampPlacerViewController.onRampSelected(node.name!)
        }
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

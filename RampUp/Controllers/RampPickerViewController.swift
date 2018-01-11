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
        addObjectToScene(forScene: scene, forSceneName: "art.scnassets/pipe.dae", nodeName: "pipe", withScaleX: 0.0022, withScaleY: 0.0022, withScaleZ: 0.0022, positionX: -1, positionY: 0.7, positionZ: -1)
        addObjectToScene(forScene: scene, forSceneName: "art.scnassets/pyramid.dae", nodeName: "pyramid", withScaleX: 0.0058, withScaleY: 0.0058, withScaleZ: 0.0058, positionX: -1, positionY: -0.65, positionZ: -1)
        addObjectToScene(forScene: scene, forSceneName: "art.scnassets/quarter.dae", nodeName: "quarter", withScaleX: 0.0058, withScaleY: 0.0058, withScaleZ: 0.0058, positionX: -1, positionY: -2.2, positionZ: -1)
    }
    
    func addObjectToScene(forScene scene: SCNScene, forSceneName sceneName: String, nodeName: String, withScaleX scaleX: Float, withScaleY scaleY: Float, withScaleZ scaleZ: Float, positionX: Float, positionY: Float, positionZ: Float) {
        
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.01))
        
        let object = SCNScene(named: sceneName)
        let objectNode = object?.rootNode.childNode(withName: nodeName, recursively: true)!
        objectNode?.runAction(rotate)
        objectNode?.scale = SCNVector3Make(scaleX, scaleY, scaleZ)
        objectNode?.position = SCNVector3Make(positionX, positionY, positionZ)
        scene.rootNode.addChildNode(objectNode!)
    }
    
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let sceneViewPoint = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(sceneViewPoint, options: [:])
        
        if hitResults.count > 0 {
            let node = hitResults[0].node
            print(node.name)
            rampPlacerViewController.onRampSelected(node.name!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

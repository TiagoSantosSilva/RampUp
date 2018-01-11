//
//  ViewController.swift
//  RampUp
//
//  Created by Tiago Santos on 10/01/18.
//  Copyright © 2018 Tiago Santos. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RampPlacerViewController: UIViewController, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var controls: UIStackView!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    var selectedRampName: String?
    var selectedRamp: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/main.scn")!
        sceneView.autoenablesDefaultLighting = true
        
        // Set the scene to the view
        sceneView.scene = scene
        
        addGestureRecognizersToViewButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [.featurePoint])
        guard let hitFeature = results.last else { return }
        let hitTransformed = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransformed.m41, hitTransformed.m42, hitTransformed.m43)
        placeRamp(position: hitPosition)
    }
    
    func placeRamp(position: SCNVector3) {
        guard let rampName = selectedRampName else { return }
        controls.isHidden = false
        let ramp = Ramp.getRampForName(rampName: rampName)
        selectedRamp = ramp
        ramp.position = position
        ramp.scale = SCNVector3Make(0.01, 0.01, 0.01)
        sceneView.scene.rootNode.addChildNode(ramp)
    }
    
    fileprivate func addGestureRecognizersToViewButtons() {
        let gesture1 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        let gesture2 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        let gesture3 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        gesture1.minimumPressDuration = 0.1
        gesture1.minimumPressDuration = 0.2
        gesture1.minimumPressDuration = 0.3
        rotateButton.addGestureRecognizer(gesture1)
        upButton.addGestureRecognizer(gesture2)
        downButton.addGestureRecognizer(gesture3)
    }
    
    func onRampSelected(_ rampName: String) {
        selectedRampName = rampName
    }
    
    @objc func onLongPress(gesture: UILongPressGestureRecognizer) {
        guard let ramp = selectedRamp else { return }
        if gesture.state == .ended {
            ramp.removeAllActions()
        } else if gesture.state == .began {
            if gesture.view === rotateButton { // Double equals for type and value. Triple equals for reference check.
                let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08 * Double.pi), z: 0, duration: 0.1))
                ramp.runAction(rotate)
            } else if gesture.view === upButton {
                let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                ramp.runAction(move)
            } else if gesture.view === downButton {
                let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                ramp.runAction(move)
            }
        }
    }
    
    @IBAction func onRampButtonPressed(_ sender: UIButton) {
        let rampPickerViewController = RampPickerViewController(size: CGSize(width: 250, height: 500))
        rampPickerViewController.rampPlacerViewController = self
        rampPickerViewController.modalPresentationStyle = .popover
        rampPickerViewController.popoverPresentationController?.delegate = self
        present(rampPickerViewController, animated: true, completion: nil)
        rampPickerViewController.popoverPresentationController?.sourceView = sender
        rampPickerViewController.popoverPresentationController?.sourceRect = sender.bounds
    }
    
    @IBAction func onRemovePressed(_ sender: Any) {
        guard let ramp = selectedRamp else { return }
        ramp.removeFromParentNode()
        selectedRamp = nil
    }
}

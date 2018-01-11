//
//  Ramp.swift
//  RampUp
//
//  Created by Tiago Santos on 11/01/18.
//  Copyright © 2018 Tiago Santos. All rights reserved.
//

import Foundation
import ARKit

class Ramp {
    class func getRampForName(rampName: String) -> SCNNode {
        switch rampName {
        case "pipe":
            return getPipe()
        case "pyramid":
            return getPyramid()
        case "quarter":
            return getQuarter()
        default:
            return getPipe()
        }
    }
    
    class func getPipe() -> SCNNode {
        return getSceneObject(forSceneName: "art.scnassets/pipe.dae", nodeName: "pipe", withScaleX: 0.0022, withScaleY: 0.0022, withScaleZ: 0.0022, positionX: -1, positionY: 0.7, positionZ: -1)
    }
    
    class func getPyramid() -> SCNNode {
        return getSceneObject(forSceneName: "art.scnassets/pyramid.dae", nodeName: "pyramid", withScaleX: 0.0058, withScaleY: 0.0058, withScaleZ: 0.0058, positionX: -1, positionY: -0.65, positionZ: -1)
    }
    
    class func getQuarter() -> SCNNode {
        return getSceneObject(forSceneName: "art.scnassets/quarter.dae", nodeName: "quarter", withScaleX: 0.0058, withScaleY: 0.0058, withScaleZ: 0.0058, positionX: -1, positionY: -2.2, positionZ: -1)
    }
    
    class func getSceneObject(forSceneName sceneName: String, nodeName: String, withScaleX scaleX: Float, withScaleY scaleY: Float, withScaleZ scaleZ: Float, positionX: Float, positionY: Float, positionZ: Float) -> SCNNode {
        
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1))
        
        let object = SCNScene(named: sceneName)
        let objectNode = object?.rootNode.childNode(withName: nodeName, recursively: true)!
        objectNode?.runAction(rotate)
        objectNode?.scale = SCNVector3Make(scaleX, scaleY, scaleZ)
        objectNode?.position = SCNVector3Make(positionX, positionY, positionZ)
        return objectNode!
    }
}

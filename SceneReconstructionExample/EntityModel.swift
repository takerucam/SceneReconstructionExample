/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The model that holds app state and the logic for updating the scene and placing cubes.
*/

import ARKit
import RealityKit

/// A model type that holds app state and processes updates from ARKit.
@Observable
@MainActor
class EntityModel {
    let session = ARKitSession()
    let handTracking = HandTrackingProvider()
    let sceneReconstruction = SceneReconstructionProvider()

    var contentEntity = Entity()

    private var meshEntities = [UUID: ModelEntity]()
    
    private let fingerThumbTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerThumbTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerIndexTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerMiddleTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerRingTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerLittleTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    
    var errorState = false

    /// Sets up the root entity in the scene.
    func setupContentEntity() -> Entity {
        for entity in fingerThumbTipEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerIndexTipEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerMiddleTipEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerRingTipEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerLittleTipEntities.values {
            contentEntity.addChild(entity)
        }

        return contentEntity
    }
    
    var dataProvidersAreSupported: Bool {
        HandTrackingProvider.isSupported && SceneReconstructionProvider.isSupported
    }
    
    var isReadyToRun: Bool {
        handTracking.state == .initialized && sceneReconstruction.state == .initialized
    }
    
    /// Updates hand information from ARKit.
    func processHandUpdates() async {
        for await update in handTracking.anchorUpdates {
            let handAnchor = update.anchor

            guard
                handAnchor.isTracked,
                let thumbFingerTipJoint = handAnchor.handSkeleton?.joint(.thumbTip),
                let indexFingerTipJoint = handAnchor.handSkeleton?.joint(.indexFingerTip),
                let middleFingerTipJoint = handAnchor.handSkeleton?.joint(.middleFingerTip),
                let ringFingerTipJoint = handAnchor.handSkeleton?.joint(.ringFingerTip),
                let littleFingerTipJoint = handAnchor.handSkeleton?.joint(.littleFingerTip),
                thumbFingerTipJoint.isTracked,
                indexFingerTipJoint.isTracked,
                middleFingerTipJoint.isTracked,
                ringFingerTipJoint.isTracked,
                littleFingerTipJoint.isTracked
            else { continue }
            
            let originFromThumbFingerTip = handAnchor.originFromAnchorTransform * thumbFingerTipJoint.anchorFromJointTransform
            let originFromIndexFingerTip = handAnchor.originFromAnchorTransform * indexFingerTipJoint.anchorFromJointTransform
            let originFromMiddleFingerTip = handAnchor.originFromAnchorTransform * middleFingerTipJoint.anchorFromJointTransform
            let originFromRingFingerTip = handAnchor.originFromAnchorTransform * ringFingerTipJoint.anchorFromJointTransform
            let originFromLittleFingerTip = handAnchor.originFromAnchorTransform * littleFingerTipJoint.anchorFromJointTransform

            fingerThumbTipEntities[handAnchor.chirality]?.setTransformMatrix(originFromThumbFingerTip, relativeTo: nil)
            fingerIndexTipEntities[handAnchor.chirality]?.setTransformMatrix(originFromIndexFingerTip, relativeTo: nil)
            fingerMiddleTipEntities[handAnchor.chirality]?.setTransformMatrix(originFromMiddleFingerTip, relativeTo: nil)
            fingerRingTipEntities[handAnchor.chirality]?.setTransformMatrix(originFromRingFingerTip, relativeTo: nil)
            fingerLittleTipEntities[handAnchor.chirality]?.setTransformMatrix(originFromLittleFingerTip, relativeTo: nil)
        }
    }

    /// Updates the scene reconstruction meshes as new data arrives from ARKit.
    func processReconstructionUpdates() async {
        for await update in sceneReconstruction.anchorUpdates {
            let meshAnchor = update.anchor

            guard let shape = try? await ShapeResource.generateStaticMesh(from: meshAnchor) else { continue }
            switch update.event {
            case .added:
                let entity = try! await generateMeshEntity(geometry: meshAnchor.geometry)
                // entityの位置
                entity.transform = Transform(matrix: meshAnchor.originFromAnchorTransform)
                // entityの衝突検出をするための設定
                // shapeの形をした物体が他のentityと衝突しても動かない
                entity.collision = CollisionComponent(shapes: [shape], isStatic: true)
                //
                entity.components.set(InputTargetComponent())
                
                entity.physicsBody = PhysicsBodyComponent(mode: .static)
                
                meshEntities[meshAnchor.id] = entity
                contentEntity.addChild(entity)
            case .updated:
                guard let entity = meshEntities[meshAnchor.id] else { continue }
                entity.transform = Transform(matrix: meshAnchor.originFromAnchorTransform)
                entity.collision?.shapes = [shape]
            case .removed:
                meshEntities[meshAnchor.id]?.removeFromParent()
                meshEntities.removeValue(forKey: meshAnchor.id)
            }
        }
    }
    
    func generateMeshEntity(geometry: MeshAnchor.Geometry) async throws -> ModelEntity {
        // メッシュの生成
        var desc = MeshDescriptor()
        let posValues = geometry.vertices.asSIMD3(ofType: Float.self)
        desc.positions = .init(posValues)
        let normalValues = geometry.normals.asSIMD3(ofType: Float.self)
        desc.normals = .init(normalValues)
        
        do {
//            // .polygons以外にも.trianglesや.trianglesAndQuadsがある
//            desc.primitives = .polygons(
//                (0..<geometry.faces.count).map { _ in UInt8(3) },
//                (0..<geometry.faces.count * 3).map {
//                    geometry.faces.buffer.contents()
//                        .advanced(by: $0 * geometry.faces.bytesPerIndex)
//                        .assumingMemoryBound(to: UInt32.self).pointee
//                }
//            )
            desc.primitives = .triangles(
                (0..<geometry.faces.count * 3).map {
                    geometry.faces.buffer.contents()
                        .advanced(by: $0 * geometry.faces.bytesPerIndex)
                        .assumingMemoryBound(to: UInt32.self).pointee
                }
            )
        }
        let meshResource = try MeshResource.generate(from: [desc])
        let material = SimpleMaterial(color: .blue.withAlphaComponent(0.7), isMetallic: false)
        let modelEntity = ModelEntity(mesh: meshResource, materials: [material])
        return modelEntity
    }
    
    /// Responds to events like authorization revocation.
    func monitorSessionEvents() async {
        for await event in session.events {
            switch event {
            case .authorizationChanged(type: _, status: let status):
                logger.info("Authorization changed to: \(status)")
                
                if status == .denied {
                    errorState = true
                }
            case .dataProviderStateChanged(dataProviders: let providers, newState: let state, error: let error):
                logger.info("Data provider changed: \(providers), \(state)")
                if let error {
                    logger.error("Data provider reached an error state: \(error)")
                    errorState = true
                }
            @unknown default:
                fatalError("Unhandled new event type \(event)")
            }
        }
    }

    /// Drops a cube into the immersive space based on the location of a tap.
    ///
    /// Cubes participate in gravity and collisions, so they land on elements of the
    /// scene reconstruction mesh and people can interact with them.
    func addCube(tapLocation: SIMD3<Float>) {
        let placementLocation = tapLocation + SIMD3<Float>(0, 0.2, 0)

        let entity = ModelEntity(
            mesh: .generateBox(size: 0.1, cornerRadius: 0.0),
            materials: [SimpleMaterial(color: .systemPink, isMetallic: false)],
            collisionShape: .generateBox(size: SIMD3<Float>(repeating: 0.1)),
            mass: 1.0)

        entity.setPosition(placementLocation, relativeTo: nil)
        entity.components.set(InputTargetComponent(allowedInputTypes: .indirect))

        let material = PhysicsMaterialResource.generate(friction: 0.8, restitution: 0.0)
        entity.components.set(
            PhysicsBodyComponent(
                shapes: entity.collision!.shapes,
                mass: 1.0,
                material: material,
                mode: .dynamic)
        )

        contentEntity.addChild(entity)
    }
}

// Reference: https://github.com/XRealityZone/what-vision-os-can-do/blob/3a731b5645f1c509689637e66ee96693b2fa2da7/WhatVisionOSCanDo/Extension/GeometrySource.swift
extension GeometrySource {
    @MainActor func asArray<T>(ofType: T.Type) -> [T] {
        assert(MemoryLayout<T>.stride == stride, "Invalid stride \(MemoryLayout<T>.stride); expected \(stride)")
        return (0..<self.count).map {
            buffer.contents().advanced(by: offset + stride * Int($0)).assumingMemoryBound(to: T.self).pointee
        }
    }

    // SIMD3 has the same storage as SIMD4.
    @MainActor  func asSIMD3<T>(ofType: T.Type) -> [SIMD3<T>] {
        return asArray(ofType: (T, T, T).self).map { .init($0.0, $0.1, $0.2) }
    }
}

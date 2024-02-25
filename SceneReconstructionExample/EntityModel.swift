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

    /// Hand tracking entities.
    // Thumb
    private let fingerThumbTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerThumbIntermediateTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerThumbIntermediateBaseEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerThumbKnuckleEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    // Index
    private let fingerIndexTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerIndexIntermediateTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerIndexIntermediateBaseEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerIndexKnuckleEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerIndexMetacarpalEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    // Middle
    private let fingerMiddleTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerMiddleIntermediateTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerMiddleIntermediateBaseEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerMiddleKnuckleEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerMiddleMetacarpalEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    // Ring
    private let fingerRingTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerRingIntermediateTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerRingIntermediateBaseEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerRingKnuckleEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerRingMetacarpalEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    // Little
    private let fingerLittleTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerLittleIntermediateTipEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerLittleIntermediateBaseEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerLittleKnuckleEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerLittleMetacarpalEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    // Wrist
    private let fingerWristEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]
    private let fingerForearmWristEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFinger(),
        .right: .createFinger()
    ]

    var errorState = false

    /// Sets up the root entity in the scene.
    func setupContentEntity() -> Entity {
        // Thumb
        for entity in fingerThumbTipEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerThumbIntermediateTipEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerThumbIntermediateBaseEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerThumbKnuckleEntities.values {
            contentEntity.addChild(entity)
        }
        // Index
        for entity in fingerIndexTipEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerIndexIntermediateTipEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerIndexIntermediateBaseEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerIndexKnuckleEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerIndexMetacarpalEntities.values {
            contentEntity.addChild(entity)
        }
        // Middle
        for entity in fingerMiddleTipEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerMiddleIntermediateTipEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerMiddleIntermediateBaseEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerMiddleKnuckleEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerMiddleMetacarpalEntities.values {
            contentEntity.addChild(entity)
        }
        // Ring
        for entity in fingerRingTipEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerRingIntermediateTipEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerRingIntermediateBaseEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerRingKnuckleEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerRingMetacarpalEntities.values {
            contentEntity.addChild(entity)
        }
        // Little
        for entity in fingerLittleTipEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerLittleIntermediateTipEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerLittleIntermediateBaseEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerLittleKnuckleEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerLittleMetacarpalEntities.values {
            contentEntity.addChild(entity)
        }
        // Wrist
        for entity in fingerWristEntities.values {
            contentEntity.addChild(entity)
        }
        for entity in fingerForearmWristEntities.values {
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
                // Thumb
                let thumbFingerTipJoint = handAnchor.handSkeleton?.joint(.thumbTip),
                let thumbFingerIntermediateTipJoint = handAnchor.handSkeleton?.joint(.thumbIntermediateTip),
                let thumbFingerIntermediateBaseJoint = handAnchor.handSkeleton?.joint(.thumbIntermediateBase),
                let thumbFingerKnuckleJoint = handAnchor.handSkeleton?.joint(.thumbKnuckle),
                // Index
                let indexFingerTipJoint = handAnchor.handSkeleton?.joint(.indexFingerTip),
                let indexFingerIntermediateTipJoint = handAnchor.handSkeleton?.joint(.indexFingerIntermediateTip),
                let indexFingerIntermediateBaseJoint = handAnchor.handSkeleton?.joint(.indexFingerIntermediateBase),
                let indexFingerKnuckleJoint = handAnchor.handSkeleton?.joint(.indexFingerKnuckle),
                let indexFingerMetacarpalJoint = handAnchor.handSkeleton?.joint(.indexFingerMetacarpal),
                // Middle
                let middleFingerTipJoint = handAnchor.handSkeleton?.joint(.middleFingerTip),
                let middleFingerIntermediateTipJoint = handAnchor.handSkeleton?.joint(.middleFingerIntermediateTip),
                let middleFingerIntermediateBaseJoint = handAnchor.handSkeleton?.joint(.middleFingerIntermediateBase),
                let middleFingerKnuckleJoint = handAnchor.handSkeleton?.joint(.middleFingerKnuckle),
                let middleFingerMetacarpalJoint = handAnchor.handSkeleton?.joint(.middleFingerMetacarpal),
                // Ring
                let ringFingerTipJoint = handAnchor.handSkeleton?.joint(.ringFingerTip),
                let ringFingerIntermediateTipJoint = handAnchor.handSkeleton?.joint(.ringFingerIntermediateTip),
                let ringFingerIntermediateBaseJoint = handAnchor.handSkeleton?.joint(.ringFingerIntermediateBase),
                let ringFingerKnuckleJoint = handAnchor.handSkeleton?.joint(.ringFingerKnuckle),
                let ringFingerMetacarpalJoint = handAnchor.handSkeleton?.joint(.ringFingerMetacarpal),
                // Little
                let littleFingerTipJoint = handAnchor.handSkeleton?.joint(.littleFingerTip),
                let littleFingerIntermediateTipJoint = handAnchor.handSkeleton?.joint(.littleFingerIntermediateTip),
                let littleFingerIntermediateBaseJoint = handAnchor.handSkeleton?.joint(.littleFingerIntermediateBase),
                let littleFingerKnuckleJoint = handAnchor.handSkeleton?.joint(.littleFingerKnuckle),
                let littleFingerMetacarpalJoint = handAnchor.handSkeleton?.joint(.littleFingerMetacarpal),
                // Wrist
                let wristJoint = handAnchor.handSkeleton?.joint(.wrist),
                let forearmWristJoint = handAnchor.handSkeleton?.joint(.forearmWrist),
                /// isTacked
                thumbFingerTipJoint.isTracked,
                thumbFingerIntermediateTipJoint.isTracked,
                thumbFingerIntermediateBaseJoint.isTracked,
                thumbFingerKnuckleJoint.isTracked,
                thumbFingerTipJoint.isTracked,
                indexFingerTipJoint.isTracked,
                indexFingerIntermediateTipJoint.isTracked,
                indexFingerIntermediateBaseJoint.isTracked,
                indexFingerKnuckleJoint.isTracked,
                indexFingerMetacarpalJoint.isTracked,
                middleFingerTipJoint.isTracked,
                middleFingerIntermediateTipJoint.isTracked,
                middleFingerIntermediateBaseJoint.isTracked,
                middleFingerKnuckleJoint.isTracked,
                middleFingerMetacarpalJoint.isTracked,
                ringFingerTipJoint.isTracked,
                ringFingerIntermediateTipJoint.isTracked,
                ringFingerIntermediateBaseJoint.isTracked,
                ringFingerKnuckleJoint.isTracked,
                ringFingerMetacarpalJoint.isTracked,
                littleFingerTipJoint.isTracked,
                littleFingerIntermediateTipJoint.isTracked,
                littleFingerIntermediateBaseJoint.isTracked,
                littleFingerKnuckleJoint.isTracked,
                littleFingerMetacarpalJoint.isTracked,
                wristJoint.isTracked,
                forearmWristJoint.isTracked
            else { continue }
            // Thumb
            let originFromThumbFingerTip = handAnchor.originFromAnchorTransform * thumbFingerTipJoint.anchorFromJointTransform
            let originFromThumbFingerIntermediateTip = handAnchor.originFromAnchorTransform * thumbFingerIntermediateTipJoint.anchorFromJointTransform
            let originFromThumbFingerIntermediateBase = handAnchor.originFromAnchorTransform * thumbFingerIntermediateBaseJoint.anchorFromJointTransform
            let originFromThumbFingerKnuckle = handAnchor.originFromAnchorTransform * thumbFingerKnuckleJoint.anchorFromJointTransform
            // Index
            let originFromIndexFingerTip = handAnchor.originFromAnchorTransform * indexFingerTipJoint.anchorFromJointTransform
            let originFromIndexFingerIntermediateTip = handAnchor.originFromAnchorTransform * indexFingerIntermediateTipJoint.anchorFromJointTransform
            let originFromIndexFingerIntermediateBase = handAnchor.originFromAnchorTransform * indexFingerIntermediateBaseJoint.anchorFromJointTransform
            let originFromIndexFingerKnuckle = handAnchor.originFromAnchorTransform * indexFingerKnuckleJoint.anchorFromJointTransform
            let originFromIndexFingerMetacarpal = handAnchor.originFromAnchorTransform * indexFingerMetacarpalJoint.anchorFromJointTransform
            // Middle
            let originFromMiddleFingerTip = handAnchor.originFromAnchorTransform * middleFingerTipJoint.anchorFromJointTransform
            let originFromMiddleFingerIntermediateTip = handAnchor.originFromAnchorTransform * middleFingerIntermediateTipJoint.anchorFromJointTransform
            let originFromMiddleFingerIntermediateBase = handAnchor.originFromAnchorTransform * middleFingerIntermediateBaseJoint.anchorFromJointTransform
            let originFromMiddleFingerKnuckle = handAnchor.originFromAnchorTransform * middleFingerKnuckleJoint.anchorFromJointTransform
            let originFromMiddleFingerMetacarpal = handAnchor.originFromAnchorTransform * middleFingerMetacarpalJoint.anchorFromJointTransform
            // Ring
            let originFromRingFingerTip = handAnchor.originFromAnchorTransform * ringFingerTipJoint.anchorFromJointTransform
            let originFromRingFingerIntermediateTip = handAnchor.originFromAnchorTransform * ringFingerIntermediateTipJoint.anchorFromJointTransform
            let originFromRingFingerIntermediateBase = handAnchor.originFromAnchorTransform * ringFingerIntermediateBaseJoint.anchorFromJointTransform
            let originFromRingFingerKnuckle = handAnchor.originFromAnchorTransform * ringFingerKnuckleJoint.anchorFromJointTransform
            let originFromRingFingerMetacarpal = handAnchor.originFromAnchorTransform * ringFingerMetacarpalJoint.anchorFromJointTransform
            // Little
            let originFromLittleFingerTip = handAnchor.originFromAnchorTransform * littleFingerTipJoint.anchorFromJointTransform
            let originFromLittleFingerIntermediateTip = handAnchor.originFromAnchorTransform * littleFingerIntermediateTipJoint.anchorFromJointTransform
            let originFromLittleFingerIntermediateBase = handAnchor.originFromAnchorTransform * littleFingerIntermediateBaseJoint.anchorFromJointTransform
            let originFromLittleFingerKnuckle = handAnchor.originFromAnchorTransform * littleFingerKnuckleJoint.anchorFromJointTransform
            let originFromLittleFingerMetacarpal = handAnchor.originFromAnchorTransform * littleFingerMetacarpalJoint.anchorFromJointTransform
            // Wrist
            let originFromWrist = handAnchor.originFromAnchorTransform * wristJoint.anchorFromJointTransform
            let originFromForearmWrist = handAnchor.originFromAnchorTransform * forearmWristJoint.anchorFromJointTransform

            // Thumb
            fingerThumbTipEntities[handAnchor.chirality]?.setTransformMatrix(originFromThumbFingerTip, relativeTo: nil)
            fingerThumbIntermediateTipEntities[handAnchor.chirality]?.setTransformMatrix(originFromThumbFingerIntermediateTip, relativeTo: nil)
            fingerThumbIntermediateBaseEntities[handAnchor.chirality]?.setTransformMatrix(originFromThumbFingerIntermediateBase, relativeTo: nil)
            fingerThumbKnuckleEntities[handAnchor.chirality]?.setTransformMatrix(originFromThumbFingerKnuckle, relativeTo: nil)

            // Index
            fingerIndexTipEntities[handAnchor.chirality]?.setTransformMatrix(originFromIndexFingerTip, relativeTo: nil)
            fingerIndexIntermediateTipEntities[handAnchor.chirality]?.setTransformMatrix(originFromIndexFingerIntermediateTip, relativeTo: nil)
            fingerIndexIntermediateBaseEntities[handAnchor.chirality]?.setTransformMatrix(originFromIndexFingerIntermediateBase, relativeTo: nil)
            fingerIndexKnuckleEntities[handAnchor.chirality]?.setTransformMatrix(originFromIndexFingerKnuckle, relativeTo: nil)
            fingerIndexMetacarpalEntities[handAnchor.chirality]?.setTransformMatrix(originFromIndexFingerMetacarpal, relativeTo: nil)
            // Middle
            fingerMiddleTipEntities[handAnchor.chirality]?.setTransformMatrix(originFromMiddleFingerTip, relativeTo: nil)
            fingerMiddleIntermediateTipEntities[handAnchor.chirality]?.setTransformMatrix(originFromMiddleFingerIntermediateTip, relativeTo: nil)
            fingerMiddleIntermediateBaseEntities[handAnchor.chirality]?.setTransformMatrix(originFromMiddleFingerIntermediateBase, relativeTo: nil)
            fingerMiddleKnuckleEntities[handAnchor.chirality]?.setTransformMatrix(originFromMiddleFingerKnuckle, relativeTo: nil)
            fingerMiddleMetacarpalEntities[handAnchor.chirality]?.setTransformMatrix(originFromMiddleFingerMetacarpal, relativeTo: nil)
            // Ring
            fingerRingTipEntities[handAnchor.chirality]?.setTransformMatrix(originFromRingFingerTip, relativeTo: nil)
            fingerRingIntermediateTipEntities[handAnchor.chirality]?.setTransformMatrix(originFromRingFingerIntermediateTip, relativeTo: nil)
            fingerRingIntermediateBaseEntities[handAnchor.chirality]?.setTransformMatrix(originFromRingFingerIntermediateBase, relativeTo: nil)
            fingerRingKnuckleEntities[handAnchor.chirality]?.setTransformMatrix(originFromRingFingerKnuckle, relativeTo: nil)
            fingerRingMetacarpalEntities[handAnchor.chirality]?.setTransformMatrix(originFromRingFingerMetacarpal, relativeTo: nil)
            // Little
            fingerLittleTipEntities[handAnchor.chirality]?.setTransformMatrix(originFromLittleFingerTip, relativeTo: nil)
            fingerLittleIntermediateTipEntities[handAnchor.chirality]?.setTransformMatrix(originFromLittleFingerIntermediateTip, relativeTo: nil)
            fingerLittleIntermediateBaseEntities[handAnchor.chirality]?.setTransformMatrix(originFromLittleFingerIntermediateBase, relativeTo: nil)
            fingerLittleKnuckleEntities[handAnchor.chirality]?.setTransformMatrix(originFromLittleFingerKnuckle, relativeTo: nil)
            fingerLittleMetacarpalEntities[handAnchor.chirality]?.setTransformMatrix(originFromLittleFingerMetacarpal, relativeTo: nil)
            // Wrist
            fingerWristEntities[handAnchor.chirality]?.setTransformMatrix(originFromWrist, relativeTo: nil)
            fingerForearmWristEntities[handAnchor.chirality]?.setTransformMatrix(originFromForearmWrist, relativeTo: nil)
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
        var material = SimpleMaterial(color: .blue, isMetallic: false)
        material.triangleFillMode = .lines
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

/*
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import FirebaseFirestore
import Foundation
import Combine

@available(iOS 15, tvOS 13, macOS 10.15, macCatalyst 13, watchOS 7, *)
class VectorIntegrationTests: FSTIntegrationTestCase {
    func testWriteAndReadVectorEmbeddings() async throws {
        let collection = collectionRef()
        
        let ref = try await collection.addDocument(data: [
            "vector0": FieldValue.vector([0.0]),
            "vector1": FieldValue.vector([1, 2, 3.99])])
        
        try await ref.setData([
                "vector0": FieldValue.vector([0.0]),
                "vector1": FieldValue.vector([1, 2, 3.99]),
                "vector2": FieldValue.vector([0, 0, 0] as Array<Double>)])
        
        try await ref.updateData([
            "vector3": FieldValue.vector([-1, -200, -999] as Array<Double>)])
        
        let snapshot = try await ref.getDocument();
        XCTAssertEqual(snapshot.get("vector0") as? VectorValue, FieldValue.vector([0.0]))
        XCTAssertEqual(snapshot.get("vector1") as? VectorValue, FieldValue.vector([1, 2, 3.99]))
        XCTAssertEqual(snapshot.get("vector2") as? VectorValue, FieldValue.vector([0, 0, 0] as Array<Double>))
        XCTAssertEqual(snapshot.get("vector3") as? VectorValue, FieldValue.vector([-1, -200, -999] as Array<Double>))
    }
    
    func testSdkOrdersVectorFieldSameWayAsBackend() async throws {
        let collection = collectionRef()
        
        var docsInOrder: [[String:Any]] = [
            ["embedding": [1, 2, 3, 4, 5, 6]],
            ["embedding": [100] ],
            ["embedding": FieldValue.vector([Double.infinity * -1]) ],
            ["embedding": FieldValue.vector([-100.0]) ],
            ["embedding": FieldValue.vector([100.0]) ],
            ["embedding": FieldValue.vector([Double.infinity]) ],
            ["embedding": FieldValue.vector([1, 2.0]) ],
            ["embedding": FieldValue.vector([2, 2.0]) ],
            ["embedding": FieldValue.vector([1, 2, 3.0]) ],
            ["embedding": FieldValue.vector([1, 2, 3, 4.0]) ],
            ["embedding": FieldValue.vector([1, 2, 3, 4, 5.0]) ],
            ["embedding": FieldValue.vector([1, 2, 100, 4, 4.0]) ],
            ["embedding": FieldValue.vector([100, 2, 3, 4, 5.0]) ],
            ["embedding": [ "HELLO": "WORLD" ] ],
            ["embedding": [ "hello": "world" ] ]
        ]
        
        var docs: [[String:Any]] = [];
        for data in docsInOrder {
            let docRef = try await collection.addDocument(data: data)
            docs.append(["id": docRef.documentID, "value": data])
        }
        
        // We validate that the SDK orders the vector field the same way as the backend
               // by comparing the sort order of vector fields from getDocsFromServer and
               // onSnapshot. onSnapshot will return sort order of the SDK,
               // and getDocsFromServer will return sort order of the backend.

        let orderedQuery = collection.order(by: "embedding")
        
        
        let watchSnapshot = try await Future<QuerySnapshot, Error>() { promise in
            orderedQuery.addSnapshotListener { snapshot, error in
                if let error {
                    promise(Result.failure(error))
                }
                if let snapshot {
                    promise(Result.success(snapshot))
                }
            }
        }.value
        
        let getSnapshot = try await orderedQuery.getDocuments(source: .server)
        
        // Compare the snapshot (including sort order) of a snapshot
        // from Query.onSnapshot() to an actual snapshot from Query.get()
        XCTAssertEqual(watchSnapshot.count, getSnapshot.count)
        for i in (0..<min(watchSnapshot.count, getSnapshot.count)) {
            XCTAssertEqual(watchSnapshot.documents[i].documentID, getSnapshot.documents[i].documentID)
        }
        
        // Compare the snapshot (including sort order) of a snapshot
        // from Query.onSnapshot() to the expected sort order from
        // the backend.
        XCTAssertEqual(watchSnapshot.count, docs.count)
        for i in (0..<min(watchSnapshot.count, docs.count)) {
            XCTAssertEqual(watchSnapshot.documents[i].documentID, docs[i]["id"] as! String)
        }
    }
    
    func testSdkOrdersVectorFieldSameWayOnlineAndOffline() async throws {
        let collection = collectionRef()
        
        let docsInOrder: [[String:Any]] = [
            ["embedding": [1, 2, 3, 4, 5, 6]],
            ["embedding": [100] ],
            ["embedding": FieldValue.vector([Double.infinity * -1]) ],
            ["embedding": FieldValue.vector([-100.0]) ],
            ["embedding": FieldValue.vector([100.0]) ],
            ["embedding": FieldValue.vector([Double.infinity]) ],
            ["embedding": FieldValue.vector([1, 2.0]) ],
            ["embedding": FieldValue.vector([2, 2.0]) ],
            ["embedding": FieldValue.vector([1, 2, 3.0]) ],
            ["embedding": FieldValue.vector([1, 2, 3, 4.0]) ],
            ["embedding": FieldValue.vector([1, 2, 3, 4, 5.0]) ],
            ["embedding": FieldValue.vector([1, 2, 100, 4, 4.0]) ],
            ["embedding": FieldValue.vector([100, 2, 3, 4, 5.0]) ],
            ["embedding": [ "HELLO": "WORLD" ] ],
            ["embedding": [ "hello": "world" ] ]
        ]
        
        var docIds: [String] = [];
        for data in docsInOrder {
            let docRef = try await collection.addDocument(data: data)
            docIds.append(docRef.documentID)
        }
        
        checkOnlineAndOfflineQuery(collection.order(by: "embedding"), matchesResult: docIds)
        checkOnlineAndOfflineQuery(collection.order(by: "embedding").whereField("embedding", isLessThan: FieldValue.vector([1, 2, 100, 4, 4.0])), matchesResult: Array(docIds[2...10]))
        checkOnlineAndOfflineQuery(collection.order(by: "embedding").whereField("embedding", isGreaterThan: FieldValue.vector([1, 2, 100, 4, 4.0])), matchesResult: Array(docIds[12...12]))
    }
    
    
      
    func testQueryVectorValueWrittenByCodable() async throws {
        let collection = collectionRef()
        
        struct Model: Codable {
            var name: String
            var embedding: VectorValue
        }
        let model = Model(
            name: "name",
            embedding: FieldValue.vector([0.1, 0.3, 0.4])
        )
        
        try collection.document().setData(from: model)
        
        let querySnap = try await collection.whereField("embedding", isEqualTo: FieldValue.vector([0.1, 0.3, 0.4])).getDocuments()
        
        XCTAssertEqual(1, querySnap.count)
        XCTAssertEqual(try querySnap.documents[0].data(as: Model.self).embedding, VectorValue([0.1, 0.3, 0.4]))
    }
}

// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

import FirebaseAppCheckInterop
import FirebaseCore

// Exports the GoogleGenerativeAI module to users of the SDK.
@_exported import GoogleGenerativeAI

// Avoids exposing internal FirebaseCore APIs to Swift users.
@_implementationOnly import FirebaseCoreExtension

@available(iOS 15.0, macOS 11.0, macCatalyst 15.0, *)
@objc(FIRVertexAI)
open class VertexAI: NSObject {
  // MARK: - Public APIs

  /// Returns an instance of `GoogleGenerativeAI.GenerativeModel` that uses the Vertex AI API.
  ///
  /// This instance is configured with the default `FirebaseApp`.
  public static func generativeModel(modelName: String, location: String) -> GoogleGenerativeAI
    .GenerativeModel {
    return generativeModel(app: FirebaseApp.app()!, modelName: modelName, location: location)
  }

  /// Returns an instance of `GoogleGenerativeAI.GenerativeModel` that uses the Vertex AI API.
  public static func generativeModel(app: FirebaseApp, modelName: String,
                                     location: String) -> GoogleGenerativeAI.GenerativeModel {
    let provider = ComponentType<VertexAIProvider>.instance(for: VertexAIProvider.self,
                                                            in: app.container)
    let modelResourceName = modelResourceName(app: app, modelName: modelName, location: location)
    return provider.vertexAI(location: location, modelResourceName: modelResourceName).model
  }

  // MARK: - Private

  /// The `FirebaseApp` associated with this `VertexAI` instance.
  private let app: FirebaseApp

  private let appCheck: AppCheckInterop?

  private let location: String

  private let modelResouceName: String

  lazy var model: GenerativeModel = {
    let options = RequestOptions(
      apiVersion: "v2beta",
      endpoint: "staging-firebaseml.sandbox.googleapis.com",
      hooks: [addAppCheckHeader]
    )
    return GenerativeModel(
      name: modelResouceName,
      apiKey: app.options.apiKey!,
      requestOptions: options
    )
  }()

  init(app: FirebaseApp, location: String, modelResourceName: String) {
    self.app = app
    appCheck = ComponentType<AppCheckInterop>.instance(for: AppCheckInterop.self, in: app.container)
    self.location = location
    modelResouceName = modelResourceName
  }

  private static func modelResourceName(app: FirebaseApp, modelName: String,
                                        location: String) -> String {
    if modelName.contains("/") {
      return modelName
    }
    guard let projectID = app.options.projectID else {
      print("The FirebaseApp is missing a project ID.")
      return modelName
    }

    return "projects/\(projectID)/locations/\(location)/publishers/google/models/\(modelName)"
  }

  // MARK: Request Hooks

  /// Adds an App Check token to the provided request, if App Check is included in the app.
  ///
  /// This demonstrates how an App Check token can be added to requests; it is currently ignored by
  /// the backend.
  ///
  /// - Parameter request: The `URLRequest` to modify by adding an App Check token header.
  func addAppCheckHeader(request: inout URLRequest) async {
    guard let appCheck = appCheck else {
      return
    }

    let tokenResult = await appCheck.getToken(forcingRefresh: false)
    request.addValue(tokenResult.token, forHTTPHeaderField: "X-Firebase-AppCheck")
  }
}
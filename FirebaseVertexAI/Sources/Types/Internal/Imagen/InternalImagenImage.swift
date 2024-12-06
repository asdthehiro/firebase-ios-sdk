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

@available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *)
struct InternalImagenImage {
  let mimeType: String
  let bytesBase64Encoded: String?
  let gcsURI: String?

  init(mimeType: String, bytesBase64Encoded: String?, gcsURI: String?) {
    self.mimeType = mimeType
    self.bytesBase64Encoded = bytesBase64Encoded
    self.gcsURI = gcsURI
  }
}

@available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *)
extension InternalImagenImage: DecodableImagenImage {}

@available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, *)
extension InternalImagenImage: Equatable {}

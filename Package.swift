// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Copyright 2019 The TensorFlow Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import PackageDescription
import Foundation
import Darwin.C

// ProcessInfo.processInfo.environment["DYLD_LIBRARY_PATH"] = "/Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2020-12-20-a.xctoolchain/usr/lib/swift/macosx"

setenv("DYLD_LIBRARY_PATH", "/Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2020-12-20-a.xctoolchain/usr/lib/swift/macosx", 1)

let package = Package(
  name: "TensorFlow",
  platforms: [
    .macOS(.v10_13)
  ],
  products: [
    .library(
      name: "_Differentiation",
      type: .dynamic,
      // type: .static,
      targets: ["swift_Differentiation"]),
    .library(
      name: "TensorFlow",
      type: .dynamic,
      targets: ["TensorFlow"]),
    .library(
      name: "Tensor",
      type: .dynamic,
      targets: ["Tensor"]),
  ],
  dependencies: [
    // .package(url: "https://github.com/apple/swift-numerics", .branch("main")),
    .package(url: "https://github.com/pvieito/PythonKit.git", .branch("master")),
  ],
  targets: [
    .target(
      name: "swift_Differentiation",
      dependencies: [],
      path: "Sources/_Differentiation",
      swiftSettings: [
        .unsafeFlags(["-parse-stdlib"]),
        .unsafeFlags(["-module-name", "_Differentiation"]),
        // .unsafeFlags(["-module-link-name", "swift_Differentiation"]),
      ]),
    .target(
      name: "Tensor",
      dependencies: []),
    .target(
      name: "CTensorFlow",
      dependencies: []),
    .target(
      name: "TensorFlow",
      dependencies: [
        "swift_Differentiation",
        "Tensor",
        "PythonKit",
        "CTensorFlow",
        // .product(name: "Numerics", package: "swift-numerics"),
      ]),
    .target(
      name: "Experimental",
      dependencies: ["swift_Differentiation"],
      path: "Sources/third_party/Experimental"),
    .testTarget(
      name: "ExperimentalTests",
      dependencies: ["swift_Differentiation", "Experimental"]),
    .testTarget(
      name: "TensorTests",
      dependencies: ["swift_Differentiation", "Tensor"]),
    .testTarget(
      name: "TensorFlowTests",
      dependencies: ["TensorFlow", "swift_Differentiation"]),
  ]
)

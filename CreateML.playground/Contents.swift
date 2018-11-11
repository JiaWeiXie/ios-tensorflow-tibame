import CreateMLUI
import CreateML
import Foundation

/// Pets ML Image Classifier

/// Create Model from UI

//let builder = MLImageClassifierBuilder()
//
//builder.showInLiveView()


/// Create Model from code

let path = "/Users/xiejiawei/Documents/Python Codes/tensorflow/MLDataSet"
let trainingDir = URL(fileURLWithPath: "\(path)/Pets-100")
let testingDir = URL(fileURLWithPath: "\(path)/Pets-Testing")

var parameters = MLImageClassifier.ModelParameters()
parameters.maxIterations = 20

let model = try MLImageClassifier(trainingData: .labeledDirectories(at: trainingDir))
let evaluation = model.evaluation(on: .labeledDirectories(at: testingDir))
let metaData = MLModelMetadata(
    author: "Jason",
    shortDescription: "Pets",
    license: nil,
    version: "1.0",
    additional: nil)

let outputFileDir = URL(fileURLWithPath: "\(path)/PetClassifierV1")

try model.write(to: outputFileDir, metadata: metaData)

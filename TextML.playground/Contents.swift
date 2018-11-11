import CreateML
import Foundation


let path = "/Users/xiejiawei/Documents/PythonCodes/tensorflow/MLDataSet"

let fileURL = URL(fileURLWithPath: "\(path)/spam.json")

let data = try MLDataTable(contentsOf: fileURL)

let (trainingData, testingData) = data.randomSplit(by: 0.8)
let classifier = try MLTextClassifier(
    trainingData: trainingData,
    textColumn: "text",
    labelColumn: "label")

let evaluation = classifier.evaluation(on: testingData)

let trainingAccuracy = (1.0 - classifier.trainingMetrics.classificationError) * 100

let validationAccuracy = (1.0 - classifier.validationMetrics.classificationError) * 100

let evaluationAccuracy = (1.0 - evaluation.classificationError) * 100



let metaData = MLModelMetadata(
    author: "Jason",
    shortDescription: "SpamDetect",
    license: nil,
    version: "1.0",
    additional: nil)
let outputFileDir = URL(fileURLWithPath: "\(path)/SpamDetectV1")

try classifier.write(to: outputFileDir, metadata: metaData)

import CreateML
import Foundation


let path = "/Users/xiejiawei/Documents/PythonCodes/tensorflow/MLDataSet"

let fileURL = URL(fileURLWithPath: "\(path)/HouseData.csv")

let data = try MLDataTable(contentsOf: fileURL)
print("Data size: \(data.size)")

let (trainingData, testingData) = data.randomSplit(by: 0.8)
let pricer = try MLRegressor(trainingData: trainingData, targetColumn: "MEDV")

let metaData = MLModelMetadata(
    author: "Jason",
    shortDescription: "SpamDetect",
    license: nil,
    version: "1.0",
    additional: nil)
let outputFileDir = URL(fileURLWithPath: "\(path)/SpamDetectV1")

try pricer.write(to: outputFileDir, metadata: metaData)

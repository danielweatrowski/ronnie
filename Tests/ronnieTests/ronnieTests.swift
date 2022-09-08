import XCTest
import class Foundation.Bundle
import TabularData

@testable import ronnie

final class ronnieTests: XCTestCase {
    
    private var fruitManager: FruitManager!
    
    private let fruitsDataframe: DataFrame = [
        "fruit":["apple","banana","orange"],
        "color":["red","yellow","orange"],
        "cost":[1.0,0.6,0.4]
    ]
    
    private let veggiesDataframe: DataFrame = [
        "fruit":["pepper","broccoli","carrot"],
        "color":["red","green","orange"],
        "cost":[1.0,0.6,0.4]
    ]
    
    override func setUp() {
        super.setUp()
        
        let directoryURL = URL(fileURLWithPath: "/Users/danielweatrowski/Developer/ronnie/Tests/ronnieTests")
        let filename = "fruits.csv"
        fruitManager = FruitManager(directoryURL: directoryURL, filename: filename)
    }

    
    func testLoader() {
        // given
        XCTAssert(fruitManager.dataframe.isEmpty)
        
        // when
        fruitManager.loadDataframe()
        let loadedDataframe = fruitManager.getDataframe()
        
        // then
        XCTAssertFalse(fruitManager.dataframe.isEmpty)
        XCTAssertEqual(loadedDataframe, fruitsDataframe)
    }
    
    func testGenerator() {
        // given
        let filename = "vegtables.csv"
        let fileURL = fruitManager.directoryURL.appendingPathComponent(filename)
        let path = fileURL.path
        
        // when
        let fileManager = FileManager.default
        XCTAssertFalse(fileManager.fileExists(atPath: path))
        
        // then
        fruitManager.save(veggiesDataframe, to: fileURL)
        XCTAssert(fileManager.fileExists(atPath: path))
        
        try! fileManager.removeItem(atPath: path)
    }
}

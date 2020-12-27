import QuartzCore
import PathMath

struct RegularPolygonDescription {
    typealias FloatValue = CGFloat
    let circumradius: FloatValue
    let n: Int

    init?(n: Int, radius: FloatValue = 1) {
        guard n > 2 else { return nil }
        self.n = n
        circumradius = radius
    }
}

extension RegularPolygonDescription: CustomStringConvertible {
    var description: String {
        let name: String

        switch n {
        case Int.min ..< 3:
            fatalError("polygon with \(n) sides is invalid")
        //        case 1:
        //            name = "Regular monogon"
        //        case 2:
        //            name = "Regular digon"
        case 3:
            name = "Regular triangle"
        case 4:
            name = "Square"
        case 5:
            name = "Regular pentagon"
        case 6:
            name = "Regular hexagon"
        case 7:
            name = "Regular septagon"
        case 8:
            name = "Regular octagon"
        case 9:
            name = "Regular nonagon"
        case 10:
            name = "Regular decagon"
        case 11:
            name = "Regular hendecagon"
        case 12:
            name = "Regular dodecagon"
        case 13:
            name = "Regular tridecagon"
        case 14:
            name = "Regular tetradecagon"
        case 15:
            name = "Regular pentadecagon"
        case 16:
            name = "Regular hexadecagon"
        case let value:
            name = "Regular \(value)-gon"
        }

        return "\(name): r = \(circumradius)"
    }
}

extension RegularPolygonDescription {
    var incentralSliceAngle: FloatValue {
        /* TODO: use `exactly` 2017-06-02 */
        360 / FloatValue(n)
    }

    var something: FloatValue {
        (180 - incentralSliceAngle) / 2
    }

    //    var apothem: FloatValue {
    //        cen
    //    }
}

let triangle = RegularPolygonDescription(n: 3)!
triangle.incentralSliceAngle == 120

// MARK: - Isosceles Triangles

public struct IsoscelesTriangleDescription {
    public typealias FloatValue = CGFloat

    public let legLength: FloatValue
    public let baseLength: FloatValue
    public let axisOfSymmetryLength: FloatValue

    public let vertexAngle: FloatValue
    public let baseAngle: FloatValue

    private init(legLength: FloatValue,
                 baseLength: FloatValue,
                 axisOfSymmetryLength: FloatValue,
                 vertexAngle: FloatValue,
                 baseAngle: FloatValue) {
        self.legLength = legLength
        self.baseLength = baseLength
        self.axisOfSymmetryLength = axisOfSymmetryLength
        self.vertexAngle = vertexAngle
        self.baseAngle = baseAngle
    }
}

extension IsoscelesTriangleDescription {
    public init(vertexAngle: FloatValue, legLenth: FloatValue) {
        guard vertexAngle > 0,
              vertexAngle < 180 else {
            fatalError("invalid vertex angle")
        }
        let halfVertex: Angle = .degrees(vertexAngle * 0.5)

        self.vertexAngle = vertexAngle
        baseAngle = (180 - vertexAngle) / 2
        legLength = legLenth
        baseLength = sin(halfVertex.inRadians) * legLenth * 2
        axisOfSymmetryLength = cos(halfVertex.inRadians) * legLenth * 2
    }

    public init(baseAngle: FloatValue, legLenth: FloatValue) {
        guard baseAngle > 0,
              baseAngle < 90 else {
            fatalError("invalid base angle")
        }

        let vertex = 180 - (baseAngle * 2)
        let halfVertex: Angle = .degrees(vertex * 0.5)

        self.baseAngle = baseAngle
        vertexAngle = vertex
        legLength = legLenth
        baseLength = sin(halfVertex.inRadians) * legLenth * 2
        axisOfSymmetryLength = cos(halfVertex.inRadians) * legLenth * 2
    }

    public init?(baseLength: FloatValue, legLength: FloatValue) {
        guard legLength > 0,
              baseLength > 0,
              legLength * 2 < baseLength else {
            return nil
        }

        let halfBase = baseLength / 2
        let axisLength = sqrt(pow(legLength, 2) - pow(halfBase, 2))
        let vertex = asin(halfBase / axisLength) * 2

        self.baseLength = baseLength
        self.legLength = legLength
        baseAngle = (180 - vertex) / 2
        vertexAngle = vertex
        axisOfSymmetryLength = axisLength
    }
}

let isoTri = IsoscelesTriangleDescription(vertexAngle: 90, legLenth: 1)
isoTri.baseLength
isoTri.baseAngle
sqrt(2)

let equTri = IsoscelesTriangleDescription(baseAngle: 60, legLenth: 1)
equTri.legLength
equTri.vertexAngle

let oneOneRootTwo = RightTriangle(lengthA: 1,
                                  lengthB: 1)
oneOneRootTwo.angleA.inDegrees

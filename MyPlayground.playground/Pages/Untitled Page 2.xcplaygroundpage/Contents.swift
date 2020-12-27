import UIKit
import PlaygroundSupport
import PathMath

protocol Match3GridViewDelegate: AnyObject {
    func cellForItemAt(_ coordinate: CGRect2DGrid.CoordinatePair) -> UIView
}

class RandomCellProvider: Match3GridViewDelegate {
    func cellForItemAt(_ coordinate: CGRect2DGrid.CoordinatePair) -> UIView {
        let cell = UIView()
        let color: UIColor

        switch Int(arc4random_uniform(5)) {
        case 0:
            color = .red
        case 1:
            color = .orange
        case 2:
            color = .yellow
        case 3:
            color = .blue
        default:
            color = .cyan
        }

        cell.backgroundColor = color
        return cell
    }
}

class Match3GridView: UIView {
    var queues: [String: (class: UIView.Type, [UIView])]
    let grid: CGRect2DGrid
    weak var delegate: Match3GridViewDelegate?

    init!(rowCount: Int,
          columnCount: Int,
          frame: CGRect = Match3GridView.defaultFrame) {
        guard let _grid = try? CGRect2DGrid(frame: frame,
                                            columns: rowCount,
                                            rows: columnCount,
                                            originLocation: .upperLeft,
                                            defaultCellInset: nil) else {
            return nil
        }
        queues = [:]
        grid = _grid
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has no implimentation")
    }

    override convenience init(frame: CGRect) {
        self.init(rowCount: Match3GridView.defaultRowCount,
                  columnCount: Match3GridView.defaultColCount,
                  frame: frame)!
    }

    func registerClass(_ cellClass: UIView, forCellReuseIdentifier identifier: String) {}

    func refill() {
        print("please")
        guard let _delegate = delegate else { return }
        print("hi")
        for coordinate in grid.indices {
            let cell = _delegate.cellForItemAt(coordinate)
            cell.frame = grid[coordinate]
            addSubview(cell)
        }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        defer { context.restoreGState() }

        let fullRect = CGRect(origin: .zero, size: bounds.size)
        context.clear(fullRect)
        context.setFillColor(UIColor.yellow.cgColor)

        context.fill(fullRect)

        context.setStrokeColor(UIColor.magenta.cgColor)
        context.setLineWidth(2)
        context.setLineCap(.round)

        for cellRect in grid {
            context.stroke(cellRect)
        }
    }

    static var defaultRowCount = 6
    static var defaultColCount = 6
    static var defaultFrame = CGRect(x: 0, y: 0, width: 60, height: 60)
}

let view = Match3GridView(rowCount: 8,
                          columnCount: 8,
                          frame: CGRect(x: 0,
                                        y: 0,
                                        width: 320,
                                        height: 320))
let provider = RandomCellProvider()
view?.delegate = provider
view?.refill()
view

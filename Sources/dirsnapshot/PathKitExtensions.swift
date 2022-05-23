import Foundation
import PathKit

extension Path {
    func touch() {
        guard !exists else { return }
        FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
    }

    func deletingLastPathComponent() -> Path {
        Path(url.deletingLastPathComponent().path)
    }
}

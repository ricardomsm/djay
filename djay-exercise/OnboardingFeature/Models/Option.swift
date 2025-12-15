import Foundation

struct Option<Id: Hashable>: Equatable, Identifiable {
    let id: Id
    let label: String

    init(id: ID, label: String) {
        self.id = id
        self.label = label
    }
}

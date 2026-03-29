import Foundation

enum CodableValue: Equatable, Hashable, Sendable {
    case bool(Bool)
    case int(Int)
    case double(Double)
    case string(String)
    case path(String)
}

// MARK: - Codable (tagged JSON encoding)

extension CodableValue: Codable {
    private enum CodingKeys: String, CodingKey {
        case type, value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "bool":
            self = .bool(try container.decode(Bool.self, forKey: .value))
        case "int":
            self = .int(try container.decode(Int.self, forKey: .value))
        case "double":
            self = .double(try container.decode(Double.self, forKey: .value))
        case "string":
            self = .string(try container.decode(String.self, forKey: .value))
        case "path":
            self = .path(try container.decode(String.self, forKey: .value))
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type, in: container,
                debugDescription: "Unknown CodableValue type: \(type)"
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .bool(let v):
            try container.encode("bool", forKey: .type)
            try container.encode(v, forKey: .value)
        case .int(let v):
            try container.encode("int", forKey: .type)
            try container.encode(v, forKey: .value)
        case .double(let v):
            try container.encode("double", forKey: .type)
            try container.encode(v, forKey: .value)
        case .string(let v):
            try container.encode("string", forKey: .type)
            try container.encode(v, forKey: .value)
        case .path(let v):
            try container.encode("path", forKey: .type)
            try container.encode(v, forKey: .value)
        }
    }
}

// MARK: - Convenience accessors

extension CodableValue {
    var asBool: Bool? {
        if case .bool(let v) = self { return v }
        return nil
    }

    var asInt: Int? {
        if case .int(let v) = self { return v }
        return nil
    }

    var asDouble: Double? {
        if case .double(let v) = self { return v }
        return nil
    }

    var asString: String? {
        switch self {
        case .string(let v): return v
        case .path(let v): return v
        default: return nil
        }
    }

    var displayString: String {
        switch self {
        case .bool(let v): return v ? "On" : "Off"
        case .int(let v): return "\(v)"
        case .double(let v): return String(format: "%.2f", v)
        case .string(let v): return v
        case .path(let v): return v
        }
    }
}

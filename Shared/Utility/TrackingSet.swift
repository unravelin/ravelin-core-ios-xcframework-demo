struct TrackingSet: OptionSet {
    let rawValue: Int
    static let none = Self([])
    static let setup = Self(rawValue: 1 << 0)
    static let login = Self(rawValue: 1 << 1)
    static let checkout = Self(rawValue: 1 << 2)
    static let logout = Self(rawValue: 1 << 3)
    static let complete: Self = [.setup, .login, .checkout, .logout]
}

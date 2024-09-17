import OSLog

@available(iOS 14.0.0, *)
extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let ravelin = Logger(subsystem: subsystem, category: "ravelin")
}

func logError(_ string: String) {
#if DEBUG
    if #available(iOS 14.0, *) {
        Logger.ravelin.error("\(string)")
    }
#endif
}

func logInfo(_ string: String) {
#if DEBUG
    if #available(iOS 14.0, *) {
        Logger.ravelin.info("\(string)")
    }
#endif
}


import OSLog

@available(iOS 14.0.0, *)
var logger = Logger(subsystem: "com.ravelin.demo", category: "events")

func logError(_ string: String) {
    if #available(iOS 14.0, *) {
        logger.error("\(string)")
    }
}

func logInfo(_ string: String) {
    if #available(iOS 14.0, *) {
        logger.info("\(string)")
    }
}

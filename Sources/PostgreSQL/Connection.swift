#if os(Linux)
    import CPostgreSQLLinux
#else
    import CPostgreSQLMac
#endif

public final class Connection {
    public typealias ConnectionPointer = OpaquePointer

    private(set) var connection: ConnectionPointer!

    public var connected: Bool {
        if let connection = connection,
            PQstatus(connection) == CONNECTION_OK {
            return true
        }
        return false
    }

    public init(host: String = "localhost", port: String = "5432", dbname: String, user: String, password: String) throws {
        self.connection = PQconnectdb("host='\(host)' port='\(port)' dbname='\(dbname)' user='\(user)' password='\(password)'")
        if !self.connected {
            throw Error.cannotEstablishConnection
        }
    }

    public func reset() throws {
        guard self.connected else {
            throw Error.cannotEstablishConnection
        }

        PQreset(connection)
    }

    public func close() throws {
        guard self.connected else {
            throw Error.cannotEstablishConnection
        }

        PQfinish(connection)
    }

    deinit {
        try! close()
    }
}

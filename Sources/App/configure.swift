import FluentPostgreSQL
import Vapor

public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
    ) throws {
    try services.register(FluentPostgreSQLProvider())
    
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    /*var middlewares = MiddlewareConfig()
     middlewares.use(DateMiddleware.self)
     middlewares.use(ErrorMiddleware.self)
     services.register(middlewares)*/
    
    var databases = DatabasesConfig()
    //let config = PostgreSQLDatabaseConfig(hostname: "localhost", username: "giulio-skylabs", database: "locationstest")
    let config = PostgreSQLDatabaseConfig(hostname: "localhost", username: "root", database: "locationstest")
    databases.add(database: PostgreSQLDatabase(config: config), as: .psql)
    services.register(databases)
    
    var commands = CommandConfig.default()
    commands.useFluentCommands()
    services.register(commands)
    
    var migrations = MigrationConfig()
    migrations.add(model: Location.self, database: .psql)
    migrations.add(model: Trip.self, database: .psql)
    services.register(migrations)
}

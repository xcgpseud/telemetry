MigrationQueries = {
    CheckIfTableExists = [[
        SELECT EXISTS (
            SELECT  TABLE_NAME
            FROM    information_schema.TABLES
            WHERE   TABLE_NAME = @tableName
        ) AS table_exists
    ]],
    CreateGroupsTable = [[
        CREATE TABLE IF NOT EXISTS telemetry_groups (
            id INT UNSIGNED NOT NULL AUTO_INCREMENT,
            citizen_id VARCHAR(20) NOT NULL,
            name VARCHAR (256) NOT NULL,
            vehicle_names TEXT NOT NULL DEFAULT '',
            is_deleted BIT NOT NULL DEFAULT 0,

            PRIMARY KEY (id)
        )
    ]],
    CreateSpeedTestsTable = [[
        CREATE TABLE IF NOT EXISTS telemetry_speed_tests (
            id INT UNSIGNED NOT NULL AUTO_INCREMENT,
            citizen_id VARCHAR(20) NOT NULL,
            group_id INT NOT NULL DEFAULT -1,
            category_name VARCHAR(250) NOT NULL DEFAULT "",
            results_json TEXT NOT NULL DEFAULT '',
            was_cancelled BIT NOT NULL DEFAULT 0,
            is_deleted BIT NOT NULL DEFAULT 0,

            time_created DATETIME NOT NULL DEFAULT NOW(),

            PRIMARY KEY (id)
        )
    ]],
}
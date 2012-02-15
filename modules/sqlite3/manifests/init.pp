class sqlite3 {

	package { "sqlite3":
		ensure  => installed,
	}
	package { "libsqlite3-dev":
		ensure  => installed,
	}
}
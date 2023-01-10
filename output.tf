output "username" {
    value = google_sql_user.users.name
}

output "paswd" {
    value = google_sql_user.users.password
}

output "publicip" {
    value = google_sql_database_instance.sql_db.public_ip_address
}

output "dbname" {
    value = google_sql_database.database.name
}
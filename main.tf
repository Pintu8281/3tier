module "webappserver" {
  source = "./webapp_Server"
  sql_vpc_id = module.databaseserver.sql_vpc_id
  uname = module.databaseserver.username
  pass = module.databaseserver.paswd
  pubip = module.databaseserver.publicip
  dbname = module.databaseserver.dbname
}

module "databaseserver" {
  source = "./database_server"
  wp_vpc_id = module."webappserver".wp_vpc_id
  static_ip_wp = module.webappserver.static_ip_wp
}
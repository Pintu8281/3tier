provider "google" {
 credentials = file("./database_server/dbkey.json")
 project     = "project5678"
 region      = "asia-southeast1"
}
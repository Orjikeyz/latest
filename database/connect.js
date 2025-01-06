const mysql = require("mysql")
const connection = mysql.createConnection({
    host: process.env.DB_HOST || "localhost",
    user: process.env.DB_USER || "root",
    password: process.env.DB_PASSWORD || "",
    database: process.env.DB_NAME || "xcodehubproject_db",
    port: process.env.DB_PORT || 3000,
})
// global.user_id = "xcode"


connection.connect((err)=> {
    if (err) throw err;
    console.error("we are connected",err)
})

module.exports = connection
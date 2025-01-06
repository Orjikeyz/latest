const mysql = require("mysql")
const connection = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "xcodehubproject_db"
})
// global.user_id = "xcode"


connection.connect((err)=> {
    if (err) throw err;
    console.error("we are connected",err)
})

module.exports = connection
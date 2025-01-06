var express = require("express")
var connection  = require("../database/connect")
const useragent = require('useragent');
const sessionAuth = require("./session"); // Importing session authentication middleware
const session = require("express-session");

const loginPage = (req, res) => {
    res.render("login")
}
const loginAuthentication = (req, res) => {
    const {email, password} = req.body

    // Regular expression for basic email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    // Email validation
    if (email.length <= 0 || email === "") {
        return res.status(400).json({
            status: "Error",
            title: "empty",
            message: "Email field cannot be empty."
        })
    } else if (!emailRegex.test(email)) {
        return res.status(400).json({
            status: "Error",
            title: "invalid",
            message: "Please enter a valid email address."
        })
    } else {
        if (password.length <= 0 || password === "") {
            return res.status(400).json({
                status: "Error",
                title: "empty_pass",
                message: "Password field cannot be empty."
            })
        }else if (password.length < 8) {
            return res.status(400).json({
                status: "Error",
                title: "invalid_length",
                message: "Password must be at least 8 characters long."
            })
        }else {
            const loginQuery = "SELECT * FROM users WHERE email = ?";
            connection.query(loginQuery, [email], (err, loginResult)=> {
                if (err) {
                    return res.status(400).json({
                        status: "Error",
                        title: "queryError",
                        message: "Authorization Error."
                    })
                }

                if (loginResult.length === 0) {
                    return res.status(400).json({
                        status: "Error",
                        title: "invalid_account",
                        message: "The email and password entered do not exist!."
                    })                    
                }

                let loginData = JSON.parse(JSON.stringify(loginResult[0]))
                let db_email = loginData.email
                let db_password = loginData.password
                let db_user_id = loginData.user_id

                if (db_email !== email || db_password !== password) {
                    return res.status(400).json({
                        status: "Error",
                        title: "invalid_account",
                        message: "The email and password entered do not exist."
                    })
                }else {
                    const userAgentString = req.headers['user-agent'];
    
                    // Parse User-Agent string
                    const agent = useragent.parse(userAgentString);
                    
                    // Get IP address from request
                    const ipAddress = req.body.ipAddress
                    const ipAddress2 = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
                    
                    // Extract browser and device information
                    const browser = agent.toAgent(); // Example: 'Chrome 91.0.4472.124'
                    const device = agent.device.toString(); // Example: 'iPhone 12'

                    // console.log(ipAddress2, "---", req.body.ipAddress) 

                    const loginActivityQuery = "INSERT INTO user_login_activity (user_id, ip_address, ip_address2, device, browser, created_at) VALUES (?,?,?,?,?, NOW())";
                    connection.query(loginActivityQuery, [db_user_id, ipAddress, ipAddress2, device, browser], (err, loginActivityResult)=> {
                        if (err) {
                            return res.status(500).render("error", {
                                status: "Error",
                                message: "Sorry an error occurred!"
                            });
                        }            

                        const updateIpDataQuery = "UPDATE users SET ip_address = ? WHERE user_id = ?";
                        connection.query(updateIpDataQuery, [ipAddress, db_user_id], (err, updateIpDataResult)=> {
                            if (err) {
                                return res.status(500).render("error", {
                                    status: "Error",
                                    message: "Error Updating IP Address!"
                                });
                            }                

                            req.session.user_id = db_user_id
                            req.session.authenticated = true
                            return res.status(200).json({
                                status: "Success",
                                title: "access_granted",
                                message: "Access Granted"
                            })
         
                        })
                    })
               }
            })
        }
    }
}

module.exports = {
    loginPage,
    loginAuthentication
}
var express = require("express")
var connection = require("../../database/connect")
var sessionAuth = require("../session")

const login = (req, res) => {
    if (!sessionAuth.sessionAuthentication(req, res)) return
    try {
        let user_id = req.session.user_id
        const getUserQuery = `SELECT first_name, last_name, profile_image FROM users WHERE user_id = ? AND role = ?`
        connection.query(getUserQuery, [user_id, "vendor"], (err, getUserResult)=> {
            if (err) {
               return res.status(500).render("error", {
                    status: "Error",
                    message: "Error getting Vendor Data"
                })
            }

            let getUsersItems = JSON.parse(JSON.stringify(getUserResult))[0]
            
            if (req.session.vendorAuthenticated === true) {
                res.redirect("index")              
            }else {
                res.render("vendor/login", {
                    getUsersItems: getUsersItems
                })
            }

        })
    } catch (error) {
        res.status(500).json({
            status: "Error",
            message: "An unexpected error occurred"
        })
    }
}

const loginAuth = (req, res) => {
    const {pin} = req.body
    if (!sessionAuth.sessionAuthentication(req, res)) return
    let user_id = req.session.user_id

    if (!pin || pin.length !== 4 || isNaN(pin)) {
        return res.status(400).json({
            status: "Error",
            title: "invalid_pin",
            message: "Pin must be exactly 4 numeric characters."
        });
    }else {
        try {
            const loginAuthQuery = `SELECT * FROM users WHERE user_id = ?`
            connection.query(loginAuthQuery, [user_id], (err, loginAuthResult) =>{
                if (err) {
                    return res.status(500).render("error", {
                        status: "Error",
                        title: "server_error",
                        message: "There was a problem processing your login. Please try again later."
                    })    
                }

                if (loginAuthResult.length === 0) {
                    return res.status(401).render("error", {
                        status: "Error",
                        title: "login_failed",
                        message: "Invalid credentials. Please check your pin or role and try again."
                    })    
                }

                let loginAuthItems = JSON.parse(JSON.stringify(loginAuthResult))[0]

                // Now check role and pin separately
                if (loginAuthItems.role !== "vendor") {
                    return res.status(403).json({ 
                        status: "Error", 
                        title: "login_failed",
                        message: "Unauthorized role" 
                    });
                }

                if (String(loginAuthItems.pin) !== String(pin)) {
                    return res.status(401).json({ 
                        status: "Error", 
                        title: "login_failed",
                        message: "Invalid pin" 
                    });
                }

                req.session.vendorAuthenticated = true
                return res.status(200).json({ 
                    status: "Success", 
                    title: "Success",
                    message: "Access Granted" 
                });
            })
        } catch (error) {
            res.status(500).json({
                status: "Error",
                title: "unexpected",
                message: "An unexpected error occurred"
            })    
        }
    }
}


module.exports = {
    login,
    loginAuth
}
var express = require("express")
var session = require("express-session")

const sessionAuthentication = (req, res) => {
    if (!req.session.authenticated) {
        return res.redirect("/login")
        return false 
    }
    // console.log(req.session.user_id)
    return true
}

const sessionVendorAuthentication = (req, res) => {
    if (!req.session.vendorAuthenticated) {
        return res.redirect("/login")
        return false 
    }
    // console.log(req.session.user_id)
    return true
}
module.exports = {
    sessionAuthentication,
    sessionVendorAuthentication
}



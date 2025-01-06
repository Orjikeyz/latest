var express = require("express")
var connection = require("../../database/connect")

const index = (req, res)=> {
    res.render("vendor/index")
}

module.exports = {
    index
}
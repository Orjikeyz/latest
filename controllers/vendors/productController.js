var express = require("express")
var connection = require("../../database/connect")
var sessionAuth = require("../session")

const multer = require("multer");
const {categoryPage} = require("../productsController");
const upload = multer();

const Allproducts = (req, res) => {
    // if (!sessionAuth.sessionAuthentication(req, res)) return;
    // if (!sessionAuth.sessionVendorAuthentication(req, res)) return;
    // const user_id = req.session.user_id
    const user_id = "xcode"

    try {
        const allProductsQuery = `SELECT * FROM products WHERE product_user_id = ? ORDER BY created_at DESC`
        connection.query(allProductsQuery, [user_id], (err, allProductResult) => {
            if (err) {
                return res.status(500).render("error", {
                    status: "Error",
                    message: "Error getting product items"
                })
            }

            let allProductItems = JSON.parse(JSON.stringify(allProductResult))
            res.status(200).render("vendor/product-list", {
                allProductItems: allProductItems
            })

        })
    } catch (error) {
        res.status(500).render("error", {
            status: "Error",
            message: "An unexpected error occurred while processing your request. Please try again later."
        })
    }
}

const addProduct = (req, res) => {
    if (!sessionAuth.sessionAuthentication(req, res)) return;
    if (!sessionAuth.sessionVendorAuthentication(req, res)) return;
    const user_id = req.session.user_id

    try {
        const categoryQuery = "SELECT name FROM category";
        connection.query(categoryQuery, (err, categoryResult) => {
            if (err) {
                res.status(500).json({
                    status: "Error",
                    message: "Error Getting Category Data."
                })
            }

            let categoryItems = JSON.parse(JSON.stringify(categoryResult))
            console.log(categoryItems)
            res.render("vendor/add-product.ejs", {
                categoryItems: categoryItems
            })
        })
    } catch (error) {
        res.status(500).json({
            status: "Error",
            message: "An unexpected error occurred while processing your request. Please try again later."
        })
    }
}

const addProductData = (req, res) => {

    if (!sessionAuth.sessionAuthentication(req, res)) return;
    if (!sessionAuth.sessionVendorAuthentication(req, res)) return;
    const user_id = req.session.user_id

    // Generate RefId
    function generateRefID(length = 6) {
        const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        let refID = '';
        for (let i = 0; i < length; i++) {
            const randomIndex = Math.floor(Math.random() * characters.length);
            refID += characters[randomIndex];
        }
        return refID;
    }

    const filenames = req.files.map(file => file.filename);
    const {name, category, price, description} = req.body
    const uploadQuery = "INSERT INTO products (name, category, price, description, product_user_id, ref_id, image_urls) VALUES (?,?,?,?,?,?,?)"

    // Convert filenames to JSON for storing
    const imageUrlsJson = JSON.stringify(filenames);
    const refID = generateRefID();

    try {
        connection.query(uploadQuery, [name, category, price, description, user_id, refID, imageUrlsJson], (err, uploadResult) => {
            if (err) {
                res.status(500).json({
                    status: "Error",
                    message: "Error Uploading Product Data."
                })
            }

            // Check if required fields are provided
            if (!name || !category || !price || !description) {
                return res.status(400).json({
                    status: "Error",
                    message: "All fields are required.",
                });
            }

            // Validate price is a valid number
            if (isNaN(price) || price <= 0) {
                return res.status(400).json({
                    status: "Error",
                    message: "Price must be a valid positive number.",
                });
            }

            // Check if files are uploaded
            if (!req.files || req.files.length === 0) {
                return res.status(400).json({
                    status: "Error",
                    message: "At least one image must be uploaded.",
                });
            }

            res.status(200).json({
                status: "success",
                message: "Product data uploaded successfully."
            })

        })
    } catch (error) {
        res.status(500).json({
            status: "Error",
            message: "An unexpected error occurred while processing your request. Please try again later."
        })
    }

}

module.exports = {
    Allproducts,
    addProduct,
    addProductData
}
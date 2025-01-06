var express = require("express")
express.json
var connection = require("../database/connect");
const { json } = require("body-parser");
const sessionAuth = require("./session")


const getAllCarts = (req, res) => {
    const posted_by = req.params.posted_by
    if (!sessionAuth.sessionAuthentication(req, res)) return;
    const user_id = req.session.user_id

    try {
        const getAllCartQuery = `SELECT * FROM carts WHERE user_id = ? AND posted_by = ?`;

        connection.query(getAllCartQuery, [user_id, posted_by], (err, getAllCartResult) => {
            if (err) {
                console.error("Database error while fetching carts:", err);
                return res.status(500).render("error", {
                    status: "Error",
                    message: "Error getting All Cart Items"
                });
            }

            const getAllCartItems = JSON.parse(JSON.stringify(getAllCartResult));

            if (getAllCartItems.length === 0) {
                return res.status(404).render("404", {
                    status: "Error",
                    message: "Empty Cart Item"
                });
            }

            const productIds = getAllCartItems.map((item) => item.product_id);

            const getProductCartsQuery = `
                SELECT users.user_id, products.id, products.ref_id, products.name, products.description, products.category, products.posted_by, products.price, products.image_urls, products.currency, carts.cart_price, carts.quantity, carts.cart_id 
                FROM carts 
                INNER JOIN products ON carts.product_id = products.id 
                INNER JOIN users ON carts.user_id = users.user_id
                WHERE users.user_id = ?
                AND products.id IN (?)
                AND carts.posted_by = ?
            `;

            connection.query(getProductCartsQuery, [user_id, productIds, posted_by], (err, getProductCartsResult) => {
                if (err) {
                    console.error("Database error while fetching product carts:", err);
                    return res.status(500).render("error", {
                        status: "Error",
                        message: "Error getting Product Cart Items"
                    });
                }

                const getProductCarts = JSON.parse(JSON.stringify(getProductCartsResult));
                // console.log(getProductCarts)
                return res.render("cart", {
                    getProductCarts: getProductCarts
                });
            });
        });
    } catch (err) {
        console.error("Unexpected error in getAllCarts:", err);

        return res.status(500).render("error", {
            status: "Error",
            message: "An unexpected error occurred while processing your request. Please try again later."
        });
    }
};


const getAllCartsPostData = (req, res) => {
    const posted_by = req.params.posted_by
    if (!sessionAuth.sessionAuthentication(req, res)) return;
    const user_id = req.session.user_id

    try {
        const getAllCartQuery = `SELECT * FROM carts WHERE user_id = ? AND posted_by = ?`;

        connection.query(getAllCartQuery, [user_id, posted_by], (err, getAllCartResult) => {
            if (err) {
                console.error("Database error while fetching carts:", err);
                return res.status(500).render("error", {
                    status: "Error",
                    message: "Error getting All Cart Items"
                });
            }

            const getAllCartItems = JSON.parse(JSON.stringify(getAllCartResult));

            if (getAllCartItems.length === 0) {
                return res.status(404).json({
                    status: "Error",
                    message: "Empty Cart Item"
                });
            }

            const productIds = getAllCartItems.map((item) => item.product_id);

            const getProductCartsQuery = `
                SELECT users.user_id, products.id, products.ref_id, products.name, products.description, products.category, products.posted_by, products.price, products.image_urls, products.currency, carts.cart_price, carts.quantity, carts.cart_id 
                FROM carts 
                INNER JOIN products ON carts.product_id = products.id 
                INNER JOIN users ON carts.user_id = users.user_id
                WHERE users.user_id = ?
                AND products.id IN (?)
                AND carts.posted_by = ?
            `;

            connection.query(getProductCartsQuery, [user_id, productIds, posted_by], (err, getProductCartsResult) => {
                if (err) {
                    console.error("Database error while fetching product carts:", err);
                    return res.status(500).json({
                        status: "Error",
                        message: "Error getting Product Cart Items"
                    });
                }

                const getProductCarts = JSON.parse(JSON.stringify(getProductCartsResult));
                // console.log(getProductCarts)
                return res.status(200).json({
                    getProductCarts: getProductCarts
                });
            });
        });
    } catch (err) {
        console.error("Unexpected error in getAllCarts:", err);

        return res.status(500).json( {
            status: "Error",
            message: "An unexpected error occurred while processing your request. Please try again later."
        });
    }
};


const deleteCart = (req, res) => {
    const {id} = req.body
        if (!sessionAuth.sessionAuthentication(req, res)) return;
    const user_id = req.session.user_id


    try {
        const deleteQuery = "DELETE FROM carts WHERE cart_id = ? AND user_id = ?"
        connection.query(deleteQuery, [id, user_id], (err, result) => {
            if (err) {
                res.status(500).json({
                    status: "error",
                    message: "Error Deleting cart item"
                })
            }

            res.status(200).json({
                status: "success",
                message: "Cart item deleted successfully"
            })
        })
    } catch (err) {
        console.error("Unxpected error in deleteCart:", err)
    }
}

const addToCart = (req, res) => {
        if (!sessionAuth.sessionAuthentication(req, res)) return;
    const user_id = req.session.user_id


    const {
        cart_price,
        posted_by,
        product_id,
        quantity
    } = req.body;

    try {
        // Check if product is already in cart   
        const cartCheck = "SELECT * FROM carts WHERE product_id = ? AND user_id = ?";
        connection.query(cartCheck, [product_id, user_id], (err, cartCheckResult) => {
            if (err) {
                console.error("Error checking cart items:", err);
                return res.status(500).json({
                    status: "error",
                    message: "Error checking cart items"
                });
            }

            if (cartCheckResult.length > 0) {
                const updateCartQuery = "UPDATE carts SET cart_price = ?, posted_by = ?, product_id = ?, quantity = ? WHERE user_id = ? AND product_id = ?";
                connection.query(updateCartQuery, [cart_price, posted_by, product_id, quantity, user_id, product_id], (err, updateCartResult)=> {
                    if (err) {
                        console.log(err)
                        return res.status(500).json({
                            status: "error",
                            message: "Error updating cart items"
                        });
                    }

                    res.status(200).json({
                        status: 'update',
                        message: 'Product has been updated in the cart.'
                    })
                })
            }else {
                const insertCartQuery = "INSERT INTO carts (cart_price, posted_by, product_id, quantity, user_id) VALUES (?,?,?,?,?)";
                connection.query(insertCartQuery, [cart_price, posted_by, product_id, quantity, user_id], (err, insertCartResult) => {
                    if (err) {
                        console.log(err)
                        return res.status(500).json({
                            status: "error",
                            message: "Error inserting cart items"
                        });
                    }

                    res.status(200).json({
                        status: 'success',
                        message: 'Product has been added to the cart'
                    })
                })
            }

        });

    } catch (err) {
        console.error("Error processing Add to Cart item:", err);
        return res.status(500).json({
            status: "error",
            message: "An unexpected error occurred"
        });
    }
}

const getCartVendors = (req, res) => {
        if (!sessionAuth.sessionAuthentication(req, res)) return;
    const user_id = req.session.user_id


    try {
        const getCartVendorsQuery = `SELECT posted_by, COUNT(*) AS total_posted_by, quantity, SUM(quantity) AS total_quantity, cart_price, SUM(cart_price) AS total_price, users.profile_image, users.username, users.first_name, users.last_name, users.currency  FROM carts 
        INNER JOIN users ON carts.posted_by = users.username
        WHERE carts.user_id = ? GROUP BY carts.posted_by`;

        connection.query(getCartVendorsQuery, [user_id], (err, getCartVendorsResult) => {
            if (err) {
                console.error("Error getting cart vendors:", err);
                return res.status(500).json({
                    status: "error",
                    message: "Error getting cart vendors"
                });
            }

            // Convert the result into a clean JSON format
            let getCartVendorsItems = JSON.parse(JSON.stringify(getCartVendorsResult));
            
            // Send the distinct vendors as a JSON response
            // console.log(getCartVendorsItems)
            return res.render("carts_vendor", {
                getCartVendorsItems: getCartVendorsItems
            });
        });
    } catch (error) {
        console.error("Unexpected error occurred:", error);
        return res.status(500).json({
            status: "error",
            message: "An unexpected error occurred"
        });
    }
};


module.exports = {
    getAllCarts,
    getAllCartsPostData,
    deleteCart,
    addToCart,
    getCartVendors
}
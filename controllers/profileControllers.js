var express = require("express");
var connection = require("../database/connect"); // Database connection
const sessionAuth = require("./session"); // Importing session authentication middleware
const session = require("express-session");
const {resolve} = require("path");
const {json} = require("body-parser");

// ============================================
// GET PROFILE PAGE
// ============================================

// Controller function to fetch and render the profile page of the logged-in user
const getProfilePage = async (req, res) => {
    // Check if the user is authenticated, if not, redirect or block access
    if (!sessionAuth.sessionAuthentication(req, res)) return;

    // Get the user's session ID
    const user_id = req.session.user_id;

    try {
        const getTotalCartItems = await getTotalCarts(req, res)
        const totalVendorsItems = await getTotalVendors(req, res)
        
        // Query to retrieve user profile data from the 'users' table
        const getProfileQuery = "SELECT * FROM users WHERE user_id = ? LIMIT 1";
        connection.query(getProfileQuery, [user_id], (err, getProfileResult) => {
            // Handle any errors during the query execution
            if (err) {
                return res.status(500).render("error", {
                    status: "error",
                    message: "Error retrieving vendor data"
                });
            }

            // Process the result and render the profile page
            let getProfileItems = getProfileResult[0]; // Extract the first result (user profile)
            res.render("profilePage/profile", {
                getProfileItems: getProfileItems, // Send profile data to the view
                getTotalCartItems: getTotalCartItems[0].total_Cartitems || 0,
                totalVendorsItems: totalVendorsItems[0].total_Vendors || 0
            });
        });
    } catch (error) {
        console.log(error)
        return res.status(500).render("error", {
            status: "error",
            message: "An unexpected error occurred"
        });

    }

};

const getTotalCarts = async (req, res) => {
    const user_id = req.session.user_id;

    // Use a Promise to handle the asynchronous nature of the query
    return new Promise((resolve, reject) => {
        const cartTotalQuery = `SELECT COUNT(quantity) AS total_Cartitems FROM carts WHERE user_id = ?`;

        connection.query(cartTotalQuery, [user_id], (err, getTotalCartResult) => {
            if (err) {
                reject(err);
                return res.status(500).render("error", {
                    status: "error",
                    message: "Error retrieving cart data"
                });
            }
            let getTotalCartItems = JSON.parse(JSON.stringify(getTotalCartResult))
            resolve(getTotalCartItems); // Return the result of the query
        });
    });
};

const getTotalVendors = async (req, res) => {
    const user_id = req.session.user_id;

    // Use a Promise to handle the asynchronous nature of the query
    return new Promise((resolve, reject) => {
        const totalVendorsQuery = `SELECT COUNT(vendor_id) AS total_Vendors FROM vendor_follows WHERE user_id = ?`;

        connection.query(totalVendorsQuery, [user_id], (err, totalVendorsResult) => {
            if (err) {
                reject(err);
                return res.status(500).render("error", {
                    status: "error",
                    message: "Error retrieving cart data"
                });
            }
            let totalVendorsItems = JSON.parse(JSON.stringify(totalVendorsResult))
            resolve(totalVendorsItems); // Return the result of the query
        });
    });
};


// ============================================
// GET ALL VENDORS PAGE
// ============================================

// Controller function to fetch and render a list of all vendors
const getAllvendors = (req, res) => {
    // Check if the user is authenticated, if not, redirect or block access
    if (!sessionAuth.sessionAuthentication(req, res)) return;

    // Get the user's session ID
    const user_id = req.session.user_id;

    try {
        // Query to retrieve all vendors' data, including a random product image for each vendor
        const getAllvendorsQuery = `
            SELECT products.id, users.profile_image, users.user_id, users.username, users.first_name, users.last_name, users.bio, 
            (SELECT products.image_urls FROM products WHERE products.posted_by = users.username ORDER BY RAND() LIMIT 1) AS random_image_url
            FROM users INNER JOIN products ON users.username = products.posted_by  
            WHERE users.role = ?
            GROUP BY users.username ORDER BY RAND() 
        `;

        // Execute the query
        connection.query(getAllvendorsQuery, ["vendor"], (err, getAllvendorsResult) => {
            // Handle any errors during the query execution
            if (err) {
                return res.status(500).render("error", {
                    status: "error",
                    message: "Error retrieving vendor data"
                });
            }

            // Parse the result and check if there are any vendors
            const getAllvendorsItems = JSON.parse(JSON.stringify(getAllvendorsResult));
            if (getAllvendorsItems.length === 0) {
                return res.status(404).render("404", {
                    status: "error",
                    message: "Empty Vendor List" // Handle empty vendor list
                });
            }

            // Render the vendors slide page with the list of vendors
            return res.render("vendors-slide", {
                getAllvendorsItems: getAllvendorsItems // Send vendor data to the view
            });
        });
    } catch (err) {
        // Catch any unexpected errors
        console.error("Unexpected error in getAllvendors:", err);
        return res.status(500).render("error", {
            status: "error",
            message: "An unexpected error occurred"
        });
    }
};

// ============================================
// GET VENDOR PROFILE PAGE
// ============================================

// Controller function to fetch and render a specific vendor's profile and their products
const getVendorsProfile = (req, res) => {
    // Get the vendor username from the request parameters
    const vendorUsername = req.params.user;

    // Check if the user is authenticated; if not, redirect or block access
    if (!sessionAuth.sessionAuthentication(req, res)) return;

    // Get the user's session ID
    const user_id = req.session.user_id;

    // Query to retrieve the vendor's profile data from the 'users' table
    const getVendorsProfileQuery = `
        SELECT first_name, last_name, user_id, username, email, bio, vendor_status, profile_image 
        FROM users 
        WHERE username = ? AND role = ? 
        LIMIT 1
    `;

    // Execute the query to fetch vendor profile data
    connection.query(getVendorsProfileQuery, [vendorUsername, "vendor"], (err, getVendorsProfileResult) => {
        // Handle any errors during the query execution
        if (err) {
            return res.status(500).render("error", {
                status: "error",
                message: "Error retrieving vendor Profile data"
            });
        }

        // Parse the result and check if the vendor exists
        const getVendorsProfileItems = JSON.parse(JSON.stringify(getVendorsProfileResult));
        if (getVendorsProfileItems.length === 0) {
            return res.status(404).render("error", {
                status: "error",
                message: "Error retrieving vendor Profile data"
            });
        }

        // Query to retrieve the vendor's products from the 'products' table
        let getVendorusersProductQuery = "SELECT * FROM products WHERE posted_by = ?";
        connection.query(getVendorusersProductQuery, [vendorUsername], (err, getVendorusersProductResult) => {
            // Handle any errors during the query execution
            if (err) {
                return res.status(500).render("error", {
                    status: "error",
                    message: "Error retrieving vendor product data"
                });
            }

            // Query to check if the user follows the vendor
            const getFollowCheckQuery = "SELECT * FROM vendor_follows WHERE user_id = ? AND vendor_id = ?";
            connection.query(getFollowCheckQuery, [user_id, vendorUsername], (err, getFollowCheckResult) => {
                // Handle any errors during the follow check query
                if (err) {
                    return res.status(500).render("error", {
                        status: "error",
                        message: "Error retrieving vendor follow check"
                    });
                }

                // Parse the follow check result
                let getFollowCheckItems = JSON.parse(JSON.stringify(getFollowCheckResult));

                // Parse the product result
                let getVendorusersProductItems = JSON.parse(JSON.stringify(getVendorusersProductResult));
                
                // Render the vendor profile page with both vendor and product data
                res.render("vendors_profile", {
                    getVendorsProfileItems: getVendorsProfileItems, // Send vendor profile data to the view
                    getVendorusersProductItems: getVendorusersProductItems, // Send vendor's product data to the view
                    getFollowCheckItems: getFollowCheckItems // Send follow check data to the view
                });
            });
        });
    });
};


const getProfileInfo = (req, res) => {
    if (!sessionAuth.sessionAuthentication(req, res)) return;
    const user_id = req.session.user_id;

    try {
        const getProfileInfoQuery = "SELECT * FROM users WHERE user_id = ?"
        connection.query(getProfileInfoQuery, [user_id], (err, getProfileInfoResult) => {
            if (err) {
                return res.status(500).render("error", {
                    status: "error",
                    message: "Error retrieving users details"
                });
            }

            let getProfileInfoitems = getProfileInfoResult[0]
            res.render("profilePage/profile_info", {
                getProfileInfoitems: getProfileInfoitems
            })
        })
    } catch (error) {
        // console.log(error)
        return res.status(500).render("error", {
            status: "error",
            message: "An unexpected error occurred"
        });
    }
}

const UpdateprofileInfo = (req, res) => {
    const {
        first_name,
        last_name,
        email,
        address,
        city,
        state,
        country,
        tel,
        bio,
        business_name,
        business_address
    } = req.body;

    if (!sessionAuth.sessionAuthentication(req, res)) return;

    const user_id = req.session.user_id;

    if (!user_id) {
        return res.status(400).json({
            status: "error",
            message: "User ID not found in session"
        });
    }

    let fileName;
    if (req.file) {
        let file = req.file
        const filePath = file.path;
        fileName = file.filename;
    } else {
        fileName = req.body.existing_file
    }

    const UpdateprofileInfoQuery = `
        UPDATE users 
        SET first_name = ?, last_name = ?, email = ?, address = ?, city = ?, state = ?, country = ?, phone = ?, bio = ?, business_name = ?, business_address = ?, profile_image = ?, updated_at = NOW() 
        WHERE user_id = ?
    `;

    connection.query(
        UpdateprofileInfoQuery,
        [first_name, last_name, email, address, city, state, country, tel, bio, business_name, business_address, fileName, user_id],
        (err, UpdateprofileResult) => {
            if (err) {
                console.error(err);
                return res.status(500).json({
                    status: "Error",
                    message: "Error updating user details"
                });
            }

            res.status(200).json({
                status: "Success",
                message: "Profile updated successfully"
            });
        }
    );
};

const followVendor = (req, res) => {
    // Check if the user is authenticated using seso ssion authentication
    if (!sessionAuth.sessionAuthentication(req, res)) return;

    // Get the user ID from the session
    const user_id = req.session.user_id;
    // If no user ID is found, respond with an error message
    if (!user_id) {
        return res.status(400).json({
            status: "error",
            message: "User ID not found in session"
        });
    }

    try {
        // Extract the vendor username from the request body
        const { vendorUsername } = req.body;

        // Query to check if the vendor exists in the users table
        const vendorListQuery = "SELECT * FROM users WHERE username = ? AND role = ?";
        connection.query(vendorListQuery, [vendorUsername, "vendor"], (err, vendorListResult) => {
            // Handle any errors that occur during the query
            if (err) {
                console.log(err);
                return res.status(400).json({
                    status: "error",
                    message: "Error Getting vendor data"
                });
            }

            // Check if the vendor was found
            if (vendorListResult.length <= 0) {
                return res.status(400).json({
                    status: "error",
                    message: "Vendor not found"
                });
            }

            // Retrieve the vendor's user ID from the result
            let vendorUserId = vendorListResult[0].user_id;

            // Query to check if the user is already following the vendor
            const vendorCheckQuery = "SELECT * FROM vendor_follows WHERE user_id = ? AND vendor_id = ?";
            connection.query(vendorCheckQuery, [user_id, vendorUserId], (err, vendorCheckResult) => {
                // Handle any errors during the follow check query
                if (err) {
                    console.log(err);
                    return res.status(400).json({
                        status: "error",
                        message: "Error Getting follow data"
                    });
                }

                // If the user is already following the vendor, remove the follow
                if (vendorCheckResult.length > 0) {
                    const deleteVendorQuery = "DELETE FROM vendor_follows WHERE user_id = ? AND vendor_id = ?";
                    connection.query(deleteVendorQuery, [user_id, vendorUserId], (err, deleteVendorResult) => {
                        // Handle any errors during the delete query
                        if (err) {
                            console.log(err);
                            return res.status(400).json({
                                status: "error",
                                message: "Error removing vendor"
                            });
                        }

                        // Respond with success message for removing the vendor
                        return res.status(200).json({
                            status: "success_remove",
                            message: "Vendor Removed"
                        });
                    });
                } else {
                    // If the user is not following the vendor, add the follow
                    const addVendorQuery = "INSERT INTO vendor_follows (user_id, vendor_id) VALUES (?, ?)";
                    connection.query(addVendorQuery, [user_id, vendorUserId], (err, addVendorResult) => {
                        // Handle any errors during the add query
                        if (err) {
                            console.log(err);
                            return res.status(400).json({
                                status: "error",
                                message: "Error adding vendor"
                            });
                        }

                        // Respond with success message for adding the vendor
                        return res.status(200).json({
                            status: "success_added",
                            message: "Vendor Added"
                        });
                    });
                }
            });
        });
    } catch (error) {
        // Handle any unexpected errors
        return res.status(500).json({
            status: "error",
            message: "An unexpected error occurred"
        });
    }
};

const vendorsList = (req, res) => {
    // Check if the user is authenticated
    if (!sessionAuth.sessionAuthentication(req, res)) return;

    // Get user ID from session
    const user_id = req.session.user_id;
    if (!user_id) {
        return res.status(400).json({
            status: "error",
            message: "User ID not found in session"
        });
    }

    try {
        // SQL query to get vendors and their total products count, 
        // and join with the 'vendor_follows' table to get follow data.
        const getAllVendorsQuery = `
            SELECT users.username, users.vendor_status, users.user_id, users.profile_image, users.business_name, products.id, 
            COUNT(products.id) AS total_products
            FROM users
            LEFT JOIN products ON products.posted_by = users.username
            INNER JOIN vendor_follows ON vendor_follows.vendor_id = users.user_id AND vendor_follows.user_id = ?
            WHERE users.role = ?
            GROUP BY users.username
            ORDER BY vendor_follows.follow_date
        `;

        // Execute the query
        connection.query(getAllVendorsQuery, [user_id, "vendor"], (err, getAllVendorsResult) => {
            if (err) {
                // Handle any errors during query execution
                console.log(err)
                return res.status(500).render("error", {
                    status: "Error",
                    message: "Error getting vendor details"
                });
            }

            // Parse query result
            const getAllVendorsItems = JSON.parse(JSON.stringify(getAllVendorsResult));

            // Check if there are no vendors
            if (getAllVendorsItems.length === 0) {
                return res.status(404).render("404", {
                    status: "Error",
                    message: "No Vendors Available!"
                });
            }

            // Log vendor data (for debugging)
            console.log(getAllVendorsItems);

            // Render vendors list page
            return res.render("profilePage/vendorsList", {
                getAllVendorsItems: getAllVendorsItems
            });
        });
    } catch (error) {
        // Handle unexpected errors
        return res.status(500).render("error", {
            status: "error",
            message: "An unexpected error occurred"
        });
    }
};



const changePassword = (req, res) => {
    if (!sessionAuth.sessionAuthentication(req, res)) return;

    const user_id = req.session.user_id;
    if (!user_id) {
        return res.status(400).json({
            status: "error",
            message: "User ID not found in session"
        });
    }
    res.render("profilePage/changePassword")
}

const updatePassword = (req, res) => {
    if (!sessionAuth.sessionAuthentication(req, res)) return;

    const user_id = req.session.user_id;
    if (!user_id) {
        return res.status(400).json({
            status: "error",
            message: "User ID not found in session"
        });
    }

    const {
        current_password,
        new_password,
        confirm_password
    } = req.body
    try {
        const updatePasswordQuery = "SELECT * FROM users WHERE user_id = ?"
        connection.query(updatePasswordQuery, [user_id], (err, updatePasswordResult) => {
            if (err) {
                res.status(500).json({
                    status: "Error",
                    message: "Error getting users details"
                })
            }
            let updatePasswordItems = JSON.parse(JSON.stringify(updatePasswordResult[0]))
            let db_current_password = updatePasswordItems.password

            if (current_password === "" || new_password === "" || new_password === "") {
                res.status(400).json({
                    status: "Error",
                    message: "Input's cannot be empty."
                })
            } else if (db_current_password != current_password) {
                res.status(400).json({
                    status: "Error",
                    message: "The current password you entered is incorrect."
                })
            } else if (new_password != confirm_password) {
                res.status(400).json({
                    status: "Error",
                    message: "Passwords do not match. Please make sure both fields are identical."
                })
            } else if (new_password.length < 8) {
                res.status(400).json({
                    status: "Error",
                    message: "Password must be at least 8 characters long."
                })
            } else {
                const updatePasswordDataQuery = "UPDATE users SET password = ?, updated_at = NOW() WHERE user_id = ?"
                connection.query(updatePasswordDataQuery, [new_password, user_id], (err, updatePasswordDataResult) => {
                    if (err) {
                        res.status(500).json({
                            status: "Error",
                            message: "Error getting updating user password"
                        })
                    }

                    res.status(200).json({
                        status: "Success",
                        message: "Your password has been successfully updated."
                    })

                })
            }
        })
    } catch (error) {
        return res.status(500).render("error", {
            status: "error",
            message: "An unexpected error occurred"
        });
    }
}

const privacyPolicy = (req, res) => {
    res.render("profilePage/privacy_policy")
}

const terms = (req, res) => {
    res.render("profilePage/terms")
}

const faq = (req, res) => {
    res.render("profilePage/faq")
}

const report = (req, res) => {
    res.render("profilePage/report")
}

const reportRequest = (req, res) => {
    const {
        full_name,
        email,
        issue_type,
        description
    } = req.body
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (full_name === "" || email === "" || issue_type === "" || description === "") {
        res.status(400).json({
            status: "Error",
            message: "Input's cannot be empty."
        })
    } else if (!emailRegex.test(email)) {
        res.status(400).json({
            status: "Error",
            message: "Please enter a valid email address."
        })
    } else {
        try {
            const reportQuery = "INSERT INTO reports (full_name, email, issue_type, description) VALUES(?,?,?,?)";
            connection.query(reportQuery, [full_name, email, issue_type, description], (err, reportResult) => {
                if (err) {
                    res.status(500).json({
                        status: "Error",
                        message: "Error processing report data"
                    })
                }

                res.status(200).json({
                    status: "Success",
                    message: "Thank you! Your report request has been sent successfully.."
                })

            })
        } catch (error) {
            return res.status(500).render("error", {
                status: "error",
                message: "An unexpected error occurred"
            });
        }
    }
}

const loginAlert = (req, res) => {
    if (!sessionAuth.sessionAuthentication(req, res)) return;

    const user_id = req.session.user_id;
    if (!user_id) {
        return res.status(400).json({
            status: "error",
            message: "User ID not found in session"
        });
    }

    try {
        const loginAlertQuery = "SELECT * FROM user_login_activity WHERE user_id = ? ORDER BY created_at DESC LIMIT 10";
        connection.query(loginAlertQuery, [user_id], (err, loginAlertResult) => {
            if (err) {
                res.status(500).json({
                    status: "Error",
                    message: "Error processing report data"
                })
            }

            const loginAlertItems = JSON.parse(JSON.stringify(loginAlertResult))
            res.render("profilePage/login_alert", {
                loginAlertItems: loginAlertItems
            })
        })
    } catch (error) {
        console.log(error)
        return res.status(500).render("error", {
            status: "error",
            message: "An unexpected error occurred"
        });
    }
}

const logout = (req, res) => {
    // Check if user is authenticated
    if (req.session.user_id) {
        // Destroy the session
        req.session.destroy(err => {
            if (err) {
                return res.status(500).render("error", {
                    status: "error",
                    message: "Could not log out, please try again."
                });
            }
            // Redirect to login page or send a success message
            res.redirect('/login'); // Change this to your login route
        });
    } else {
        res.status(400).render("error", {
            status: "error",
            message: "No user is logged in."
        });
    }
};


// Exporting the controller functions to be used in the routes
module.exports = {
    getProfilePage,
    getAllvendors,
    getVendorsProfile,
    getProfileInfo,
    UpdateprofileInfo,
    followVendor,
    vendorsList,
    changePassword,
    updatePassword,
    privacyPolicy,
    terms,
    faq,
    report,
    reportRequest,
    loginAlert,
    logout
};
const express = require("express");
const bodyParser = require("body-parser");
const session = require('express-session');
const connection = require("./database/connect"); // Importing database connection
const multer = require('multer')
const path = require('path')
const useragent = require('useragent');

const app = express();

// =========================
// MIDDLEWARE CONFIGURATION
// =========================

// Body parser middleware to handle URL-encoded data
app.use(bodyParser.urlencoded({
    extended: true
}));


// Middleware to handle JSON data
app.use(express.json());

// Setting up EJS as the view engine
app.set("view engine", "ejs");

// Serving static files from the "public" directory
app.use(express.static("public"));

// Session management middleware
app.use(session({
    secret: "x23!fj@39KDkls9281n@z%01Pqs8#r!LD",
    resave: false,
    saveUninitialized: true,
    cookie: {
        maxAge: 1000 * 60 * 60 * 24 // 1 day
    }
}));


// Multer setup for profile image upload
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'public/uploads/test2/'); // Directory where profile images will be stored
    },
    filename: function (req, file, cb) {
        cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname)); // Unique filename for profile images
    }
});

// Multer setup for product file upload
const storage2 = multer.diskStorage({
    destination: (req, file, cb) => {
        console.log('Saving to folder...');
        cb(null, 'public/uploads/'); // Directory where product files will be stored
    },
    filename: (req, file, cb) => {
        console.log('Generating filename...');
        cb(null, Date.now() + '-' + file.originalname); // Unique filename for product files
    },
});

// Create Multer instances
const upload = multer({ storage }); // For profile uploads
const upload2 = multer({ storage: storage2 }); // For product uploads


// =========================
// ROUTE HANDLERS IMPORT
// =========================

// Importing controller functions
const getProductController = require("./controllers/productsController");
const getCartsController = require("./controllers/cartsController");
const getProfileController = require("./controllers/profileControllers");
const getAuthenticationController = require("./controllers/authenticationController");

//Importing vendor controller functions
const getdashboardController = require("./controllers/vendors/dashboardController")
const getVendorProductController = require("./controllers/vendors/productController")
const getvendorAuthController = require("./controllers/vendors/authController")

//Importing session controller functions
const sessionAuthentication = require("./controllers/session");

// =========================
// ROUTES CONFIGURATION
// =========================

// Home route - Display all products
app.get("/", (req, res) => {
    getProductController.getAllProducts(req, res);
});

// Product details route - Display a specific product
app.get("/product_view/:id", (req, res) => {
    getProductController.getProduct(req, res);
});

// Product search routes
app.get("/products", (req, res) => {
    getProductController.SearchProduct(req, res);
});

app.get("/category", (req, res) => {
    getProductController.categoryPage(req, res);
});

app.post("/category", (req, res) => {
    getProductController.categoryProduct(req, res);
});

app.post("/categorySearch", (req, res) => {
    getProductController.categoryProduct(req, res);
});

app.post("/searchQuery", (req, res) => {
    getProductController.searchQuery(req, res);
});

// Cart routes
app.get("/cart/:posted_by", (req, res) => {
    getCartsController.getAllCarts(req, res);
});

app.post("/cart/:posted_by", (req, res) => {
    getCartsController.getAllCartsPostData(req, res);
});

app.get("/carts_vendor", (req, res) => {
    getCartsController.getCartVendors(req, res);
});

app.post("/addToCart", (req, res) => {
    getCartsController.addToCart(req, res);
});

app.post("/deleteCart", (req, res) => {
    getCartsController.deleteCart(req, res);
});

// Profile routes
app.get("/profilePage/profile", (req, res) => {
    getProfileController.getProfilePage(req, res);
});

app.get("/vendors-slide", (req, res) => {
    getProfileController.getAllvendors(req, res);
});

app.get("/vendors_profile/:user", (req, res) => {
    getProfileController.getVendorsProfile(req, res);
});

app.get("/profilePage/profile_info", (req, res) => {
    getProfileController.getProfileInfo(req, res)
})

app.post("/profilePage/followVendor", (req, res) => {
    getProfileController.followVendor(req, res)
})

app.get("/profilePage/vendorsList", (req, res) => {
    getProfileController.vendorsList(req, res)
})

app.post("/profilePage/UpdateprofileInfo", upload.array('images', 5), (req, res) => {
    getProfileController.UpdateprofileInfo(req, res)
})

app.get("/profilePage/changePassword", (req, res) => {
    getProfileController.changePassword(req, res)
})

app.post("/profilePage/updatePassword", (req, res) => {
    getProfileController.updatePassword(req, res)
})

app.get("/profilePage/privacy_policy", (req, res) => {
    getProfileController.privacyPolicy(req, res)
})

app.get("/profilePage/terms", (req, res) => {
    getProfileController.terms(req, res)
})

app.get("/profilePage/faq", (req, res) => {
    getProfileController.faq(req, res)
})

app.get("/profilePage/report", (req, res) => {
    getProfileController.report(req, res)
})

app.post("/profilePage/reportRequest", (req, res) => {
    getProfileController.reportRequest(req, res)
})

app.get("/profilePage/login_alert", (req, res) => {
    getProfileController.loginAlert(req, res)
})

app.get("/profilePage/logout", (req, res) => {
    getProfileController.logout(req, res)
})


// Vendor Routes
app.get("/vendors/login", (req, res) => {
    getvendorAuthController.login(req, res)
})
app.post("/vendors/login", (req, res) => {
    getvendorAuthController.loginAuth(req, res)
})

app.get("/vendors/index", (req, res) => {
    getdashboardController.index(req, res)
})

app.get("/vendors/product-list", (req, res) => {
    getVendorProductController.Allproducts(req, res)
})

app.get("/vendors/add-product", (req, res) => {
    getVendorProductController.addProduct(req, res)
})

app.post("/vendors/add-product", upload2.array("images", 6), (req, res) => {
    getVendorProductController.addProductData(req, res)
})

// Authentication routes
app.get("/login", (req, res) => {
    getAuthenticationController.loginPage(req, res);
});

app.post("/loginAuthentication", (req, res) => {
    getAuthenticationController.loginAuthentication(req, res);
});

// =========================
// SERVER CONFIGURATION
// =========================
app.get("*", function (req, res) {
    return res.status(404).render("404", {
        status: "Error",
        message: "404 Page Not Found!"
    })
})
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server connected on port ${PORT}`);
});
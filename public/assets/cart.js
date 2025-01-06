let quantityValues = document.querySelectorAll('.quantityValue')
let productPrices = document.querySelectorAll('.product_price')
let currentPrices = document.querySelectorAll(".current_price")
var minusBtn = document.querySelectorAll('.minusBtn')
var plusBtn = document.querySelectorAll('.plusBtn')
var deleteBtn = document.querySelectorAll('.deleteBtn')
var cart_id = document.querySelectorAll('.cart_id')
var totalPrice = document.getElementById("totalPrice")
var currencyText = document.querySelectorAll(".currencyText")[0]
var currencyText2 = document.querySelector("#currencyText2")
var cart_items = document.querySelectorAll(".cart-items")
var posted_by = document.querySelectorAll(".posted_by")
var product_id = document.querySelectorAll(".product_id")
var empty_cart_image = document.getElementById("empty_cart_image")
var footer_cart = document.getElementById("footer-cart")

currencyText2.textContent = currencyText.textContent



for (let i = 0; i < plusBtn.length; i++) {
    plusBtn[i].addEventListener('click', function () {
        let quantityValue = quantityValues[i]
        let currentPrice = currentPrices[i]
        let productPrice = productPrices[i]

        // Increment the quantity
        let newValue = parseInt(quantityValue.textContent) + 1
        quantityValue.textContent = newValue

        // Calculate and update the new price
        let calculatedPrice = currentPrice.textContent * newValue
        productPrice.textContent = calculatedPrice.toFixed(2)

        addToCart(product_id[i].textContent, posted_by[i].textContent, quantityValue.textContent, productPrice.textContent)
        updatePrice()

    })
}

for (let i = 0; i < minusBtn.length; i++) {
    minusBtn[i].addEventListener('click', function () {
        let quantityValue = quantityValues[i]
        let currentPrice = currentPrices[i]
        let productPrice = productPrices[i]

        // Increment the quantity
        let newValue = parseInt(quantityValue.textContent) - 1
        if (newValue < 1) newValue = 1
        quantityValue.textContent = newValue


        // Calculate and update the new price
        let calculatedPrice = currentPrice.textContent * newValue
        productPrice.textContent = calculatedPrice.toFixed(2)

        addToCart(product_id[i].textContent, posted_by[i].textContent, quantityValue.textContent, productPrice.textContent)
        updatePrice()

    })
}

function addToCart(id, posted_by, quantity, cart_price) {
    const cartData = {
        product_id: id,
        posted_by: posted_by,
        quantity: quantity,
        cart_price: cart_price,
    }
    fetch("/addToCart", {
            method: "POST",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(cartData)
        })
        .then(response => response.json())
        .then(data => {
            alertNotification(data.status, data.message)
            updatePrice()
        })
}


for (let i = 0; i < deleteBtn.length; i++) {
    deleteBtn[i].addEventListener('click', function () {
        const cartId = cart_id[i].textContent;
        const cartData = { id: cartId };

        fetch("/deleteCart", {
            method: "POST",
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(cartData)
        })
        .then(response => response.json())
        .then(data => {
            alertNotification(data.status, data.message);

            // Remove the cart item from the DOM
            cart_items[i].remove();

            // Recalculate the total price after removing the item
            updatePrice();

            // Check if there are any remaining cart items
            const remainingItems = document.querySelectorAll('.cart-items').length;
            if (remainingItems === 0) {
                empty_cart_image.style.display = 'block';
                footer_cart.style.display = 'none';
            }
        });
    });
}



function updatePrice() {
    let tPrice = 0;

    // Recalculate total price with updated cart items
    const currentCartItems = document.querySelectorAll('.cart-items');
    currentCartItems.forEach(item => {
        const productPrice = parseFloat(item.querySelector('.product_price').textContent);
        const quantity = parseInt(item.querySelector('.quantityValue').textContent);
        tPrice += productPrice * quantity;
    });

    // Update the total price in the DOM
    totalPrice.textContent = tPrice.toFixed(2);
    console.log(totalPrice.textContent);
}

updatePrice()
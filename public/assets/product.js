let quantityValue = document.querySelector('#quantityValue')
let product_price = document.querySelector('#product_price')
let posted_by = document.getElementById("posted_by")
let currenct_price = document.getElementById('product_price').textContent //this refers to the static price thats is used for the calculation 
let product_id = document.getElementById('product_id')
let product_description = document.getElementById("product_description").textContent
let product_name = document.getElementById("product_name").textContent
let vendors_phone_number = document.getElementById("vendors_phone_number").textContent
let currency = document.getElementById("currency").textContent
let ref_id = document.getElementById("ref_id").textContent


let newValue = 1
let i = 1

function plusButton(value) {
    newValue += value
    quantityValue.textContent = newValue
    let calulatedPirce = newValue * parseFloat(currenct_price)
    product_price.textContent = calulatedPirce.toFixed(2)

    // addToCart(product_id.textContent, posted_by.textContent, quantityValue.textContent, product_price.textContent)

}

function minusButton(value) {
    if (quantityValue.textContent <= 1) {
        quantityValue.textContent = value
    } else {
        newValue -= value
        quantityValue.textContent = newValue
        let calulatedPirce = newValue * parseFloat(currenct_price)
        product_price.textContent = calulatedPirce.toFixed(2)

        // addToCart(product_id.textContent, posted_by.textContent, quantityValue.textContent, product_price.textContent)

    }
}

function whatsappOrder() {
    const tel = vendors_phone_number
    let OrderProductName = product_name
    let Orderprice = currency+""+product_price.textContent
    let OrderCurrentPrice = currency+""+currenct_price
    let OrderQuantity = quantityValue.textContent;
    let OrderDescription = product_description
    let product_url = window.location.href
    


    const message = `*Order Details:* 

    Product ID: ${ref_id} 

    Product Name: ${OrderProductName} 

    Price: ${OrderCurrentPrice} 

    Quantity: ${OrderQuantity} 

    Total Price: ${Orderprice} 

    Description: ${OrderDescription}`;

    // Use encodeURIComponent to safely encode the message
    const whatsappUrl = `https://wa.me/${tel}?text=${encodeURIComponent(message)}`;
    
    // Redirect to the WhatsApp URL
    window.location.href = whatsappUrl;
    
}

function addToCart() {
    const cartData = {
        product_id: product_id.textContent,
        posted_by: posted_by.textContent,
        quantity: quantityValue.textContent,
        cart_price: product_price.textContent,
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
    })
}





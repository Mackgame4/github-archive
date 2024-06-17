require("dotenv").config()

const express = require("express")
const app = express()
const cors = require("cors")
app.use(express.json())
app.use(
  cors({
    origin: "http://localhost:8080",
  })
)
/*app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
})*/

const stripe = require("stripe")(process.env.STRIPE_SK)

const storeItems = new Map([
  /*[1, { priceInCents: 10000, name: "Learn React Today" }],
  [2, { priceInCents: 20000, name: "Learn CSS Today" }],*/
])

const processingSessions = []

app.post("/sendCurrentProducts", async (req, res) => {
  try {
    req.body.products.map(product => {
      if (product.price.sale !== undefined && product.price.sale !== null && product.price.sale !== 0 && product.price.sale !== '' && product.price.sale !== '0') {
        storeItems.set(product.id, { priceInCents: parseInt(product.price.sale*100), name: product.title })
      } else {
        storeItems.set(product.id, { priceInCents: parseInt(product.price.regular*100), name: product.title })
      }
    })
    res.status(200).json({ ok: true })
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

app.post("/create-checkout-session", async (req, res) => {
  try {
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ["card"],
      mode: "payment",
      shipping_address_collection: {
        allowed_countries: ['PT', 'ES', 'BG', 'LU', 'RO', 'CZ', 'FR', 'HU', 'SI', 'DK', 'HR', 'MT', 'SK', 'DE', 'IT', 'NL', 'FI', 'EE', 'CY', 'AT', 'SE', 'IE', 'LV', 'PL'],
      },
      shipping_options: [
        {
          shipping_rate_data: {
            type: 'fixed_amount',
            fixed_amount: {
              amount: 500,
              currency: 'eur',
            },
            display_name: 'Taxa fixa de envio',
            delivery_estimate: {
              minimum: {
                unit: 'business_day',
                value: 5,
              },
              maximum: {
                unit: 'business_day',
                value: 7,
              },
            }
          }
        },
      ],
      line_items: req.body.items.map(item => {
        const storeItem = storeItems.get(item.id)
        return {
          price_data: {
            currency: "eur",
            product_data: {
              name: storeItem.name,
            },
            unit_amount: storeItem.priceInCents,
          },
          quantity: item.quantity,
        }
      }),
      success_url: `${process.env.HOST}/checkout/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${process.env.HOST}/store`,
    })
    processingSessions.push({ sessionID: session.id, cartItemList: req.body.cartItemList, uid: req.body.uid })
    res.status(200).json({ url: session.url })
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

app.post("/fetchSessionID", async (req, res) => {
  try {
    //console.log('fetchSessionID', processingSessions, req.body.session_id)
    var successfulCheckout = false
    for (let i = 0; i < processingSessions.length; i++) {
      if (processingSessions[i].sessionID === req.body.session_id) {
        const session = await stripe.checkout.sessions.retrieve(req.body.session_id);
        //const customer = await stripe.customers.retrieve(session.customer);
        //console.log('fetchSessionID', session, customer)
        if (session.status === 'complete') {
          successfulCheckout = true
        }
        console.log('successfulCheckout', successfulCheckout)
        res.status(200).json({ session: session, successfulCheckout: successfulCheckout, cartItemList: processingSessions[i].cartItemList, uid: processingSessions[i].uid })
        if (session.status === 'complete') {
          processingSessions.splice(i, 1)
        }
      }
    }
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})

app.listen(3000)

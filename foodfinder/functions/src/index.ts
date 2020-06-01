import * as functions from 'firebase-functions';
// import { admin } from 'firebase-admin/lib/database';
import * as request from 'request-promise';

// exports.addMessage = functions.https.onRequest(async (req, res) => {
//     const original = req.query.text;

//     const snapshot = await admin.
// });

exports.GetRestaurants = functions.https.onRequest(
    async(req, res) => {
        //res.send(functions.config().yelp.key);
        var baseUrl = 'https://api.yelp.com/v3/businesses/search';
        var url = baseUrl + 
        "?latitude=" + req.query.lat + 
        "&longitude=" + req.query.lng + 
        "&categories=restaurants" + 
        "&radius=3000" + 
        "&limit=10";

        //res.send(url);
        request.get({
            url: url,
            headers: {
                'Authorization' : `Bearer ${functions.config().yelp.key}`
            }
        }, (error, response) => {
            if (error) {

            } else {
                if (response.statusCode != 200) {
                        
                } else {
                    res.send(response);
                }
            }
        })
    }
)
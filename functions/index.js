/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// functions/index.js

const { onRequest } = require("firebase-functions/v2/https");
const fetch = require("node-fetch");

exports.getDirections = onRequest(
  { secrets: ["GOOGLE_MAPS_API_KEY"] },
  async (req, res) => {
    const origin = req.query.origin;
    const destination = req.query.destination;
    const waypoints = req.query.waypoints;
    const mode = req.query.mode || "driving";

    const key = process.env.GOOGLE_MAPS_API_KEY;

    const url = `https://maps.googleapis.com/maps/api/directions/json?origin=${origin}&destination=${destination}&waypoints=${waypoints}&mode=${mode}&key=${key}`;

    console.log("🔥 요청 URL:", url);

    try {
      const response = await fetch(url);
      const data = await response.json();
      console.log("📦 Google 응답:", data);

      res.set("Access-Control-Allow-Origin", "*");
      res.status(200).json(data);
    } catch (err) {
      console.error("❌ API 요청 실패:", err);
      res.status(500).send("Error calling Google Directions API.");
    }
  }
);

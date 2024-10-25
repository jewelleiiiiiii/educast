/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const { onRequest } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

// Initialize Firebase Admin
admin.initializeApp();

// Define the list of allowed admin UIDs
const allowedUids = [
   'nsYEw4vqkyUhD5L2fgJwYHXZA2T2',
   '9pNIBaQnd2eWoQryRRmT9vIb4Dw1'
];

exports.deleteUser = onRequest(async (request, response) => {
    // Check if the user making the request is authenticated
    const requesterUid = request.auth ? request.auth.uid : null; // Get the requesting user's UID

    if (!requesterUid) {
        response.status(403).send('Only authenticated users can delete accounts.');
        return;
    }

    const authId = request.body.authId; // Get authId from the request body

    try {
        // Check if the user is deleting their own account
        if (requesterUid === authId) {
            // Delete the user from Firebase Authentication
            await admin.auth().deleteUser(authId);
            response.status(200).send(`Your account has been deleted successfully.`);
        }
        // Check if the user is an admin and trying to delete another account
        else if (allowedUids.includes(requesterUid)) {
            // Delete the user from Firebase Authentication
            await admin.auth().deleteUser(authId);
            response.status(200).send(`User with authId ${authId} deleted successfully.`);
        }
        else {
            response.status(403).send('You do not have permission to delete this account.');
        }
    } catch (error) {
        response.status(500).send(`Failed to delete user: ${error.message}`);
    }
});


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

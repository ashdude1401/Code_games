//Push Notification Service for sending push notifications to users using FCM

const admin = require('firebase-admin');

// Fetch the service account key JSON file contents
const serviceAccount = require('../config/firebaseServiceAccountKey.json');

// Initialize the app with a service account, granting admin privileges
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const sendNotification =async (deviceToken,message,topic=null)=>{
    // Send a message to the device corresponding to the provided
    // registration token.
    const payload = {
        notification: {
          title:message.title,
          body: message.body,
        },
        token: deviceToken,
      };
      if(topic==null){
        try{
           await admin.messaging().send(payload);
           logger.info('Notification sent successfully:', message);
        }
        catch(err){
            logger.error('Error in sending notification: ', err);
        }
      }else{
        admin.messaging().sendToTopic(topic,payload);
      }
}

exports.sendNotification = sendNotification;
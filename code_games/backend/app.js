
//importing all required dependencies
const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const sendNotification = require('./services/NotificationService/sendNotification');
const loggerMiddleware = require('./middlewares/loggerMiddleware');


//setting up middlewares
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(loggerMiddleware);





//setting up the port
const port = process.env.PORT || 3000;

app.listen(port,()=>{
    console.log(`Server started on port ${port}`);
})



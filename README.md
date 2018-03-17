# facial-recognition
Raspberry pi project

- Raspberry pi connected to camera module uploads the image to the app 
- app will then make a call to rekognition API to get the Smile confidence level
- Based on the confidence level the app will make a sound to brighten up the mood

Usage:
//Requirements
//node js

npm install //installs all the required packages

node app.js


------

App runs on port 8089

Test:

Upload an image to localhost:8089/upload with header 'multipart/form-data' and file key: image_file 

returns confidence level

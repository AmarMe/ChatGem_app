
## ChatGem - AI chatBot Mobile App

This repository contains the source code and necessary resources for a chat bot mobile application developed using **Flutter** for the frontend, **Node.js** with **Express** for the backend server, **MongoDB** as the database, and integration with **Google Gemini models API** to generate response for our queries, tasks. 

Backend Server (Node.js with Express): The backend server for the chat bot functionality resides in a separate repository. Find the server code at [Backend Server Repository](https://github.com/AmarMe/ChatGem-Node_server.git).
## Overview
The chat bot mobile app is designed to provide a seamless and interactive messaging experience.  It uses two models of Google's Gemini API. One is Gemini-pro which accepts text as input and text as output and used for multi-turn chatting feature and another one is Gemini-vision-pro used to get  details Or insights of the image you provided. It accepts Image with text as input and text as output.
## Deployment

To deploy this project run

1. Get API Key at [here](https://makersuite.google.com/app/apikey)

2. Clone backend repo
 ```bash
  git clone https://github.com/AmarMe/ChatGem-Node_server.git
```
3. create a .env file and save your apikey and create DB in mongodb and save mongoDB URI 

```bash
  Geminiapikey= "paste your API key here" 
  Mongo_URI   = "paste your mongoDB uri here"
```
4. install npm packages
```bash
  npm install 
```
5. Run the server
```bash
  node index.js  
```
6. Clone frontend repo and run the project in a code editor
 ```bash
  git clone https://github.com/AmarMe/ChatGem_app.git
```


## Screenshots

<img width="220" alt="splash screen" src="https://github.com/AmarMe/ChatGem_app/assets/123172989/1a044efb-e728-41b5-8d66-e5d3ee44a174"> 
<img width="228" alt="Homepage" src="https://github.com/AmarMe/ChatGem_app/assets/123172989/4a875e71-6ff9-4980-9cc1-5c7784208338">
<img width="228" alt="multiturn chat" src="https://github.com/AmarMe/ChatGem_app/assets/123172989/f431f32a-db56-427f-bd7e-07b75d1a7b1b">
<img width="228" alt="Imageand text model_1" src="https://github.com/AmarMe/ChatGem_app/assets/123172989/eaf1e1d1-3464-4d0e-a90c-a9ff677e28b4">
<img width="228" alt="Imageand text model_2" src="https://github.com/AmarMe/ChatGem_app/assets/123172989/8490b3e1-eab5-4e72-8d49-ce36d3c7df17">


## Tech Stack

### Client: *Flutter* 

  Utilizes Flutter framework to create a visually appealing and responsive mobile app interface.

### Server: *NodeJS, ExpressJS*
    
  Employs Node.js along with the Express framework to manage server-side functionalities and handle incoming requests from the mobile app.

### Database: *MongoDB*

  To store the images which sent from the Image with text feature in the mobile app and stored as a Buffer(base64) datatype 

### API Integration: *Google's Gemini API*

This project is powered by two Gemini LLM models.
[Gemini-pro](https://deepmind.google/technologies/gemini/#introduction) and 
[Gemini-vision-pro](https://deepmind.google/technologies/gemini/#introduction)




## Acknowledgements

 - [Gemini API Doc](https://ai.google.dev/tutorials/web_quickstart#set-up-project)
 - [Flutter packages](https://pub.dev/publishers/flutter.dev/packages)
 

# NewsApp
## Description
Simple iPhone App to show News Items from https://newsapi.org/
## Version Support
* iOS 10.0 and above

## Features

1. News List Screen
 * Displays List of News Items
 * Displays image and News Title
 * Pull to Refresh feature to download latest news

2. Details Screen :
 * Displays News Image, Title, Content, Description, Author and Published Date
 * Button to open the orignal article on browser
 
## App Setup
To run the app, need to create an account on https://newsapi.org/ and get API key. You need to add the key in NetworkConstants as API_KEY
 
## App Architecture
MVVM Architecture

## Tests
Test Cases are added for the logical parts which includes:
* Network Connectivity
* Parsing of JSON Response
* Date formatters
* Image Caching

 ## Dependencies
 There are no external dependencies to the project.


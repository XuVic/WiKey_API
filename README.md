# WiKey

The Web API for the WiKey Application
https://wikeyapp.herokuapp.com/

[ ![Codeship Status for XuVic/WiKeyAPI](https://app.codeship.com/projects/d1dfde20-b314-0135-e64c-725c6ee79220/status?branch=master)](https://app.codeship.com/projects/258181)


## Routes

Our API is rooted at /api/v0.1/ and has the following subroutes:
  * `GET topic/topic_name` - Get information of topic you choose in Database
 
  * `POST topic/topic_name` - Store information of topic from other API into database
  
  * `GET topics` - Index of all topics stored
  
  * `GET summaries_percent/topic_name/catalog_name/percentage` - Get summaried paragraph of topic with specific percentage.
 

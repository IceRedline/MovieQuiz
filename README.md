# **MovieQuiz**

MovieQuiz is an application with quizzes about films from the top 250 ratings and the most popular films according to IMDb.

![MovieQuiz Preview](https://github.com/user-attachments/assets/cf32fe0e-033e-47dd-ac01-fdbfb892972c)

## **Links**

[API IMDb](https://imdb-api.com/api#Top250Movies-header)

[Fonts](https://code.s3.yandex.net/Mobile/iOS/Fonts/MovieQuizFonts.zip)

## **Application Description**

- A one-page application with quizzes about films from the top 250 ratings and the most popular films on IMDb. The app user consistently answers questions about the rating of the movie. At the end of each round of the game, statistics are shown on the number of correct answers and the user's best results. The goal of the game is to answer all 10 questions of the round correctly.

## **Functional description**

- A splash screen is shown when the app is launched;
- After launching the application, a question screen is shown with the text of the question, a picture and two possible answers, “Yes” and “No”, only one of them is correct.;
- The quiz question is based on the IMDb rating of the film on a 10-point scale, for example: "Is the rating of this film more than 6?";
- You can click on one of the possible answers to a question and get a response about whether it is correct or not, while the photo frame will change color to the appropriate one.;
- After selecting the answer to a question, the next question automatically appears after 1 second.;
- After completing a round of 10 questions, an alert appears with user statistics and the opportunity to play again.;
- Statistics contain: the result of the current round (the number of correct answers out of 10 questions), the number of quizzes played, the record (the best result of the round in the session, the date and time of this round), statistics of quizzes played as a percentage (average accuracy);
- The user can start a new round by clicking on the "Play again" button in the alert;
- If it is impossible to download the data, the user sees an alert with a message that something went wrong, as well as a button that can be clicked to repeat the network request.

## **Technical features**

- The app supports iPhone devices with iOS 15, only portrait mode is provided.;
- Interface elements adapt to iPhone screen resolutions, starting with X — layout for SE and iPad is not provided;

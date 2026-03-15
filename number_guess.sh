#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"


INPUT_NAME() {
  echo -e "\n~~  Number Guessing Game  ~~\n"

  # get username input
  echo "Enter your username:"
  read USERNAME

  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

  if [[ $USER_ID ]]
  then
    # get frequency of games played
    GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id = $USER_ID")
    # get players best_guess
    BEST_GAME=$($PSQL "SELECT MIN(best_guess) FROM games WHERE user_id = $USER_ID")
    # welcome the player back
    echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  else
    # welcome the first time player
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
    # insert username into users table
    INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
    # get user id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
  fi

  GAME
}

# create a game part of code
GAME() {
  SECRET_NR=$(( $RANDOM % 1000 + 1 ))

  TRIES=0

  GUESSED=0

  echo -e "\nGuess the secret number between 1 and 1000:"

  while [[ $GUESSED = 0 ]]
  do
    read GUESS

    # if not a nr
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo -e "\nThat is not an integer, guess again:"
      TRIES=$(( $TRIES + 1))
    # if guess is secret nr
    elif [[ $GUESS == $SECRET_NR ]]
    then 
      TRIES=$(( $TRIES + 1))
      echo "You guessed it in $TRIES tries. The secret number was $SECRET_NR. Nice job!"

      # insert into database
      INSERT_GUESS_RESULT=$($PSQL "INSERT INTO games(user_id, best_guess) VALUES($USER_ID, $TRIES)")
      GUESSED=1
      exit
    # if guess is lower than secret nr
    elif [[ $GUESS -lt $SECRET_NR ]]
    then
      TRIES=$(( $TRIES + 1))
      echo -e "It's higher than that, guess again:"
    # if guess is higher than secret nr
    else
      TRIES=$(( $TRIES + 1))
      echo -e "It's lower than that, guess again:"
    fi
  done

  echo -e "\nThanks for playing!"

} 

INPUT_NAME



#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

CHECK_USERNAME=$($PSQL "SELECT username FROM user_data WHERE username='$USERNAME'")

if [ -z $CHECK_USERNAME ]
then
  CREATE_USER=$($PSQL "INSERT INTO user_data(username) VALUES('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM user_data WHERE username='$USERNAME'")
  BEST_GAME_GUESSES=$($PSQL "SELECT best_game_guesses FROM user_Data WHERE username='$USERNAME'")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME_GUESSES guesses."
fi

RAND_NUM=$((1 + RANDOM % 1000))
echo "Guess the secret number between 1 and 1000:"
read GUESS
GUESS_COUNT=1
while [[ $GUESS -ne $RAND_NUM ]]
do
  GUESS_COUNT=$(($GUESS_COUNT+1))
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    read GUESS
  elif [[ $GUESS -gt $RAND_NUM ]]
  then
    echo "It's lower than that, guess again:"
    read GUESS
  elif [[ $GUESS -lt $RAND_NUM ]]
  then
    echo "It's higher than that, guess again:"
    read GUESS
  fi
done

echo "You guessed it in $GUESS_COUNT tries. The secret number was $RAND_NUM. Nice job!"
UPDATE_PLAYED_GAMES=$($PSQL "UPDATE user_data SET games_played=games_played+1 WHERE username='$USERNAME'")
QUERY_BEST_GAME_GUESSES=$($PSQL "SELECT best_game_guesses FROM user_data WHERE username='$USERNAME'")
if [[ $GUESS_COUNT -lt $QUERY_BEST_GAME_GUESSES ]]
then
  UPDATE_GUESSES=$($PSQL "UPDATE user_data SET best_game_guesses=$GUESS_COUNT WHERE username='$USERNAME'")
fi




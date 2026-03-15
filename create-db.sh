#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# create a database for all number guesses
CREATE DATABASE number_guess;

# create table to record the guessing games
echo $($PSQL "CREATE TABLE games()")
echo $($PSQL "ALTER TABLE games ADD COLUMN game_id SERIAL PRIMARY KEY")
echo $($PSQL "ALTER TABLE games ADD COLUMN user_id INT NOT NULL")
echo $($PSQL "ALTER TABLE games ADD COLUMN best_guess INT DEFAULT 0 NOT NULL")

# create table to record the users
echo $($PSQL "CREATE TABLE users()")
echo $($PSQL "ALTER TABLE users ADD COLUMN user_id SERIAL PRIMARY KEY")
echo $($PSQL "ALTER TABLE users ADD COLUMN username VARCHAR(22) NOT NULL")
echo $($PSQL "ALTER TABLE users ADD COLUMN games_freq INTEGER DEFAULT 0 NOT NULL")
echo $($PSQL "ALTER TABLE users ADD CONSTRAINT username UNIQUE(username)")
echo $($PSQL "ALTER TABLE games ADD FOREIGN KEY(user_id) REFERENCES users(user_id)")

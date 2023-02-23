#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games,teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do 
if [[ $YEAR != 'year' ]]
then
WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER' ")"
#IF WINNER IS NOT FOUND
  if [[ -z $WINNER_ID ]]
  then
    INSERT_TEAM_RESULT="$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")"
    #new winner Id
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER' ")"
    echo $INSERT_TEAM_RESULT
  fi #if of not found winnter 
OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
# if OPPONENT IS NOT FOUND 
  if [[ -z $OPPONENT_ID ]]
  then 
    INSERT_TEAM_OPPONENT="$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")"
    #New opponet ID
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    echo $INSERT_TEAM_OPPONENT
  fi #if not fount opponent 

INSERT_GAMES="$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ('$YEAR','$ROUND',$WINNER_ID,$OPPONENT_ID,'$WINNER_GOALS','$OPPONENT_GOALS')")"
echo  $INSERT_GAMES

fi #if of year
done

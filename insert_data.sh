#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != winner ]] 
    then WINNER_INS=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $WINNER_INS ]]
      then WINNER_INS_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')") 
        if [[ WINNER_INS_RESULT=='INSERT 0 1' ]]
          then echo "Inserted into teams, $WINNER"
        fi
    fi
  fi
  if [[ $OPPONENT != opponent ]] 
    then OPPONENT_INS=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_INS ]]
      then OPPONENT_INS_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')") 
        if [[ OPPONENT_INS_RESULT=='INSERT 0 1' ]]
          then echo "Inserted into teams, $OPPONENT"
        fi
    fi
  fi

  if [[ $YEAR != year ]]
  then 
    WINNER_ID_LOOKUP=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID_LOOKUP=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID_LOOKUP', '$OPPONENT_ID_LOOKUP', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  fi 



done

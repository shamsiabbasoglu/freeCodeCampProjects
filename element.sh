#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi



if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number=$1")
else
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol='$1' OR name='$1'")
fi

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
else
  IFS="|" read ATOMIC_NUMBER SYMBOL NAME <<< "$ELEMENT"
  PROPERTIES=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, t.type FROM properties p INNER JOIN types t ON p.type_id=t.type_id WHERE atomic_number=$ATOMIC_NUMBER")

  IFS="|" read ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< "$PROPERTIES"

  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi

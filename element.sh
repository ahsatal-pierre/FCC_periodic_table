#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ -z "$1" ]; then
    echo "Please provide an element as an argument."
    exit 
fi

# accept atomic number as argument
if [[ $1 =~ ^[0-9]+$ ]]
then
QUERY_ATOM_NUM=$($PSQL "SELECT symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = '$1'")

   if [ -z "$QUERY_ATOM_NUM" ]; then
        echo "I could not find that element in the database."
        exit 
    fi


echo "$QUERY_ATOM_NUM" | while IFS='#|#' read -r SYMBOL NAME TYPE ATOMIC_MASS MELTING BOILING; do
    echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done

# accept  symbol as argument
elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
then
    QUERY_SYMBOL=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE lower(symbol) = lower('$1')")

   if [ -z "$QUERY_SYMBOL" ]; then
        echo "I could not find that element in the database."
        exit 
    fi


    echo "$QUERY_SYMBOL" | while IFS='|' read -r NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING BOILING; do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done

# accept name
else  
QUERY_NAME=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$1'")

   if [ -z "$QUERY_NAME" ]; then
        echo "I could not find that element in the database."
        exit 
    fi


echo "$QUERY_NAME" | while IFS='|' read -r NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING BOILING; do
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done
fi

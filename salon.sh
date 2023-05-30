#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~Danny's Hair Salon For Men~~~~"
echo "Welcome to Danny's Hair Salon For Men. What do you want?"
MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  SELECTION=$($PSQL "select * from services")
  echo "$SELECTION" | while read ID BAR SERVICE
  do
    echo "$ID) $SERVICE"
  done

  read SERVICE_ID_SELECTED
  
  CHECK=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")
  if
    [[ -z $CHECK ]]
  then
    MAIN_MENU "We could not find that service. Please choose a valid option."
    
  else
    echo -e "\nWhat is your phone number?"
    read CUSTOMER_PHONE
    PHONE_CHECK=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")
    
    if
      [[ -z $PHONE_CHECK ]]
    then
      echo -e "\nWhat is your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi
    GET_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")
    echo -e "\nWhat time would you like your$CHECK,$GET_NAME."
    read SERVICE_TIME
    
    GET_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
    X=$($PSQL "insert into appointments(customer_id, service_id, time) VALUES($GET_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo -e "\nI have put you down for a$CHECK at $SERVICE_TIME,$GET_NAME."
    
  fi
}

MAIN_MENU

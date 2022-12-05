#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c"

MAIN_MENU(){
DISPLAY_SERVICES=$($PSQL "SELECT service_id, name FROM services")
echo -e "$DISPLAY_SERVICES\n" | while read SERVICE_ID BAR NAME
do
  if [[ $SERVICE_ID ]]
  then
    echo -e "$SERVICE_ID) $NAME"
  fi
done
}

MAIN_MENU

echo -e "\nPick a service"
read SERVICE_ID_SELECTED

PICKED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
# if service doesn't exist
if [[ -z $PICKED_SERVICE ]]
then
  # return to service list
  MAIN_MENU
fi

echo -e "\nInput your phone number"
read CUSTOMER_PHONE

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
#if phone entry doesn't exist
if [[ -z $CUSTOMER_ID ]]
then
  echo -e "\nYou are new here, please input your name"
  read CUSTOMER_NAME
  #inserting new customer in database
  NEW_CUST=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
fi

echo -e "\nWhat time would you like to be serviced?"
read SERVICE_TIME
#inserting new appointment
NEW_APP=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
echo -e "\nI have put you down for a$PICKED_SERVICE at $SERVICE_TIME,$CUSTOMER_NAME."
exit
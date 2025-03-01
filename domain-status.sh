#!/bin/bash

# Exit on error and undefined variables
set -euo pipefail

############################################################################
##  Variables                                                             ##
############################################################################

RAPIDAPI_HOST='domainr.p.rapidapi.com'
RAPIDAPI_KEY='REPLACE_ME'

############################################################################
##  Script                                                                ##
############################################################################

# Check Status and Send Slack Messages
while IFS= read -r domain || [[ -n "$domain" ]]; do

    # Trim any trailing whitespace or special characters
    domain=$(echo -n "$domain" | tr -d '\r')

    # Print domain with proper alignment
    printf "%-30s" "$domain"

    # Perform the API request once
    response=$(curl -Ss --fail --request GET \
        --url "https://${RAPIDAPI_HOST}/v2/status?domain=${domain}" \
        --header "x-rapidapi-host: ${RAPIDAPI_HOST}" \
        --header "x-rapidapi-key: ${RAPIDAPI_KEY}")

    # Check if curl failed
    if [[ $? -ne 0 ]]; then
        status="API_ERROR"
    else
        status=$(echo "$response" | jq -r '.status[0].status' 2>/dev/null)
    fi

    # Print the status with a tab for alignment
    printf "\t%s\n" "$status"

done < domains.txt

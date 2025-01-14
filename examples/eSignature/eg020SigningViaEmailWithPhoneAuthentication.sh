# Check that we're in a bash shell
if [[ $SHELL != *"bash"* ]]; then
  echo "PROBLEM: Run these scripts from within the bash shell."
fi

source ./examples/eSignature/lib/utils.sh


# Obtain your OAuth token
# Note: Substitute these values with your own
ACCESS_TOKEN=$(cat config/ds_access_token.txt)

#Set up variables for full code example
# Note: Substitute these values with your own
account_id=$(cat config/API_ACCOUNT_ID)

base_path="https://demo.docusign.net/restapi"

# temp files:
request_data=$(mktemp /tmp/request-eg-001.XXXXXX)
response=$(mktemp /tmp/response-eg-001.XXXXXX)
doc1_base64=$(mktemp /tmp/eg-001-doc1.XXXXXX)

# Fetch doc and encode
cat demo_documents/World_Wide_Corp_lorem.pdf | base64 > $doc1_base64

# Construct your API headers
# Step 2 start
declare -a Headers=('--header' "Authorization: Bearer ${ACCESS_TOKEN}" \
					'--header' "Accept: application/json" \
					'--header' "Content-Type: application/json")
# Step 2 end					


# Obtain your workflow ID
# Create a temporary file to store
request_data=$(mktemp /tmp/request-idv.XXXXXX)

# Create a temporary file to store the response
echo ""
echo "Attempting to retrieve your account's workflow ID"
echo ""
response=$(mktemp /tmp/response-bs.XXXXXX)
# Step 3 start
Status=$(curl -w '%{http_code}' -i --request GET "https://demo.docusign.net/restapi/v2.1/accounts/${account_id}/identity_verification" \
     "${Headers[@]}" \
     --output ${response})

#If the Status code returned is greater than 201 (OK / Accepted), display an error message along with the API response. 
if [[ "$Status" -gt "201" ]] ; then
    echo ""
	echo "Unable to retrieve your account's workflow ID."
	echo ""
	cat $response
	exit 0
fi

echo ""
echo "Response:"
cat $response
echo ""

# Retrieve the workflow IDs from the API response and put them in an array.
workflowIds=`cat $response | grep -o -P '(?<=workflowId\":\").*?(?=\")'`
arrWorkflowIds=($workflowIds)

# Get the index of the Phone auth workflow based on name and use that index for workflowId. 
# Workflow name of phone auth is 'Phone Authentication'
workflowNames=`cat $response | grep -o -P '(?<=defaultName\":).*?(?=,)'`
element="Phone Authentication"

workflowId=$(GetWorkflowId "$workflowNames" "$element" "$workflowIds")
# Step 3 end

if [ "$workflowId" == false ]; then
	echo ""
	echo "Please contact Support to enable recipient phone authentication in your account."
	echo ""
	exit 0
else
	echo ""
	echo "workflowId: " $workflowId
	echo ""
fi	

# Remove the temporary files
rm "$request_data"
rm "$response"

# Construct your envelope JSON body
# Create a temporary file to store the JSON body

GetSignerPhoneNum

request_data=$(mktemp /tmp/request-cw.XXXXXX)
# Step 4 start
printf \
'{
	"documents": [{
        "documentBase64": "' > $request_data
        cat $doc1_base64 >> $request_data
        printf '",
        "name": "Lorem Ipsum",
        "fileExtension": "pdf",
        "documentId": "1"
	}],
	"emailBlurb": "Sample text for email body",
	"emailSubject": "Please Sign",
	"envelopeIdStamping": "true",
	"recipients": {
		"signers": [{
			"name": "'"${SIGNER_NAME}"'",
			"email": "'"${SIGNER_EMAIL}"'",
			"roleName": "",
			"note": "",
			"routingOrder": 3,
			"status": "created",
			"tabs": {
				"signHereTabs": [{
					"documentId": "1",
					"name": "SignHereTab",
					"pageNumber": "1",
					"recipientId": "1", 
					"tabLabel": "SignHereTab",
					"xPosition": "200",
					"yPosition": "170"
				}]
			},
			"templateAccessCodeRequired": null,
			"deliveryMethod": "email",
			"recipientId": "1",
			"identityVerification":{
				"workflowId":"'"${workflowId}"'",
				"steps":null,"inputOptions":[
					{"name":"phone_number_list",
					"valueType":"PhoneNumberList",
					"phoneNumberList":[
						{
							"countryCode":"'"${SIGNER_PHONE_COUNTRY}"'",
							"number":"'"${SIGNER_PHONE_NUMBER}"'"
						}
						]
					}]
				}			
			}]
		},
	"status": "Sent"
}
' >> $request_data					
# Step 4 end

# a) Make a POST call to the createEnvelopes endpoint to create a new envelope.
# b) Display the JSON structure of the created envelope
echo ""
echo "Request:"
echo ""
cat $request_data
# Create a temporary file to store the response
response=$(mktemp /tmp/response-cw.XXXXXX)
# Step 5 start
curl --request POST "https://demo.docusign.net/restapi/v2.1/accounts/${account_id}/envelopes" \
     "${Headers[@]}" \
     --data-binary @${request_data} \
     --output ${response}
# Step 5 end

echo ""
echo "Response:"
cat $response
# Remove the temporary files
rm "$request_data"
rm "$response"

echo ""
echo ""
echo "Done."
echo ""

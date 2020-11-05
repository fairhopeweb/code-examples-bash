set -e

if [ ! -f "config/settings.txt" ]; then
    echo "Error: "
    echo "First copy the file 'config/settings.example.txt' to 'config/settings.txt'."
    echo "Next, fill in your API credentials, Signer name and email to continue."
    echo ""
    exit 1
fi

if [ -f "config/settings.txt" ]; then
    . config/settings.txt
fi

function resetToken() {
    rm -f config/ds_access_token* || true
}

function login() {
    echo ""
    PS3='Choose an OAuth Strategy: '
    select METHOD in \
        "Use_Authorization_Code_Grant" \
        "Use_JSON_Web_Token" \
        "Skip_To_APIs" \
        "Exit"; do
        case "$METHOD" in

        \
            Use_Authorization_Code_Grant)
            php ./OAuth/code_grant.php
            continu
            ;;

        Use_JSON_Web_Token)
            php ./OAuth/jwt.php
            continu
            ;;

        Skip_To_APIs)
            choices
            ;;

        Exit)
            exit 0
            ;;
        esac
    done

    mv ds_access_token.txt $token_file_name

    account_id=$(cat config/API_ACCOUNT_ID)
    ACCESS_TOKEN=$(cat $token_file_name)

    export ACCOUNT_ID
    export ACCESS_TOKEN
}

function choices() {
    echo ""
    PS3='Choose an API: '
    select METHOD in \
        "eSignature" \
        "Rooms" \
        "Home" \
        "Exit"; do
        case "$METHOD" in

        eSignature)
            startSignature
            choices
            ;;

        Rooms)
            startRoms
            choices
            ;;

        Home)
            login
            ;;
        Exit)
            exit 0
            ;;
        esac
    done
}

function startSignature() {
    echo ""
    PS3='Select the action : '
    select CHOICE in \
        "Embedded_Signing" \
        "Signing_Via_Email" \
        "List_Envelopes" \
        "Envelope_Info" \
        "Envelope_Recipients" \
        "Envelope_Docs" \
        "Envelope_Get_Doc" \
        "Create_Template" \
        "Use_Template" \
        "Send_Binary_Docs" \
        "Embedded_Sending" \
        "Embedded_Console" \
        "Add_Doc_To_Template" \
        "Collect_Payment" \
        "Envelope_Tab_Data" \
        "Set_Tab_Values" \
        "Set_Template_Tab_Values" \
        "Envelope_Custom_Field_Data" \
        "Signing_Via_Email_With_Access_Code" \
        "Signing_Via_Email_With_Sms_Authentication" \
        "Signing_Via_Email_With_Phone_Authentication" \
        "Signing_Via_Email_With_Knoweldge_Based_Authentication" \
        "Signing_Via_Email_With_IDV_Authentication" \
        "Creating_Permission_Profiles" \
        "Setting_Permission_Profiles" \
        "Updating_Individual_Permission" \
        "Deleting_Permissions" \
        "Creating_A_Brand" \
        "Applying_Brand_Envelope" \
        "Applying_Brand_Template" \
        "Bulk_Sending" \
        "Home"; do
        case "$CHOICE" in

        Home)
            login
            ;;
        Embedded_Signing)
            bash eg001EmbeddedSigning.sh
            startSignature
            ;;
        Signing_Via_Email)
            bash examples/eSignature/eg002SigningViaEmail.sh
            startSignature
            ;;
        List_Envelopes)
            bash examples/eSignature/eg003ListEnvelopes.sh
            startSignature
            ;;
        Envelope_Info)
            bash examples/eSignature/eg004EnvelopeInfo.sh
            startSignature
            ;;
        Envelope_Recipients)
            bash examples/eSignature/eg005EnvelopeRecipients.sh
            startSignature
            ;;
        Envelope_Docs)
            bash examples/eSignature/eg006EnvelopeDocs.sh
            startSignature
            ;;
        Envelope_Get_Doc)
            bash examples/eSignature/eg007EnvelopeGetDoc.sh
            constartSignature
            ;;
        Create_Template)
            bash examples/eSignature/eg008CreateTemplate.sh
            startSignature
            ;;
        Use_Template)
            bash examples/eSignature/eg009UseTemplate.sh
            startSignature
            ;;
        Send_Binary_Docs)
            bash examples/eSignature/eg010SendBinaryDocs.sh
            startSignature
            ;;
        Embedded_Sending)
            bash examples/eSignature/eg011EmbeddedSending.sh
            startSignature
            ;;
        Embedded_Console)
            bash examples/eSignature/eg012EmbeddedConsole.sh
            startSignature
            ;;
        Add_Doc_To_Template)
            bash examples/eSignature/eg013AddDocToTemplate.sh
            startSignature
            ;;
        Collect_Payment)
            bash examples/eSignature/eg014CollectPayment.sh
            startSignature
            ;;
        Envelope_Tab_Data)
            bash examples/eSignature/eg015EnvelopeTabData.sh
            startSignature
            ;;
        Set_Tab_Values)
            bash examples/eSignature/eg016SetTabValues.sh
            startSignature
            ;;
        Set_Template_Tab_Values)
            bash examples/eSignature/eg017SetTemplateTabValues.sh
            startSignature
            ;;
        Envelope_Custom_Field_Data)
            bash examples/eSignature/eg018EnvelopeCustomFieldData.sh
            startSignature
            ;;
        Signing_Via_Email_With_Access_Code)
            bash examples/eSignature/eg019SigningViaEmailWithAccessCode.sh
            startSignature
            ;;
        Signing_Via_Email_With_Sms_Authentication)
            bash examples/eSignature/eg020SigningViaEmailWithSmsAuthentication.sh
            startSignature
            ;;
        Signing_Via_Email_With_Phone_Authentication)
            bash examples/eSignature/eg021SigningViaEmailWithPhoneAuthentication.sh
            startSignature
            ;;
        Signing_Via_Email_With_Knoweldge_Based_Authentication)
            bash examples/eSignature/eg022SigningViaEmailWithKnoweldgeBasedAuthentication.sh
            startSignature
            ;;
        Signing_Via_Email_With_IDV_Authentication)
            bash examples/eSignature/eg023SigningViaEmailWithIDVAuthentication.sh
            startSignature
            ;;
        Creating_Permission_Profiles)
            bash examples/eSignature/eg024CreatingPermissionProfiles.sh
            startSignature
            ;;
        Setting_Permission_Profiles)
            bash examples/eSignature/eg025SettingPermissionProfiles.sh
            startSignature
            ;;
        Updating_Individual_Permission)
            bash examples/eSignature/eg026UpdatingIndividualPermission.sh
            startSignature
            ;;
        Deleting_Permissions)
            bash examples/eSignature/eg027DeletingPermissions.sh
            startSignature
            ;;
        Creating_A_Brand)
            bash examples/eSignature/eg028CreatingABrand.sh
            startSignature
            ;;
        Applying_Brand_Envelope)
            bash examples/eSignature/eg029ApplyingBrandEnvelope.sh
            startSignature
            ;;
        Applying_Brand_Template)
            bash examples/eSignature/eg030ApplyingBrandTemplate.sh
            startSignature
            ;;
        Bulk_Sending)
            bash examples/eSignature/eg031BulkSending.sh
            startSignature
            ;;
        *)
            echo "Default action..."
            startSignature
            ;;
        esac
    done
}

function startRoms() {
    echo ""
    echo "This is Start Rooms functions"
    choices
}

function continu() {
    echo "press the 'any' key to continue"
    read nothin
    choices
}

echo ""
echo "Welcome to the DocuSign Bash Launcher"
echo "using Authorization Code grant or JWT grant authentication."

login

#!/usr/bin/env bash

#Get the latest file from the directory
#FILE_NAME=$(ls -t1 ~/PycharmProjects/DLQSQSMessages/ | head -n 1)
FILE_NAME="potato.jpg"
#Printing the file name for reference
echo $FILE_NAME

#Uploading the file to S3 bucket
aws s3 cp $FILE_NAME s3://pi-challenge-move/$FILE_NAME > uploadresponse

UPLOAD_RESULT=$(awk ' {print $1} ' uploadresponse)

if [ $UPLOAD_RESULT == 'Completed' ]
then
    #call rekognition endpoint to get confidence level
    aws rekognition detect-faces --image '{"S3Object":{"Bucket":"pi-challenge-move","Name":"'"$FILE_NAME"'"}}' --attributes ALL > rekognition_response
    EMOTIONS=$(jq '.FaceDetails[0].Emotions' rekognition_response)
    FACEDETAILS=$(jq '.FaceDetails[0].Confidence' rekognition_response)
    if [ $FACEDETAILS == null ]
    then
        echo "No face detected"
    else
        i=0
        while (( $i -gt 3 ))
        do
            EMOTION=$(jq '.FaceDetails[0].Emotions['$i'].Type' rekognition_response)
            echo $EMOTION
            if [ $EMOTION == '"HAPPY"' ]
            then
                echo "Happiness is : $EMOTION"
                HAPPINESS=$(jq '.FaceDetails[0].Emotions['$i'].Confidence' rekognition_response)
                if [ ${HAPPINESS/.*} -gt 50 ]
                then
                    echo "Super mario!!"
                    #aplay wav
                i=50
                fi
            fi
            i=$(( i+1 ))
        done
    fi
 fi

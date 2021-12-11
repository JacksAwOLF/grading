#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "pass in the foldername of the student to grade"
    exit 0
fi

TEST_CASES_FOLDER=test_cases
SOLUTION_EXEC=~/../public/hw10/Driver

STUDENT_FOLDER=$1
CUR_FOLDER=`pwd`
cd $STUDENT_FOLDER
make
cd $CUR_FOLDER

#resultFile=${STUDENT_FOLDER}_missed
#echo > $resultFile

for testFile in `ls $TEST_CASES_FOLDER`;
do
    echo checking $testFile...
    test=$TEST_CASES_FOLDER/$testFile 
    $SOLUTION_EXEC < $test 1> solOut 2> solErr

    cd $STUDENT_FOLDER
    ./Driver < $CUR_FOLDER/$test 1> $CUR_FOLDER/stuOut 2> $CUR_FOLDER/stuErr
    cd $CUR_FOLDER

    outDiff=`diff solOut stuOut`
    if [[ $outDiff ]]; then
        echo -e "\toutput different!"
        echo -e "\tvimdiff solOut stuOut (type 'y' to proceed)?"
        read yea
        if [ "$yea" == "y" ]; then
            vimdiff solOut stuOut
        fi
    fi

    errDiff=`diff solErr stuErr`
    if [[ $errDiff ]]; then
        echo -e "\terror different!"
        echo -e "\tvimdiff solErr stuErr (type 'y' to proceed)?"
        read yea
        if [ "$yea" == "y" ]; then
            vimdiff solErr stuErr
        fi
    fi
done

rm solOut solErr stuOut stuErr

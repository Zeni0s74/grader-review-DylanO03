CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

if [[ -f student-submission/ListExamples.java ]]
then
    echo "ListExamples.java file found."
else
    echo "ListExamples.java file not found."
    echo "Grade: 0% | Counldn't run any tests"
    exit
fi

cp TestListExamples.java student-submission/ListExamples.java grading-area
cp -r lib grading-area

cd grading-area
javac -cp $CPATH *.java
if [[ $? -eq 0 ]]
then
    echo "Success! The exit code for the compile step is 0."
else
    echo "Oh no! The exit code for the compile step is $?."
    echo "Grade: 0% | Counldn't run any tests"
    exit
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > test-results.txt

results=$(tail -2 test-results.txt | head -n 1)

if [[ $results == *"OK"* ]]
then
    total_tests=$(echo "$results" | awk '{gsub("\\(","",$2); print $2}')
    echo "Congratulations, you got a full pass, all $total_tests tests passed."
    exit
else
    total_tests=$(echo "$results" | awk '{gsub(/,/,"",$3); print $3}')

    total_failures=$(echo "$results" | awk '{print $5}')

    total_successes=$(( $total_tests - $total_failures ))

    success_percentage=$(( $total_successes * 100 / $total_tests ))

    if [[ $success_percentage < 60 ]]
    then
        echo "Uh oh, you did not pass. Grade: $success_percentage% | $total_successes / $total_tests of tests passed"
    else
        echo "Congratulations, you passed. Grade: $success_percentage% | $total_successes / $total_tests of tests passed"
    fi
fi
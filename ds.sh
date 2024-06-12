a="Hello World!"

arr=("hi","world")

echo ${#arr}

echo ${#a}

numbers=()

numbers+=(10)
numbers+=(20)
numbers+=(30)

echo "The numbers in the array are: ${numbers[@]}"

data=()

data+=(10)
data+=(20)
data+=(30)

echo "${data[@]}"

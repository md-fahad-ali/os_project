#!/bin/bash

view_teacher_students() {
    # Define the file path
    local file_path="enrollment.txt"

    # Check if the file exists
    if [[ ! -f "$file_path" ]]; then
        echo "Error: The file $file_path does not exist."
        return 1
    fi

    # Declare an associative array to store student IDs and their courses
    declare -A enrollment_dict

    # Read the file line by line
    while IFS=, read -r student_id course; do
        # Skip empty lines
        [[ -z "$student_id" || -z "$course" ]] && continue

        # Add the course to the student's list of courses
        enrollment_dict["$student_id"]+="$course,"
    done < "$file_path"

    # Iterate through the associative array and format the output
    for student_id in "${!enrollment_dict[@]}"; do
        # Remove the trailing comma and sort courses
        courses=$(echo "${enrollment_dict[$student_id]}" | sed 's/,$//' | tr ',' '\n' | sort -u | tr '\n' ',' | sed 's/,$//')
        echo "$student_id | course:$courses"
    done
}

# Call the function to execute it
view_teacher_students

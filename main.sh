#!/bin/bash

STUDENT_FILE="students.txt"
TEACHER_FILE="teachers.txt"
STUDENT_ACCOUNTS_FILE="student_accounts.txt"
COURSES_FILE="courses.txt"
TEACHER_COURSES_FILE="teacher_courses.txt"
ENROLLMENT_FILE="enrollment.txt"

touch $STUDENT_FILE $TEACHER_FILE $STUDENT_ACCOUNTS_FILE $COURSES_FILE $TEACHER_COURSES_FILE $ENROLLMENT_FILE

check_password() {
    read -s -p "Enter password: " password
    echo
    if [ "$1" = "admin" ] && [ "$password" = "admin123" ]; then
        return 0
        elif [ "$1" = "teacher" ] && [ "$password" = "teacher123" ]; then
        return 0
        elif [ "$1" = "student" ] && [ "$password" = "$2" ]; then
        return 0
    else
        return 1
    fi
}

add_student() {
    read -p "Enter student name: " name
    read -p "Enter student ID: " student_id
    read -p "Enter student grade: " grade
    read -p "Enter course name: " course
    read -p "Enter department: " department
    echo "$name,$student_id,$grade,$course,$department" >> $STUDENT_FILE
    echo "$name,$student_id,student123" >> $STUDENT_ACCOUNTS_FILE
    echo "Student added successfully with default password 'student123'!"
    read -p "Press any key to continue..."
}


remove_student() {
    read -p "Enter student ID to remove: " student_id
    if grep -q "$student_id" $STUDENT_FILE; then
        grep -v "$student_id" $STUDENT_FILE > temp_file && mv temp_file $STUDENT_FILE
        grep -v "$student_id" $STUDENT_ACCOUNTS_FILE > temp_file && mv temp_file $STUDENT_ACCOUNTS_FILE
        grep -v "$student_id" $ENROLLMENT_FILE > temp_file && mv temp_file $ENROLLMENT_FILE
        echo "Student removed successfully!"
    else
        echo "Student ID not found!"
    fi
    read -p "Press any key to continue..."
}

view_students() {
    if [ -s $STUDENT_FILE ]; then
        echo "Students List:"
        column -t -s, $STUDENT_FILE
    else
        echo "No students found!"
    fi
    read -p "Press any key to continue..."
}

add_course_by_admin() {
    read -p "Enter course name: " course_name
    if grep -q "$course_name" $COURSES_FILE; then
        echo "Course already exists!"
    else
        echo "$course_name" >> $COURSES_FILE
        echo "Course added successfully!"
    fi
    read -p "Press any key to continue..."
}

assign_course_to_teacher() {
    read -p "Enter teacher ID: " teacher_id
    if grep -q "$teacher_id" $TEACHER_FILE; then
        read -p "Enter course name: " course_name
        if grep -q "$course_name" $COURSES_FILE; then
            echo "$teacher_id,$course_name" >> $TEACHER_COURSES_FILE
            echo "Course assigned to teacher successfully!"
        else
            echo "Course not found!"
        fi
    else
        echo "Teacher ID not found!"
    fi
    read -p "Press any key to continue..."
}

admin_menu() {
    while true; do
        clear
        echo "Admin Menu"
        echo "1. Add Student"
        echo "2. Remove Student"
        echo "3. View Students"
        echo "4. Add Course"
        echo "5. Assign Course to Teacher"
        echo "6. Exit"
        read -p "Enter your choice: " choice
        case $choice in
            1)
                clear
                add_student
            ;;
            2)
                clear
                remove_student
            ;;
            3)
                clear
                view_students
            ;;
            4)
                clear
                add_course_by_admin
            ;;
            5)
                clear
                assign_course_to_teacher
            ;;
            6)
                echo "Exiting..."
                clear
                exit
            ;;
            *)
                echo "Invalid option!"
                read -p "Press any key to continue..."
                clear
            ;;
        esac
    done
}

add_teacher() {
    read -p "Enter teacher name: " name
    read -p "Enter teacher ID: " teacher_id
    echo "$name,$teacher_id" >> $TEACHER_FILE
    echo "Teacher account created successfully!"
    read -p "Press any key to continue..."
}

teacher_login() {
    read -p "Enter teacher ID: " teacher_id
    if grep -q "$teacher_id" $TEACHER_FILE; then
        if check_password "teacher"; then
            echo "Login successful!"
            teacher_menu $teacher_id
        else
            echo "Incorrect password. Please try again."
            read -p "Press any key to continue..."
            clear
        fi
    else
        echo "Teacher ID not found!"
        read -p "Press any key to continue..."
        clear
    fi
}


view_teacher_students() {
    local file_path="enrollment.txt"
    if [[ ! -f "$file_path" ]]; then
        echo "Error: The file $file_path does not exist."
        return 1
    fi
    declare -A enrollment_dict
    while IFS=, read -r student_id course; do
        [[ -z "$student_id" || -z "$course" ]] && continue
        enrollment_dict["$student_id"]+="$course,"
    done < "$file_path"
    for student_id in "${!enrollment_dict[@]}"; do
        courses=$(echo "${enrollment_dict[$student_id]}" | sed 's/,$//' | tr ',' '\n' | sort -u | tr '\n' ',' | sed 's/,$//')
        echo "$student_id | course:$courses"
    done
    read -p "Press any key to continue..."
}


teacher_menu() {
    teacher_id=$1
    while true; do
        clear
        echo "Teacher Menu"
        echo "1. View Enrolled Students"
        echo "2. Exit"
        read -p "Enter your choice: " choice
        case $choice in
            1)
                clear
                view_teacher_students $teacher_id
            ;;
            2)
                echo "Exiting..."
                clear
                exit
            ;;
            *)
                echo "Invalid option!"
                read -p "Press any key to continue..."
                clear
            ;;
        esac
    done
}

add_student_account() {
    read -p "Enter student name: " name
    read -p "Enter student ID: " student_id
    read -s -p "Enter password: " password
    echo
    if grep -q "$student_id" $STUDENT_ACCOUNTS_FILE; then
        echo "Student ID already exists!"
    else
        echo "$name,$student_id,$password" >> $STUDENT_ACCOUNTS_FILE
        echo "Student account created successfully!"
    fi
    read -p "Press any key to continue..."
}

student_login() {
    read -p "Enter student ID: " student_id
    student_info=$(grep "$student_id" $STUDENT_ACCOUNTS_FILE)
    if [ ! -z "$student_info" ]; then
        student_name=$(echo $student_info | cut -d',' -f1)
        stored_password=$(echo $student_info | cut -d',' -f3)
        if check_password "student" "$stored_password"; then
            echo "Login successful!"
            student_menu $student_id
        else
            echo "Incorrect password. Please try again."
            read -p "Press any key to continue..."
            clear
        fi
    else
        echo "Student ID not found!"
        read -p "Press any key to continue..."
        clear
    fi
}


add_course() {
    local student_id=$1
    echo "Available Courses:"
    cat $COURSES_FILE
    echo
    read -p "Enter course name to enroll: " course
    if grep -q "$course" $COURSES_FILE; then
        if grep -q "^$student_id,$course$" $ENROLLMENT_FILE; then
            echo "You are already enrolled in $course!"
        else
            echo "$student_id,$course" >> $ENROLLMENT_FILE
            echo "Course $course added successfully!"
        fi
    else
        echo "Course not found!"
    fi
    read -p "Press any key to continue..."
}

student_menu() {
    student_id=$1
    while true; do
        clear
        echo "Student Menu"
        echo "1. Add Course"
        echo "2. Exit"
        read -p "Enter your choice: " choice
        case $choice in
            1)
                clear
                add_course $student_id
            ;;
            2)
                echo "Exiting..."
                clear
                exit
            ;;
            *)
                echo "Invalid option!"
                read -p "Press any key to continue..."
                clear
            ;;
        esac
    done
}

echo "Welcome to Student Management System"
while true; do
    echo "Select your role:"
    echo "1. Admin"
    echo "2. Teacher"
    echo "3. Student"
    echo "4. Exit"
    read -p "Enter your choice: " role
    case $role in
        1)
            if check_password "admin"; then
                echo "Login successful!"
                admin_menu
            else
                echo "Incorrect password. Please try again."
                read -p "Press any key to continue..."
                clear
            fi
        ;;
        2)
            echo "1. Login"
            echo "2. Create Account"
            read -p "Enter your choice: " teacher_choice
            case $teacher_choice in
                1)
                    teacher_login
                ;;
                2)
                    add_teacher
                ;;
                *)
                    echo "Invalid option!"
                    read -p "Press any key to continue..."
                    clear
                ;;
            esac
        ;;
        3)
            echo "1. Login"
            read -p "Enter your choice: " student_choice
            case $student_choice in
                1)
                    student_login
                ;;
                2)
                    add_student_account
                ;;
                *)
                    echo "Invalid option!"
                    read -p "Press any key to continue..."
                    clear
                ;;
            esac
        ;;
        4)
            echo "Exiting..."
            exit
        ;;
        *)
            echo "Invalid option!"
            read -p "Press any key to continue..."
            clear
        ;;
    esac
done

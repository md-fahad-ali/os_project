#!/bin/bash


STUDENT_FILE="students.txt"


check_password() {
    read -s -p "Enter password: " password
    echo
    if [ "$password" = "admin123" ]; then
        return 0
    else
        return 1
    fi
}


add_student() {
    read -p "Enter student name: " name
    read -p "Enter student ID: " student_id
    read -p "Enter student grade: " grade
    echo "$name,$student_id,$grade" >> $STUDENT_FILE
    echo "Student added successfully!"
    read -p "Press any key to continue..."
}


remove_student() {
    read -p "Enter student ID to remove: " student_id
    if grep -q "$student_id" $STUDENT_FILE; then
        grep -v "$student_id" $STUDENT_FILE > temp_file && mv temp_file $STUDENT_FILE
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


admin_menu() {
    while true; do
        clear
        echo "Admin Menu"
        echo "1. Add Student"
        echo "2. Remove Student"
        echo "3. View Students"
        echo "4. Exit"
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
                echo "Exiting..."
                clear
                exit
            ;;
            *)
                echo "Invalid option!"
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
            if check_password; then
                echo "Login successful!"
                admin_menu
            else
                echo "Incorrect password. Please try again."
            fi
        ;;
        2)
            echo "Teacher menu not implemented yet"
        ;;
        3)
            echo "Student menu not implemented yet"
        ;;
        4)
            echo "Exiting..."
            exit
        ;;
        *)
            echo "Invalid option!"
        ;;
    esac
done

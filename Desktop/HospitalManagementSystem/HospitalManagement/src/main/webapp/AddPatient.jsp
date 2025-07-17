<%-- 
    Document   : AddPatient
    Created on : 14-Jul-2025, 9:44:18 pm
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Patient</title>
         <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #d9f1ff, #f0fff4);
            color: #333;
        }

        .form-container {
            width: 500px;
            max-width: 90%;
            background-color: #fff;
            margin: 30px auto;
            padding: 20px 25px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .form-container h2 {
            text-align: center;
            color: #0f8b8d;
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="date"],
        input[type="email"],
        select {
            width: 100%;
            padding: 8px 10px;
            margin-top: 4px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }

        .submit-btn {
            width: 100%;
            margin-top: 20px;
            background-color: #0f8b8d;
            color: white;
            border: none;
            padding: 10px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .submit-btn:hover {
            background-color: #136c72;
        }
    </style>
    </head>
    <body>
        <jsp:include page="Header.jsp"></jsp:include>
        <div class="form-container">
        <h2>Add New Patient</h2>
        <form action="AddPatient" method="post">
            <label>First Name:</label>
            <input type="text" name="first_name" required>

            <label>Last Name:</label>
            <input type="text" name="last_name" required>

            <label>Date of Birth:</label>
            <input type="date" name="date_of_birth" required>

            <label>Gender:</label>
            <select name="gender" required>
                <option value="">--Select--</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
            </select>

            <label>Phone:</label>
            <input type="text" name="phone">

            <label>Email:</label>
            <input type="email" name="email">

            <label>Address:</label>
            <input type="text" name="address">

            <label>Emergency Contact:</label>
            <input type="text" name="emergency_contact">

            <button type="submit" class="submit-btn">Next</button>
        </form>
    </div>
        <jsp:include page="Footer.jsp"></jsp:include>
        
    </body>
</html>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    String firstName = "";

    if (username == null) {
        response.sendRedirect("Login.jsp");
        return;
    } else {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");

            String sql = "SELECT s.first_name FROM User u JOIN Staff s ON u.staff_id = s.staff_id WHERE u.username=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                firstName = rs.getString("first_name");
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Welcome | Sarvesh's Hospital</title>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: #f0fff4;
            color: #333;
        }

        .top-right {
            text-align: right;
            padding: 10px 20px;
            font-size: 18px;
            background: #d9f1ff;
        }

        header {
            background-color: #0f8b8d;
            color: white;
            padding: 20px 0;
            text-align: center;
        }

        header h2 {
            margin: 0;
            font-size: 32px;
            letter-spacing: 1px;
        }

        nav {
            display: flex;
            justify-content: center;
            background-color: #0f8b8d;
        }

        nav a {
            text-decoration: none;
            color: white;
            font-size: 18px;
            padding: 12px 20px;
            transition: background-color 0.3s;
        }

        nav a:hover {
            background-color: #136c72;
        }

        .carousel {
            width: 1500px;
            overflow: hidden;
            margin: 20px auto;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
            position: relative;
        }

        .slides {
            display: flex;
            width: calc(300px * 11); /* 8 images + 3 duplicates for loop */
            animation: scroll 40s linear infinite;
        }

        .slide {
            flex: 0 0 300px;
        }

        .slide img {
            width: 400px;
            height: 400px;
            object-fit: cover;
        }

        @keyframes scroll {
            0%   { transform: translateX(0); }
            100% { transform: translateX(-2400px); } /* 300px * 8 */
        }

        .motto {
            text-align: center;
            margin: 40px 20px;
        }

        .motto h3 {
            font-size: 28px;
            color: #0f8b8d;
            margin-bottom: 10px;
        }

        .motto p {
            font-size: 18px;
            max-width: 800px;
            margin: auto;
            color: #555;
        }

        footer {
            text-align: center;
            padding: 15px 0;
            background: #0f8b8d;
            color: white;
            margin-top: 40px;
        }
    </style>
</head>
<body>

<div class="top-right">
    Welcome <%= firstName %>
</div>

<header>
    <h2>SARVESH'S HOSPITAL</h2>
</header>

<nav>
    <a href="index.jsp">Home</a>
    <a href="Patient.jsp">Patient</a>
    <a href="ViewEHR.jsp">EHR</a>
    <a href="Inventory.jsp">Inventory</a>
    <a href="Staff.jsp">Staff</a>
    <a href="Logout">Logout</a>
</nav>

<div class="carousel">
    <div class="slides">
        <div class="slide"><img src="images/hospital1.jpg" alt="Hospital 1"></div>
        <div class="slide"><img src="images/hospital2.jpg" alt="Hospital 2"></div>
        <div class="slide"><img src="images/hospital3.jpg" alt="Hospital 3"></div>
        <div class="slide"><img src="images/hospital4.jpg" alt="Hospital 4"></div>
        <div class="slide"><img src="images/hospital5.jpeg" alt="Hospital 5"></div>
        <div class="slide"><img src="images/hospital6.jpg" alt="Hospital 6"></div>
        <div class="slide"><img src="images/hospital7.jpeg" alt="Hospital 7"></div>
        <div class="slide"><img src="images/hospital8.jpeg" alt="Hospital 8"></div>
        
        <!-- Duplicate first 3 images for smooth looping -->
        <div class="slide"><img src="images/hospital1.jpg" alt="Hospital 1"></div>
        <div class="slide"><img src="images/hospital2.jpg" alt="Hospital 2"></div>
        <div class="slide"><img src="images/hospital3.jpg" alt="Hospital 3"></div>
    </div>
</div>

<div class="motto">
    <h3>Our Mission</h3>
    <p>Delivering compassionate care and medical excellence to every patient, every day. Your health, our priority.</p>
</div>

<footer>
    &copy; 2025 Sarvesh's Hospital. All rights reserved.
</footer>

</body>
</html>

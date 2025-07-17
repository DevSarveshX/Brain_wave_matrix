<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String message = "";
    boolean isPost = "POST".equalsIgnoreCase(request.getMethod());
    if(isPost) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hospital_management","root","Sarvesh@123");

            String sql = "SELECT * FROM User WHERE username=? AND password_hash=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if(rs.next()) {
                session.setAttribute("username", username);
                session.setAttribute("role", rs.getString("role")); // assuming table has 'role' column
                response.sendRedirect("index.jsp");
                return;
            } else {
                message = "Invalid username or password.";
            }
            rs.close();
            ps.close();
            con.close();
        } catch(Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Sarvesh's Hospital</title>
    <style>
        body { 
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif; 
            background: linear-gradient(135deg, #d9f1ff, #f0fff4); 
            margin:0; 
        }
        header {
            background-color: #0f8b8d;
            padding: 20px 0;
            text-align: center;
        }
        header .header-title {
            margin: 0;
            font-size: 32px;
            color: white;
        }
        .login-box { 
            width: 350px; 
            margin: 80px auto; 
            background: #fff; 
            padding: 30px; 
            border-radius:8px; 
            box-shadow:0 2px 8px rgba(0,0,0,0.2); 
        }
        .login-title { 
            text-align:center; 
            color:#0f8b8d; 
            margin-bottom:20px; 
            font-size: 26px;
        }
        label { 
            display:block; 
            margin:10px 0 5px; 
        }
        input[type="text"], input[type="password"] { 
            width:100%; 
            padding:8px; 
            border:1px solid #ccc; 
            border-radius:4px; 
        }
        button { 
            width:100%; 
            background:#0f8b8d; 
            color:white; 
            padding:10px; 
            margin-top:15px; 
            border:none; 
            border-radius:4px; 
            font-size:16px; 
            cursor:pointer; 
        }
        button:hover { 
            background:#136c72; 
        }
        .message { 
            color:red; 
            text-align:center; 
            margin-top:10px; 
        }
    </style>
</head>
<body>

<header>
    <h2 class="header-title">WELCOME TO SARVESH'S HOSPITAL</h2>
</header>

<div class="login-box">
    <div class="login-title">Login</div>
    <% if(!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
    <% } %>
    <form method="post">
        <label>Username:</label>
        <input type="text" name="username" required>
        <label>Password:</label>
        <input type="password" name="password" required>
        <button type="submit">Login</button>
    </form>
</div>

</body>
</html>

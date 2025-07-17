<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
String staffIdParam = request.getParameter("staff_id");
String message = "";
String staffRole = "";

if (staffIdParam == null) {
    message = "Staff ID missing.";
} else {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");
        
        // fetch role from staff table
        String sql = "SELECT role FROM Staff WHERE staff_id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(staffIdParam));
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            staffRole = rs.getString("role");
        } else {
            message = "Staff not found.";
        }
        
        rs.close();
        ps.close();
        con.close();
    } catch(Exception e) {
        e.printStackTrace();
        message = "Error fetching staff role: " + e.getMessage();
    }
}

// if POST: insert new user
if("POST".equalsIgnoreCase(request.getMethod()) && staffRole != null && !staffRole.isEmpty()){
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    try{
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");

        String insertSql = "INSERT INTO User(staff_id, username, password_hash, role) VALUES (?,?,?,?)";
        PreparedStatement ps = con.prepareStatement(insertSql);
        ps.setInt(1, Integer.parseInt(staffIdParam));
        ps.setString(2, username);
        ps.setString(3, password); // NOTE: plain text for demo; ideally hash it!
        ps.setString(4, staffRole);
        int inserted = ps.executeUpdate();
        if(inserted > 0){
            response.sendRedirect("Staff.jsp");
            return;
        } else {
            message = "Failed to create user.";
        }
        ps.close();
        con.close();
    } catch(Exception e) {
        e.printStackTrace();
        message = "Error creating user: " + e.getMessage();
    }
}
%>
<!DOCTYPE html>
<html>
<head>
<title>Add User</title>
<style>
body { font-family:Segoe UI; background:linear-gradient(135deg,#d9f1ff,#f0fff4);}
.form-box { width:400px; margin:30px auto; background:#fff; padding:20px; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.2);}
h2 { text-align:center; color:#0f8b8d;}
label { display:block; margin:10px 0 5px;}
input { width:100%; padding:8px; border:1px solid #ccc; border-radius:4px;}
button { width:100%; background:#0f8b8d; color:white; padding:10px; margin-top:10px; border:none; border-radius:4px;}
button:hover { background:#136c72;}
.message { color:red; text-align:center;}
</style>
</head>
<body>
    <jsp:include page="Header.jsp"></jsp:include>
<div class="form-box">
<h2>Create User Login</h2>
<% if(!message.isEmpty()){ %><div class="message"><%=message%></div><% } %>
<form method="post">
    <label>Username:</label>
    <input name="username" required>
    <label>Password:</label>
    <input type="password" name="password" required>
    <label>Role:</label>
    <input value="<%= staffRole %>" readonly>
    <button type="submit">Create User</button>
</form>
</div>
    <jsp:include page="Footer.jsp"></jsp:include>
</body>
</html>

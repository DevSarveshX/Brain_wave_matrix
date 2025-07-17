<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String staffIdParam = request.getParameter("staff_id");
    String message = "";
    boolean isPost = "POST".equalsIgnoreCase(request.getMethod());

    if (staffIdParam != null && !staffIdParam.isEmpty()) {
        int staff_id = Integer.parseInt(staffIdParam);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hospital_management", "root", "Sarvesh@123");

            if (isPost) {
                String firstName = request.getParameter("first_name");
                String lastName = request.getParameter("last_name");
                String role = request.getParameter("role");
                String specialization = request.getParameter("specialization");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");
                String hireDate = request.getParameter("hire_date");
                String salary = request.getParameter("salary");

                String updateSql = "UPDATE Staff SET first_name=?, last_name=?, role=?, specialization=?, phone=?, email=?, hire_date=?, salary=? WHERE staff_id=?";
                PreparedStatement psUpdate = con.prepareStatement(updateSql);
                psUpdate.setString(1, firstName);
                psUpdate.setString(2, lastName);
                psUpdate.setString(3, role);
                psUpdate.setString(4, specialization);
                psUpdate.setString(5, phone);
                psUpdate.setString(6, email);
                psUpdate.setDate(7, Date.valueOf(hireDate));
                psUpdate.setBigDecimal(8, new java.math.BigDecimal(salary));
                psUpdate.setInt(9, staff_id);

                int updated = psUpdate.executeUpdate();
                psUpdate.close();

                if (updated > 0) {
                    response.sendRedirect("Staff.jsp");
                    return;
                } else {
                    message = "Failed to update staff details.";
                }
            }

            // Fetch existing staff info
            String sql = "SELECT * FROM Staff WHERE staff_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, staff_id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Staff</title>
    <style>
        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #d9f1ff, #f0fff4);
            color: #333;
        }
        h2 {
            text-align: center;
            color: #0f8b8d;
            margin-top: 20px;
        }
        form {
            width: 50%;
            margin: 20px auto;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        label {
            display: block;
            margin-top: 10px;
        }
        input[type="text"], input[type="date"], input[type="number"], select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            margin-top: 15px;
            background-color: #0f8b8d;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            font-size: 16px;
        }
        button:hover {
            background-color: #136c72;
        }
        .message { text-align: center; color: red; margin-top: 10px; }
    </style>
</head>
<body>
    <jsp:include page="Header.jsp"></jsp:include>
    <h2>Update Staff</h2>
    <% if (!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
    <% } %>
    <form method="post">
        <label>First Name:</label>
        <input type="text" name="first_name" value="<%= rs.getString("first_name") %>" required>

        <label>Last Name:</label>
        <input type="text" name="last_name" value="<%= rs.getString("last_name") %>" required>

        <label>Role:</label>
        <select name="role" required>
            <option value="Doctor" <%= "Doctor".equals(rs.getString("role")) ? "selected" : "" %>>Doctor</option>
            <option value="Nurse" <%= "Nurse".equals(rs.getString("role")) ? "selected" : "" %>>Nurse</option>
            <option value="Receptionist" <%= "Receptionist".equals(rs.getString("role")) ? "selected" : "" %>>Receptionist</option>
            <option value="Admin" <%= "Admin".equals(rs.getString("role")) ? "selected" : "" %>>Admin</option>
            <option value="Pharmacist" <%= "Pharmacist".equals(rs.getString("role")) ? "selected" : "" %>>Pharmacist</option>
            <option value="Lab Technician" <%= "Lab Technician".equals(rs.getString("role")) ? "selected" : "" %>>Lab Technician</option>
        </select>

        <label>Specialization:</label>
        <input type="text" name="specialization" value="<%= rs.getString("specialization") %>">

        <label>Phone:</label>
        <input type="text" name="phone" value="<%= rs.getString("phone") %>">

        <label>Email:</label>
        <input type="text" name="email" value="<%= rs.getString("email") %>">

        <label>Hire Date:</label>
        <input type="date" name="hire_date" value="<%= rs.getString("hire_date") %>" required>

        <label>Salary:</label>
        <input type="number" step="0.01" name="salary" value="<%= rs.getString("salary") %>" required>

        <button type="submit">Update Staff</button>
    </form>
        <jsp:include page="Footer.jsp"></jsp:include>
</body>
</html>
<%
            } else {
                out.println("<p style='color:red;text-align:center;'>Staff record not found.</p>");
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p style='color:red;text-align:center;'>Invalid staff ID.</p>");
    }
%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String staffIdParam = request.getParameter("staff_id");
    String message = "";
    String currentShift = null;
    boolean isPost = "POST".equalsIgnoreCase(request.getMethod());

    if(staffIdParam != null && !staffIdParam.isEmpty()) {
        int staff_id = Integer.parseInt(staffIdParam);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hospital_management","root","Sarvesh@123");

            if(isPost) {
                String newShift = request.getParameter("shift");

                // Check if record exists
                String checkSql = "SELECT * FROM StaffSchedule WHERE staff_id=?";
                PreparedStatement psCheck = con.prepareStatement(checkSql);
                psCheck.setInt(1, staff_id);
                ResultSet rs = psCheck.executeQuery();

                if(rs.next()) {
                    // Update existing shift
                    String updateSql = "UPDATE StaffSchedule SET shift=? WHERE staff_id=?";
                    PreparedStatement psUpdate = con.prepareStatement(updateSql);
                    psUpdate.setString(1, newShift);
                    psUpdate.setInt(2, staff_id);
                    int updated = psUpdate.executeUpdate();
                    if(updated > 0) {
                        message = "Shift updated successfully.";
                    } else {
                        message = "Failed to update shift.";
                    }
                    psUpdate.close();
                } else {
                    // Insert new shift
                    String insertSql = "INSERT INTO StaffSchedule (staff_id, shift) VALUES (?, ?)";
                    PreparedStatement psInsert = con.prepareStatement(insertSql);
                    psInsert.setInt(1, staff_id);
                    psInsert.setString(2, newShift);
                    int inserted = psInsert.executeUpdate();
                    if(inserted > 0) {
                        message = "Shift assigned successfully.";
                    } else {
                        message = "Failed to assign shift.";
                    }
                    psInsert.close();
                }
                rs.close();
                psCheck.close();
            }

            // Get current shift again to display in form
            String getSql = "SELECT shift FROM StaffSchedule WHERE staff_id=?";
            PreparedStatement psGet = con.prepareStatement(getSql);
            psGet.setInt(1, staff_id);
            ResultSet rsGet = psGet.executeQuery();
            if(rsGet.next()) {
                currentShift = rsGet.getString("shift");
            }
            rsGet.close();
            psGet.close();

            con.close();

        } catch(Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        }
    } else {
        message = "Invalid staff ID.";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Assign / Update Shift</title>
    <style>
        body { 
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif; 
            background: linear-gradient(135deg, #d9f1ff, #f0fff4); 
            margin:0; 
        }
        .container { 
            width: 400px; 
            margin: 50px auto; 
            background: #fff; 
            padding: 20px; 
            border-radius:8px; 
            box-shadow:0 2px 8px rgba(0,0,0,0.2); 
        }
        h2 { 
            text-align:center; 
            color:#0f8b8d; 
            margin-bottom:20px; 
        }
        label { 
            display:block; 
            margin:10px 0 5px; 
        }
        select { 
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
            text-align:center; 
            margin-top:10px; 
            color:green; 
        }
        .back-btn {
            display: block;
            width: 160px;
            margin: 10px auto;
            padding: 10px 20px;
            background-color: #0f8b8d;
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 5px;
            font-size: 15px;
        }
        .back-btn:hover { background-color: #136c72; }
    </style>
</head>
<body>
<jsp:include page="Header.jsp"></jsp:include>
<a class="back-btn" href="Staff.jsp">Back to Staff List</a>
<div class="container">
    <h2>Assign / Update Shift</h2>
    <% if(!message.isEmpty()) { %>
        <div class="message"><%= message %></div>
    <% } %>
    <form method="post">
        <label>Staff ID:</label>
        <input type="text" name="staff_id" value="<%= staffIdParam %>" readonly style="background:#eee; width:100%; padding:8px;">

        <label>Shift:</label>
        <select name="shift" required>
            <option value="">--Select Shift--</option>
            <option value="Morning" <%= "Morning".equals(currentShift) ? "selected" : "" %>>Morning</option>
            <option value="Afternoon" <%= "Afternoon".equals(currentShift) ? "selected" : "" %>>Afternoon</option>
            <option value="Night" <%= "Night".equals(currentShift) ? "selected" : "" %>>Night</option>
        </select>

        <button type="submit">Save</button>
    </form>
</div>
<jsp:include page="Footer.jsp"></jsp:include>
</body>
</html>

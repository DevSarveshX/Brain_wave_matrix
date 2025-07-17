<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("username");
    String firstName = "";

    if(username == null) {
        response.sendRedirect("Login.jsp");
        return;
    } else {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hospital_management","root","Sarvesh@123");

            String sql = "SELECT s.first_name FROM User u JOIN Staff s ON u.staff_id = s.staff_id WHERE u.username=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if(rs.next()) {
                firstName = rs.getString("first_name");
            }

            rs.close();
            ps.close();
            con.close();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
%>
 <div class="top-right">
        Welcome <%= firstName %>
    </div>
<header>
    <h2>WELCOME TO SARVESH'S HOSPITAL</h2>
</header>

<nav>
    <a href="index.html">Home</a>
    <a href="Patient.jsp">Patient</a>
    <a href="ViewAppointments.jsp">Appointments</a>
    <a href="Inventory.jsp">Inventory</a>
    <a href="Staff.jsp">Staff</a>
    <a href="Logout">Logout</a>
</nav>

<style>
    header {
        background-color: #0f8b8d;
        padding: 20px 0;
        text-align: center;
        color: white;
    }

    header h2 {
        margin: 0;
        font-size: 32px;
        color: white; /* ensures text stays white */
    }
    .top-right {
            text-align: right;
            padding: 10px 20px;
            font-size: 18px;
        }

    nav {
        display: flex;
        justify-content: center;
        background-color: #0f8b8d;
    }

    nav a {
        text-decoration: none;
        color: white;
        font-size: 20px;
        padding: 14px 25px;
        display: inline-block;
        transition: background-color 0.3s;
    }

    nav a:hover {
        background-color: #136c72;
    }
</style>

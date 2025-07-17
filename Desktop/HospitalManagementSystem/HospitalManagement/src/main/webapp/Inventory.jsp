<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    // Check if deletion requested
    String deleteIdParam = request.getParameter("delete_id");
    if (deleteIdParam != null && !deleteIdParam.isEmpty()) {
        try {
            int delete_id = Integer.parseInt(deleteIdParam);
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hospital_management","root","Sarvesh@123");

            String deleteSql = "DELETE FROM Inventory WHERE item_id=?";
            PreparedStatement ps = con.prepareStatement(deleteSql);
            ps.setInt(1, delete_id);
            ps.executeUpdate();

            ps.close();
            con.close();

            // Redirect to avoid repeat deletion on refresh
            response.sendRedirect("Inventory.jsp");
            return;
        } catch(Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red; text-align:center;'>Error deleting item: " + e.getMessage() + "</p>");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Inventory List</title>
    <style>
        body {
            font-family:"Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #d9f1ff, #f0fff4);
            margin:0;
        }
        h2 {
            text-align:center;
            color:#0f8b8d;
            margin-top:20px;
        }
        .add-btn {
            display:block;
            width:150px;
            margin:10px auto;
            padding:10px 20px;
            background-color:#0f8b8d;
            color:white;
            text-align:center;
            text-decoration:none;
            border-radius:5px;
        }
        .add-btn:hover {
            background-color:#136c72;
        }
        table {
            width:90%;
            margin:20px auto;
            border-collapse:collapse;
            background:#fff;
            box-shadow:0 2px 8px rgba(0,0,0,0.1);
        }
        th, td {
            padding:10px;
            text-align:center;
            border:1px solid #ccc;
        }
        th {
            background-color:#0f8b8d;
            color:white;
        }
        tr:nth-child(even) {background:#f2f9f9;}
        tr:hover {background:#d0efef;}
        .action-btn {
            padding:5px 10px;
            margin:2px;
            background-color:#0f8b8d;
            color:white;
            text-decoration:none;
            border-radius:4px;
            font-size:14px;
        }
        .action-btn:hover { background-color:#136c72; }
    </style>
</head>
<body>
<jsp:include page="Header.jsp"></jsp:include>
<h2>Inventory List</h2>

<a class="add-btn" href="AddInventory.jsp">Add Inventory</a>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/hospital_management","root","Sarvesh@123");

        String sql = "SELECT * FROM Inventory";
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(sql);

        boolean hasRecords = false;
%>
<table>
    <tr>
        <th>ID</th>
        <th>Item Name</th>
        <th>Quantity</th>
        <th>Supplier</th>
        <th>Purchase Date</th>
        <th>Expiry Date</th>
        <th>Unit Price</th>
        <th>Actions</th>
    </tr>
<%
    while(rs.next()) {
        hasRecords = true;
%>
    <tr>
        <td><%= rs.getInt("item_id") %></td>
        <td><%= rs.getString("item_name") %></td>
        <td><%= rs.getInt("quantity") %></td>
        <td><%= rs.getString("supplier") %></td>
        <td><%= rs.getDate("purchase_date") %></td>
        <td><%= rs.getDate("expiry_date") %></td>
        <td><%= rs.getBigDecimal("unit_price") %></td>
        <td>
            <a class="action-btn" href="UpdateInventory.jsp?item_id=<%= rs.getInt("item_id") %>">Update</a>
            <a class="action-btn" href="Inventory.jsp?delete_id=<%= rs.getInt("item_id") %>" 
               onclick="return confirm('Are you sure you want to delete this item?');">Delete</a>
        </td>
    </tr>
<% } %>
<% if(!hasRecords) { %>
    <tr><td colspan="8">No inventory items found.</td></tr>
<% } %>
</table>
<%
    rs.close();
    st.close();
    con.close();
    } catch(Exception e) {
        e.printStackTrace();
        out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
    }
%>
<jsp:include page="Footer.jsp"></jsp:include>
</body>
</html>

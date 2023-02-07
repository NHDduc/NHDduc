<%@ page import="java.sql.*" %>
<%! Connection conn = null; %>
<%
String founder = request.getParameter("founder");
String name = request.getParameter("c_name");
String purpose = request.getParameter("c_purpose");
String cover = "chars/default.jpg";

if (request.getParameter("fileToUpload") != null) {
String target_dir = "chars/";
String fileName = request.getPart("fileToUpload").getSubmittedFileName();
String target_file = target_dir + fileName;

InputStream fileContent = request.getPart("fileToUpload").getInputStream();
BufferedImage image = ImageIO.read(fileContent);

if (image == null) {
out.println("File is not an image.");
return;
}

String imageFileType = fileName.substring(fileName.lastIndexOf('.') + 1);
if (!imageFileType.equalsIgnoreCase("jpg") && !imageFileType.equalsIgnoreCase("png")
&& !imageFileType.equalsIgnoreCase("jpeg") && !imageFileType.equalsIgnoreCase("gif")) {
out.println("Sorry, only JPG, JPEG, PNG & GIF files are allowed.");
return;
}

File file = new File(target_file);
if (file.exists()) {
out.println("Sorry, file already exists. Rename and upload your file.");
return;
}

if (fileContent.available() > 5000000) {
out.println("Sorry, your file is too large.");
return;
}

try {
ImageIO.write(image, imageFileType, file);
cover = target_file;
} catch (IOException e) {
out.println("Sorry, there was an error uploading your file.");
return;
}
}

try {
Class.forName("com.mysql.jdbc.Driver");
conn = DriverManager.getConnection("jdbc:mysql://localhost/database_name", "user", "password");
Statement stmt = conn.createStatement();

if (request.getParameter("submit").equals("add")) {
stmt.executeUpdate("INSERT INTO charities(id, name, purpose, founder, cover) " +
"VALUES (NULL, '" + name + "', '" + purpose + "', '" + founder + "', '" + cover + "')");
session.setAttribute("success", "added");
response.sendRedirect("addCharity.jsp");
} else {
stmt.executeUpdate("INSERT INTO raise(founder,name,purpose,cover,id) " +
"VALUES ('" + founder + "','" + name + "','" + purpose + "','" + cover + "',NULL)");
session.setAttribute("success", "added");
response.sendRedirect("raisefund.jsp")
}}
<?php
    //Create Database connection
    $db = mysql_connect("localhost","root","password");
    if (!$db) {
        die('Could not connect to db: ' . mysql_error());
    }
 
    //Select the Database
    mysql_select_db("classDatabase",$db);
    
    //Replace * in the query with the column names.
    $result = mysql_query("select * from csciClasses", $db);  
    
    //Create an array
    $json_response = array();
    
    while ($row = mysql_fetch_array($result, MYSQL_ASSOC)) {
        $row_array['DEPT'] = $row['DEPT'];
        $row_array['CourseSubj'] = $row['CourseSubj'];
        $row_array['SectNum'] = $row['SectNum'];
        $row_array['SessnCode'] = $row['SessnCode'];
        $row_array['ClassNum'] = $row['ClassNum'];
        $row_array['Credits'] = $row['Credits'];
        $row_array['CourseTitle'] = $row['CourseTitle'];
        $row_array['ClassComp'] = $row['ClassComp'];
        $row_array['Times'] = $row['Times'];
        $row_array['Days'] = $row['Days'];
        $row_array['RoomNum'] = $row['RoomNum'];
        $row_array['InstructorLast'] = $row['InstructorLast'];
        $row_array['InstructorFirst'] = $row['InstructorFirst'];
        $row_array['MaxEnrl'] = $row['MaxEnrl'];
       
        //push the values in the array
        array_push($json_response,$row_array);
    }
    echo json_encode($json_response);
    
    //Close the database connection
    fclose($db);
 
?>
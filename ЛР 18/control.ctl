LOAD DATA 
INFILE 'C:\labs_bd\lab18\import_data.txt'
DISCARDFILE 'C:\labs_bd\lab18\import_data.dis'
INTO TABLE LAB18
FIELDS TERMINATED BY ","
(
	id "round(:id, 2)",
	text "upper(:text)",
	date_value date "DD.MM.YYYY"
)
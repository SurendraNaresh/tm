#!/bin/bash
#@check if atleast 3 argument are  provided
if [ $# -le 1 ]; then
	echo "Usage: $0 <filename> dbtable -a <appname>" 1>&2
    exit 1
fi
# //Default values
rep1="Application_Name"
rep2="Application_home"
rep3="Application_state"
# // process options
while getopts"a:r:s:t:x" opt, do
    case $opt in 
	a) appname="$OPTARG";;
 	r) rep1="$OPTARG";;
 	a) rep2="$OPTARG";;
 	a) rep3="$OPTARG";;
 	x) echo -e "Usage:app_name=$0 [-a appName] [-r\-s\-t rep1\2\3]" >&2; exit1  ;;
	\?) echo "Invalid option: -$OPTARG" >&2 ; exit 1;;
    esac
done3
shift $((OPTIND-1))
# //process the remanings filename, tablename and appno
filename="$1"
table_name="$2"
app_no=$3;   
if [-z "filename" ] || [ -z "$table_name" ] ; 
then
    echo "Missing filename or table name!" >&2
    exit 1
fi
#// InitDbTable ::Creates the table if it does_not exists.
sqlite3 ddir/camp.db <<SqEndLine
        CREATE TABLE IF NOT EXISTS records (
            fld1 INT AUTO_INCREMENT PRIMARY KEY/* AppNo */
            ,fld2 varchar(30)               /* AppName */ 
            ,fld3 varchar(30)               /* AppShow */
            ,fld4 varchar(30)               /* AppHome */ 
            ,fld5 varchar(30)               /* AppState */
        );
SqEndLine
# Get last app number (if no appno provided)
last_app_no=$(sqlite3 ddir/camp.db <<< "SELECT MAX(fld1) FROM $table_name;" | cut -d'|' -f2)
if [ $? -ne 0 ]; then
    echo "Error accessing db !" >&2
    exit 1
fi

# Calculate the next application number
let "next_app_no = last_app_no + 1"

# Check if the application name already exists
app_no=$(sqlite3 ddir/camp.db <<SqEndLine
    SELECT fld1 FROM $table_name WHERE fld2='$appname';
SqEndLine
)
if [ "$app_no" != "" ]; then
    echo "Error in data: $appname already exists!" >&2
    exit 1
fi

# If no records found, $app_no=="0"
if [ -z "$app_no" ]; then
    echo "App name '$appname' not found!" >&2
    echo "Table contains no applications... adding default "
    # exit 1 # This line was commented out; please verify if it's necessary
fi

# Create a backup of the original file
cp "$filename" "original.$filename"

# Generate replacements with appname
app_show="${appname}_show"
app_home="${appname}_home"
app_state="${appname}_state"

# Process the file line by line and perform replacements
while IFS= read -r line; do
    # Perform replacements with sed
    replacements="{s/\"${appname}_show\"/\"$app_show\"/g; s/\"${appname}_home\"/\"$app_home\"/g; s/\"${appname}_state\"/\"$app_state\"/g}"
    replaced_line=$(echo "$line" | sed -E "$replacements")
    echo "$replaced_line" >>"$filename.replaced"
done <"$filename"

# Display replacement counts
echo "Replacements written to: $filename.replaced"

# Update the database (if appname provided)
if [ -n "$appname" ]; then
    # Escape special characters for safe SQL insertions
    escaped_app=$(echo "$appname" | sed 's/\\/\\\\/g; s/"/\\\"/g')
    echo -e "\$escaped_app = $escaped_app\n"
    sql_insert="INSERT INTO $table_name (fld1, fld2, fld3, fld4, fld5) VALUES ($next_app_no, '${escaped_app}_name', '${escaped_app}_show', '${escaped_app}_home', '${escaped_app}_state');"
    echo "$sql_insert"
    # Execute the SQL statement using the opened connection
    sqlite3 ddir/camp.db <<<"$sql_insert"
    if [ $? -ne 0 ]; then
        echo "Error updating the database:~ $2" >&2
        exit 1
    fi
fi

echo -e "Replacements made and backuped to $origin.$filename"

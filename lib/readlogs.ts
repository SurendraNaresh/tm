// Function to read logs from Local Storage
function readLogs() {
  // Retrieve the logs from Local Storage
  let logs = localStorage.getItem('mylog.csv');

  // If logs are found, parse them from JSON
  if (logs) {
    logs = JSON.parse(logs);
  } else {
    // If no logs are found, initialize as an empty array
    logs = [];
  }

  return logs;
}

// Function to print logs to the console
function printLogs() {
  const logs = readLogs();
  console.log('Stored Logs:');
  logs.forEach(log => {
    console.log(log);
  });
}

// Call the printLogs function to read and print logs
printLogs();

// Function to fetch earthquake data from USGS Earthquake API
async function fetchEarthquakeData() {
  const url = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson';
  try {
    const response = await fetch(url);
    const data = await response.json();
    return data.features;
  } catch (error) {
    console.error('Error fetching earthquake data:', error);
    return [];
  }
}

// Function to display earthquake data on the webpage
function displayEarthquakeData(earthquakes) {
  const earthquakeDataContainer = document.getElementById('earthquakeData');
  earthquakeDataContainer.innerHTML = '';

  earthquakes.forEach((earthquake) => {
    const properties = earthquake.properties;
    const magnitude = properties.mag;
    const place = properties.place;
    const time = new Date(properties.time).toLocaleString();

    const earthquakeInfo = document.createElement('div');
    earthquakeInfo.className = 'earthquake-info';
    earthquakeInfo.innerHTML = `
      <p><strong>Magnitude:</strong> ${magnitude}</p>
      <p><strong>Location:</strong> ${place}</p>
      <p><strong>Time:</strong> ${time}</p>
      <hr>
    `;

    earthquakeDataContainer.appendChild(earthquakeInfo);
  });
}

// Fetch and update earthquake data every few seconds
async function updateEarthquakeData() {
  const earthquakes = await fetchEarthquakeData();
  displayEarthquakeData(earthquakes);
}

// Initial update and periodic refresh
updateEarthquakeData();
setInterval(updateEarthquakeData, 30000); // Refresh every 30 seconds

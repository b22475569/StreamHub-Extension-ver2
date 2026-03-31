// checkin-system.js

const db = require('your-database-module'); // Replace with actual DB module

// Check-in functionality for South Korean locations
async function checkIn(userId, location) {
    const validLocations = ['Seoul', 'Busan', 'Incheon', 'Gwangju', 'Daejeon', 'Ulsan']; // Add more as needed

    if (!validLocations.includes(location)) {
        throw new Error('Invalid location. Check-in is only allowed in South Korea.');
    }

    const timestamp = new Date().toISOString();
    const result = await db.query('INSERT INTO checkins (userId, location, timestamp) VALUES (?, ?, ?)', [userId, location, timestamp]);

    return result;
}

module.exports = {
    checkIn,
};

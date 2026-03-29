/* StreamHub History Bridge — background.js (Service Worker)
   Handles chrome.history.search() calls from content.js,
   since chrome.history is available in service workers.     */

chrome.runtime.onMessage.addListener((msg, sender, sendResponse) => {
    if (msg.type !== 'GET_HISTORY') return false;

    const query = {
        text:       msg.search || '',
        maxResults: msg.limit  || 500,
        startTime:  Date.now() - (90 * 24 * 60 * 60 * 1000) /* last 90 days */
    };

    chrome.history.search(query, (items) => {
        sendResponse(items || []);
    });

    return true; /* keep channel open for async sendResponse */
});

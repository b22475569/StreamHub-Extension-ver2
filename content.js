/* StreamHub History Bridge — content.js
   Listens for 'streamhub:request_history' CustomEvent from the page,
   queries chrome.history.search(), then replies via 'streamhub:history'.
   Also injects window.__streamhub_history for immediate access.          */

window.addEventListener('streamhub:request_history', async (e) => {
    const limit  = (e.detail && e.detail.limit)  || 500;
    const search = (e.detail && e.detail.search) || '';

    try {
        /* chrome.history.search works in content scripts with "history" permission */
        const results = await chrome.runtime.sendMessage({
            type: 'GET_HISTORY',
            limit: limit,
            search: search
        });

        const rows = (results || []).map(item => ({
            url:         item.url,
            title:       item.title || item.url,
            last_visit:  item.lastVisitTime
                ? new Date(item.lastVisitTime).toISOString()
                : new Date().toISOString(),
            visit_count: item.visitCount || 1
        }));

        /* Inject directly onto window so fallback path also works */
        window.__streamhub_history = rows;

        /* Fire reply event back to the page */
        window.dispatchEvent(new CustomEvent('streamhub:history', {
            detail: { rows: rows }
        }));

    } catch (err) {
        console.warn('[StreamHub Bridge] history fetch failed:', err);
        window.dispatchEvent(new CustomEvent('streamhub:history', {
            detail: { rows: null, error: err.message }
        }));
    }
});

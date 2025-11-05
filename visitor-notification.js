// Visitor Notification Script
// Add this script to your existing website to track visitors
// Just include this script in your HTML pages

(function() {
    'use strict';
    
    // Function to get visitor's IP address and send notification
    async function sendVisitorNotification() {
        try {
            // Get IP address using a free service
            const ipResponse = await fetch('https://api.ipify.org?format=json');
            const ipData = await ipResponse.json();
            const ipAddress = ipData.ip;

            // Prepare visitor data
            const visitorData = {
                ip: ipAddress,
                ipAddress: ipAddress,
                userAgent: navigator.userAgent,
                referrer: document.referrer || 'Direct',
                timestamp: new Date().toISOString(),
                pageUrl: window.location.href,
                language: navigator.language,
                screenResolution: `${window.screen.width}x${window.screen.height}`,
                timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
            };

            // Railway n8n webhook URL
            const webhookUrl = 'https://website-visitor-notification-production.up.railway.app/webhook/visitor-notification';

            // Send data to n8n webhook (silently in background)
            const response = await fetch(webhookUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(visitorData)
            });

            const result = await response.json();
            console.log('Visitor notification sent successfully:', result);
        } catch (error) {
            // Silently fail - don't interrupt user experience
            console.error('Error sending visitor notification:', error);
        }
    }

    // Send notification when page loads
    // Use DOMContentLoaded for faster execution, or 'load' for complete page load
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', sendVisitorNotification);
    } else {
        // Page already loaded
        sendVisitorNotification();
    }
})();


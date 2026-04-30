/**
 * notifications.js
 * Handles fetching, rendering, and marking notifications as read.
 */

document.addEventListener('DOMContentLoaded', () => {
    const accessToken = localStorage.getItem('access_token');
    
    // Elements
    const bellIcon = document.querySelector('.notification-bell');
    const badgeDot = document.querySelector('.badg-dot');
    
    if (!bellIcon || !accessToken) return;

    // Create dropdown wrapper dynamically
    const dropdown = document.createElement('div');
    dropdown.className = 'notification-dropdown hidden';
    dropdown.innerHTML = `
        <div class="notification-header">
            <h4>Notifications</h4>
        </div>
        <div class="notification-list"></div>
    `;
    
    // Add dropdown next to bell icon
    bellIcon.parentNode.style.position = 'relative'; // Ensure parent can position absolute children
    bellIcon.parentNode.appendChild(dropdown);
    
    const notificationList = dropdown.querySelector('.notification-list');
    
    // Toggle dropdown
    bellIcon.addEventListener('click', (e) => {
        dropdown.classList.toggle('hidden');
        e.stopPropagation();
    });
    
    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        if (!bellIcon.parentNode.contains(e.target)) {
            dropdown.classList.add('hidden');
        }
    });

    async function fetchNotifications() {
        try {
            const response = await fetch('/api/accounts/notifications/', {
                headers: { 'Authorization': `Bearer ${accessToken}` }
            });
            
            if (response.ok) {
                const notifications = await response.json();
                renderNotifications(notifications);
            }
        } catch (error) {
            console.error('Failed to fetch notifications', error);
        }
    }
    
    function renderNotifications(notifications) {
        notificationList.innerHTML = '';
        let unreadCount = 0;
        
        if (notifications.length === 0) {
            notificationList.innerHTML = '<div class="notification-empty">No notifications</div>';
            badgeDot.style.display = 'none';
            return;
        }

        notifications.forEach(notif => {
            if (!notif.is_read) unreadCount++;
            
            const item = document.createElement('div');
            item.className = `notification-item ${notif.is_read ? 'read' : 'unread'}`;
            item.innerHTML = `
                <div class="notification-meta">${new Date(notif.created_at).toLocaleString()}</div>
                <div class="notification-message">${notif.message}</div>
            `;
            
            // Handle Click
            item.addEventListener('click', async () => {
                if (!notif.is_read) {
                    await fetch(`/api/accounts/notifications/${notif.id}/read/`, {
                        method: 'PATCH',
                        headers: {
                            'Authorization': `Bearer ${accessToken}`,
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({ is_read: true })
                    });
                }
                if (notif.link) {
                    window.location.href = notif.link;
                }
            });
            
            notificationList.appendChild(item);
        });
        
        if (unreadCount > 0) {
            badgeDot.style.display = 'block';
            if(badgeDot) badgeDot.textContent = unreadCount > 9 ? '9+' : unreadCount;
        } else {
            badgeDot.style.display = 'none';
        }
    }
    
    // Initial fetch
    fetchNotifications();
    
    // Poll every 3 minutes
    setInterval(fetchNotifications, 180000);
});

// remember to add this back as well as create its function
// <span class="mark-all-read">Mark all as read</span>


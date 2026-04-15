/**
 * Shared utility functions for UniResolve frontend.
 */

function getTimeframeDisplay(dueDateString, status) {
    if (!dueDateString) return '<span style="color: gray;">N/A</span>';

    // If the ticket is resolved or transferred, don't show overdue status
    if (status === 'RESOLVED' || status === 'CLOSED') {
        return '<span style="color: gray;">Completed</span>';
    }
    if (status === 'REJECTED') {
        return '<span style="color: gray;">Rejected</span>';
    }
    if (status === 'PENDING') {
        return '<span style="color: #714c2fff;">Paused (Awaiting Student)</span>';
    }

    const dueDate = new Date(dueDateString);
    const now = new Date();
    const diffMs = dueDate - now;

    let isOverdue = false;
    let absDiffMs = diffMs;

    if (diffMs < 0) {
        isOverdue = true;
        absDiffMs = Math.abs(diffMs);
    }

    const diffDays = Math.floor(absDiffMs / (1000 * 60 * 60 * 24));
    absDiffMs -= diffDays * (1000 * 60 * 60 * 24);

    const diffHours = Math.floor(absDiffMs / (1000 * 60 * 60));
    absDiffMs -= diffHours * (1000 * 60 * 60);

    const diffMinutes = Math.floor(absDiffMs / (1000 * 60));

    let color = '#2e7d32'; // Default Green (Safe)
    if (isOverdue) {
        color = '#d32f2f'; // Red (Deadline Passed)
    } else if (diffDays === 0 && diffHours <= 24) {
        color = '#ed6c02'; // Orange (Less than 24 hours remaining)
    }

    let textParts = [];
    if (diffDays > 0) {
        textParts.push(`${diffDays} ${diffDays === 1 ? 'day' : 'days'}`);
    }
    if (diffHours > 0) {
        textParts.push(`${diffHours} ${diffHours === 1 ? 'hr' : 'hrs'}`);
    }
    if (diffMinutes > 0 && diffDays === 0) {
        // Only show minutes if it's less than a day, to keep it clean
        textParts.push(`${diffMinutes} ${diffMinutes === 1 ? 'min' : 'mins'}`);
    }

    if (textParts.length === 0) {
        textParts.push('Just now');
    }

    let textStr = textParts.join(' ');

    let text = isOverdue ? `${textStr} overdue` : `${textStr} left`;

    
    return `<span style="color: ${color}; font-weight: 500; display: inline-flex; align-items: center; gap: 6px;">
                ${text}
            </span>`;
}

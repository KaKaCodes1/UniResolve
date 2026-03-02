/**
 * Shared utility functions for UniResolve frontend.
 */

function getTimeframeDisplay(dueDateString, status) {
    if (!dueDateString) return '<span style="color: gray;">N/A</span>';

    // If the ticket is resolved or transferred, don't show overdue status
    if (status === 'RESOLVED' || status === 'CLOSED') {
        return '<span style="color: gray;">Completed</span>';
    }

    const dueDate = new Date(dueDateString);
    const now = new Date();
    const diffMs = dueDate - now;

    const diffDays = Math.round(diffMs / (1000 * 60 * 60 * 24));
    const diffHours = Math.round(diffMs / (1000 * 60 * 60));

    let color = '#2e7d32'; // Default Green (Safe)
    if (diffMs < 0) {
        color = '#d32f2f'; // Red (Deadline Passed)
    } else if (diffHours <= 24) {
        color = '#ed6c02'; // Orange (Less than 24 hours remaining)
    }

    let text;
    if (Math.abs(diffDays) === 0) {
        text = `${diffHours} hours left`;
    } else {
        text = `${diffDays} days left`;
    }

    if (diffMs < 0) {
        if (Math.abs(diffDays) === 0) {
            text = `${Math.abs(diffHours)} hours overdue`;
        } else {
            text = `${Math.abs(diffDays)} days overdue`;
        }
    }

    return `<span style="color: ${color}; font-weight: 500; display: inline-flex; align-items: center; gap: 6px;">
                ${text}
            </span>`;
}

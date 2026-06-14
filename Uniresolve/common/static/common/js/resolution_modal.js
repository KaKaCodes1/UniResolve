function openResolutionModal(ticketId, ticketTitle, staffName, status, fullFeedback, department, linkPrefix, isRestricted = false) {
    document.getElementById('modalTicketId').textContent = '#' + ticketId;
    document.getElementById('modalTicketTitle').textContent = ticketTitle;
    document.getElementById('modalStaffName').textContent = staffName;
    document.getElementById('modalFeedback').textContent = fullFeedback;
    
    const statusSpan = document.getElementById('modalStatus');
    statusSpan.className = `status-badge status-${status.toLowerCase()}`;
    statusSpan.textContent = status;

    // Optional department - will not be visible for department staff
    const deptContainer = document.getElementById('modalDepartmentContainer');
    if (department) {
        document.getElementById('modalDepartment').textContent = department;
        deptContainer.style.display = 'flex';
    } else {
        deptContainer.style.display = 'none';
    }
    
    // Setup Link - prefix varies by admin vs staff
    const ticketLink = document.getElementById('modalTicketLink');
    if (isRestricted) {
        ticketLink.href = '#';
        ticketLink.onclick = function(e) {
            e.preventDefault();
            alert('You cannot open this ticket because it has been transferred or escalated out of your active workload.');
        };
        ticketLink.style.opacity = '0.6';
        ticketLink.style.cursor = 'not-allowed';
    } else {
        ticketLink.href = linkPrefix ? `${linkPrefix}${ticketId}/` : '#';
        ticketLink.onclick = null; // Clear override
        ticketLink.style.opacity = '1';
        ticketLink.style.cursor = 'pointer';
    }
    
    document.getElementById('resolutionModal').style.display = 'flex';
}

function closeResolutionModal() {
    document.getElementById('resolutionModal').style.display = 'none';
}

// Close modal when clicking outside of it
window.addEventListener('click', function(event) {
    const modal = document.getElementById('resolutionModal');
    if (event.target == modal) {
        closeResolutionModal();
    }
});

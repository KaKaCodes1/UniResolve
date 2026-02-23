/**
 * escalation.js
 * Contains logic for escalating and transferring tickets.
 * Handles opening/closing the escalation modal, loading departments,
 * fetching user roles, and submitting the escalation event to the API.
 */

let departmentsLoaded = false;
let currentUserRole = null; // Will store "STAFF" or "SENIOR"
// Ensure the host page sets `latestTickets` (or `allTickets`) and `currentTicketId`
// before calling openEscalateModal()

async function loadDepartments() {
    if (departmentsLoaded) return;

    try {
        const response = await fetch('/api/v1/orgs/departments/', {
            headers: { 'Authorization': `Bearer ${localStorage.getItem('access_token')}` }
        });
        if (response.ok) {
            const departments = await response.json();
            const select = document.getElementById('targetDepartment');
            departments.forEach(dept => {
                const option = document.createElement('option');
                option.value = dept.id;
                option.textContent = dept.name || dept.department_name;
                select.appendChild(option);
            });
            departmentsLoaded = true;
        }
    } catch (e) {
        console.error("Failed to fetch departments", e);
    }
}

async function fetchCurrentUserRole() {
    if (currentUserRole !== null) return;

    try {
        const response = await fetch('/api/accounts/profile/', {
            headers: { 'Authorization': `Bearer ${localStorage.getItem('access_token')}` }
        });
        if (response.ok) {
            const user = await response.json();
            if (user.profile_data && user.profile_data.staff_role) {
                currentUserRole = user.profile_data.staff_role;
            }
        }
    } catch (e) {
        console.error("Failed to fetch user role", e);
    }
}

async function openEscalateModal() {
    // Determine which ticket list is available in the current context (dashboard vs all_issues)
    const ticketsArray = typeof latestTickets !== 'undefined' ? latestTickets : (typeof allTickets !== 'undefined' ? allTickets : []);

    // Save the ID before closing the resolve modal, as closeResolveModal wipes it!
    const ticketIdToEscalate = currentTicketId;

    // Close the resolve modal first
    closeResolveModal();

    // Restore the ID so the Escalate Modal knows what we are working with
    currentTicketId = ticketIdToEscalate;

    // Show Modal
    const escalateModal = document.getElementById('escalateModal');
    if (!escalateModal) {
        console.error("Escalate modal not found in DOM");
        return;
    }
    escalateModal.style.display = 'flex';

    const ticket = ticketsArray.find(t => t.id === currentTicketId);
    if (!ticket) {
        console.error("Ticket data not found for escalation");
        return;
    }

    // Ensure prerequisite data is loaded
    await fetchCurrentUserRole();
    await loadDepartments();

    // Populate Modal Info
    document.getElementById('escTicketTitle').textContent = ticket.title;
    document.getElementById('escalationReason').value = '';

    // Handle Role Logic
    const actionSelect = document.getElementById('escalationAction');
    const internalOption = actionSelect.querySelector('option[value="internal"]');

    if (currentUserRole === 'SENIOR') {
        // Seniors can only transfer, not escalate internally
        if (internalOption) internalOption.style.display = 'none';
        actionSelect.value = 'transfer';
    } else {
        // Normal Staff can do both
        if (internalOption) internalOption.style.display = 'block';
        actionSelect.value = 'internal';
    }

    toggleDepartmentDropdown();
}

function closeEscalateModal() {
    const modal = document.getElementById('escalateModal');
    if (modal) modal.style.display = 'none';
}

function toggleDepartmentDropdown() {
    const action = document.getElementById('escalationAction').value;
    const deptGroup = document.getElementById('departmentSelectGroup');
    if (action === 'transfer') {
        deptGroup.style.display = 'block';
    } else {
        deptGroup.style.display = 'none';
    }
}

async function submitEscalation() {
    if (!currentTicketId) return;

    const action = document.getElementById('escalationAction').value;
    const reason = document.getElementById('escalationReason').value;

    if (!reason.trim()) {
        alert('Please provide a reason for this action.');
        return;
    }

    const payload = { reason: reason };

    if (action === 'transfer') {
        const targetDept = document.getElementById('targetDepartment').value;
        if (!targetDept) {
            alert('Please select a destination department.');
            return;
        }
        payload.target_department_id = targetDept;
    }

    try {
        const response = await fetch(`/api/v1/tickets/${currentTicketId}/escalate_ticket/`, {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('access_token')}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(payload)
        });

        if (response.ok) {
            const data = await response.json();
            alert(data.message);
            closeEscalateModal();
            // Try to refresh data depending on which page we're on
            if (typeof loadStaffDashboardData === 'function') {
                loadStaffDashboardData();
            } else if (typeof loadTickets === 'function') {
                loadTickets(typeof currentPage !== 'undefined' ? currentPage : 1);
            }
        } else {
            const errorData = await response.json();
            alert('Error: ' + JSON.stringify(errorData));
        }
    } catch (error) {
        console.error('Error submitting escalation:', error);
        alert('An error occurred while communicating with the server.');
    }
}

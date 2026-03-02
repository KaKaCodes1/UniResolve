document.addEventListener('DOMContentLoaded', () => {
    // DOM Elements
    const addDeptForm = document.getElementById('addDepartmentForm');
    const deptNameInput = document.getElementById('departmentName');
    const tableBody = document.getElementById('departmentsTableBody');
    const countElement = document.getElementById('departmentsCount');
    const addDeptBtn = document.getElementById('addDeptBtn');

    // Fetch initial data
    loadDepartments();

    if (addDeptForm) {
        addDeptForm.addEventListener('submit', handleAddDepartment);
    }


    // Fetch all departments from the API
    async function loadDepartments() {
        showLoading();
        try {
            const response = await fetch('/api/v1/orgs/departments/', {
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('access_token')}`
                }
            });

            if (!response.ok) throw new Error('Failed to fetch departments');

            const data = await response.json();
            renderDepartments(data);
        } catch (error) {
            console.error('Error fetching departments:', error);
            showError('Failed to load departments. Please try again later.');
            // For now, render empty state if it fails since the API doesn't exist yet
            renderDepartments([]);
        }
    }

    // Render the departments list
    function renderDepartments(departments) {
        // Update count
        const count = departments.length;
        countElement.textContent = `${count} department${count !== 1 ? 's' : ''} in the system`;

        tableBody.innerHTML = '';

        if (departments.length === 0) {
            const tr = document.createElement('tr');
            tr.innerHTML = `<td colspan="2" class="text-center empty-state">No departments found. Add one above.</td>`;
            tableBody.appendChild(tr);
            return;
        }

        departments.forEach(dept => {
            const tr = document.createElement('tr');
            tr.setAttribute('data-id', dept.id);
            tr.innerHTML = `
                <td class="col-name">
                    <span class="dept-name-display">${dept.department_name}</span>
                    <input type="text" class="dept-name-input hidden" value="${dept.department_name}">
                </td>
                <td class="col-actions">
                    <button class="action-btn edit-btn" title="Edit Department" onclick="toggleEdit(${dept.id}, this)">Edit</button>
                    <button class="action-btn save-btn hidden" title="Save Changes" onclick="saveEdit(${dept.id}, this)">Save</button>
                    <button class="action-btn cancel-btn hidden" title="Cancel Edit" onclick="cancelEditMode(this)">Cancel</button>
                    <button class="action-btn delete-btn" title="Delete Department" onclick="deleteDepartment(${dept.id})">
                        <i class="fa-regular fa-trash-can"></i>
                    </button>
                </td>
            `;
            tableBody.appendChild(tr);
        });
    }

    // Handle adding a new department
    async function handleAddDepartment(e) {
        e.preventDefault();

        const newName = deptNameInput.value.trim();
        if (!newName) return;

        // Set loading state on button
        const originalBtnHTML = addDeptBtn.innerHTML;
        addDeptBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Adding...';
        addDeptBtn.disabled = true;

        try {
            const response = await fetch('/api/v1/orgs/departments/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${localStorage.getItem('access_token')}`
                },
                body: JSON.stringify({ department_name: newName })
            });

            if (!response.ok) {
                const data = await response.json();
                throw new Error(data.error || 'Failed to add department');
            }

            // Reset form and reload list
            addDeptForm.reset();
            loadDepartments();
            alert('Department added successfully', 'success');
        } catch (error) {
            console.error('Error adding department:', error);
            alert(error.message, 'error');
        } finally {
            addDeptBtn.innerHTML = originalBtnHTML;
            addDeptBtn.disabled = false;
        }
    }

    // Global Methods for Inline Actions

    window.toggleEdit = function (id, btnElement) {
        const row = btnElement.closest('tr');
        const displaySpan = row.querySelector('.dept-name-display');
        const inputField = row.querySelector('.dept-name-input');
        const editBtn = row.querySelector('.edit-btn');
        const saveBtn = row.querySelector('.save-btn');
        const cancelBtn = row.querySelector('.cancel-btn');
        const deleteBtn = row.querySelector('.delete-btn');

        // Toggle visibility
        displaySpan.classList.add('hidden');
        inputField.classList.remove('hidden');
        editBtn.classList.add('hidden');
        saveBtn.classList.remove('hidden');
        cancelBtn.classList.remove('hidden');
        deleteBtn.classList.add('hidden');

        // Focus and select input
        inputField.focus();
        // Optional: cancel edit if clicking outside or pressing escape
        inputField.addEventListener('keyup', (e) => {
            if (e.key === 'Escape') {
                cancelEdit(row);
            } else if (e.key === 'Enter') {
                saveEdit(id, saveBtn);
            }
        });
    };

    window.cancelEditMode = function (btnElement) {
        cancelEdit(btnElement.closest('tr'));
    };

    function cancelEdit(row) {
        const displaySpan = row.querySelector('.dept-name-display');
        const inputField = row.querySelector('.dept-name-input');
        const editBtn = row.querySelector('.edit-btn');
        const saveBtn = row.querySelector('.save-btn');
        const cancelBtn = row.querySelector('.cancel-btn');
        const deleteBtn = row.querySelector('.delete-btn');

        // Reset input value to what it currently is
        inputField.value = displaySpan.textContent;

        displaySpan.classList.remove('hidden');
        inputField.classList.add('hidden');
        editBtn.classList.remove('hidden');
        saveBtn.classList.add('hidden');
        cancelBtn.classList.add('hidden');
        deleteBtn.classList.remove('hidden');
    }

    window.saveEdit = async function (id, btnElement) {
        const row = btnElement.closest('tr');
        const inputField = row.querySelector('.dept-name-input');
        const newName = inputField.value.trim();

        if (!newName) {
            alert('Department name cannot be empty', 'error');
            return;
        }

        // Set button loading state
        btnElement.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i>';
        btnElement.disabled = true;
        inputField.disabled = true;

        try {
            // Replace with actual API endpoint later
            const response = await fetch(`/api/v1/orgs/departments/${id}/`, {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${localStorage.getItem('access_token')}`
                },
                body: JSON.stringify({ department_name: newName })
            });

            if (!response.ok) {
                const data = await response.json();
                throw new Error(data.error || 'Failed to update department');
            }

            // Update UI success state
            const displaySpan = row.querySelector('.dept-name-display');
            displaySpan.textContent = newName;
            alert('Department updated successfully', 'success');

            // Toggle back to read mode
            cancelEdit(row);
        } catch (error) {
            console.error('Error updating department:', error);
            alert(error.message, 'error');
        } finally {
            btnElement.innerHTML = 'Save';
            btnElement.disabled = false;
            inputField.disabled = false;
        }
    };

    window.deleteDepartment = async function (id) {
        if (!confirm('Are you sure you want to delete this department? This action cannot be undone.')) {
            return;
        }

        try {
            // Replace with actual API endpoint later
            const response = await fetch(`/api/v1/orgs/departments/${id}/`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('access_token')}`
                }
            });

            if (!response.ok) {
                const data = await response.json();
                throw new Error(data.error || 'Failed to delete department');
            }

            alert('Department deleted successfully', 'success');
            loadDepartments(); // Reload the list
        } catch (error) {
            console.error('Error deleting department:', error);
            alert(error.message, 'error');
        }
    };

    // --- Helper UI Functions ---

    function showLoading() {
        tableBody.innerHTML = `
            <tr id="loadingDepartmentsRow">
                <td colspan="2" class="text-center">
                    <i class="fa-solid fa-spinner fa-spin"></i> Loading departments...
                </td>
            </tr>
        `;
    }

    function showError(message) {
        tableBody.innerHTML = `
            <tr>
                <td colspan="2" class="text-center empty-state text-danger">${message}</td>
            </tr>
        `;
    }

    // function showToast(message, type = 'info') {
    //     // We'll use a simple alert for now, but a real toast should be used in production
    //     // Assuming there isn't a global toast system based on current files
    //     // But if there is, replace this with the global toast function
    //     const toastDiv = document.createElement('div');
    //     toastDiv.className = `custom-toast ${type}`;
    //     toastDiv.textContent = message;

    //     // Basic styling for the isolated toast directly injected
    //     Object.assign(toastDiv.style, {
    //         position: 'fixed',
    //         bottom: '20px',
    //         right: '20px',
    //         padding: '12px 24px',
    //         background: type === 'error' ? '#c62828' : '#2e7d32',
    //         color: 'white',
    //         borderRadius: '4px',
    //         boxShadow: '0 4px 6px rgba(0,0,0,0.1)',
    //         zIndex: '9999',
    //         transition: 'opacity 0.3s ease'
    //     });

    //     document.body.appendChild(toastDiv);

    //     setTimeout(() => {
    //         toastDiv.style.opacity = '0';
    //         setTimeout(() => toastDiv.remove(), 300);
    //     }, 3000);
    // }
});

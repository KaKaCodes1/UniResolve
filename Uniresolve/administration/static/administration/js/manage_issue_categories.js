document.addEventListener('DOMContentLoaded', () => {
    // DOM Elements
    const addIssueCategoryForm = document.getElementById('addIssueCategoryForm');
    const issueCategoryNameInput = document.getElementById('issueCategoryName');
    const tableBody = document.getElementById('issueCategoriesTableBody');
    const countElement = document.getElementById('issueCategoriesCount');
    const addIssueCategoryBtn = document.getElementById('addIssueCategoryBtn');
    let departmentsLoaded = false;
    let allDepartments = [];

    // Fetch initial data - Await departments before courses
    async function initialize() {
        await loadDepartments();
        loadIssueCategories();
    }
    initialize();

    if (addIssueCategoryForm) {
        addIssueCategoryForm.addEventListener('submit', handleAddIssueCategory);
    }


    // Fetch all departments from the API for the select dropdown
    async function loadDepartments() {
        if (departmentsLoaded) return;

        try {
            const response = await fetch('/api/v1/orgs/departments/', {
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('access_token')}`
                }
            });

            if (response.ok) {
                allDepartments = await response.json();
                departmentsLoaded = true;
                const select = document.getElementById('selectDepartment');
                allDepartments.forEach(dept => {
                    const option = document.createElement('option');
                    option.value = dept.id;
                    option.textContent = dept.department_name;
                    select.appendChild(option);
                });
            }
        } catch (error) {
            console.error('Error fetching departments:', error);
            showError('Failed to load departments. Please try again later.');
        }
    }

    // Fetch all issue categories from the API
    async function loadIssueCategories() {
        showLoading();
        try {
            const response = await fetch('/api/v1/orgs/categories/', {
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('access_token')}`
                }
            });

            if (!response.ok) throw new Error('Failed to fetch issue categories');

            const data = await response.json();
            renderIssueCategories(data);
        } catch (error) {
            console.error('Error fetching issue categories:', error);
            showError('Failed to load issue categories. Please try again later.');
        } finally {
            hideLoading();
        }
    }

    // Render the issue categories list
    function renderIssueCategories(issueCategories) {
        // Update count
        const count = issueCategories.length;
        countElement.textContent = `${count} issue category${count !== 1 ? 's' : ''} in the system`;

        tableBody.innerHTML = '';

        if (issueCategories.length === 0) {
            const tr = document.createElement('tr');
            tr.innerHTML = `<td colspan="5" class="text-center empty-state">No issue categories found. Add one above.</td>`;
            tableBody.appendChild(tr);
            return;
        }

        issueCategories.forEach(issueCategory => {
            const tr = document.createElement('tr');
            tr.setAttribute('data-id', issueCategory.id);
            tr.innerHTML = `
                <td class="col-name">
                    <span class="issue-category-name-display">${issueCategory.category_name}</span>
                    <input type="text" class="issue-category-name-input hidden" value="${issueCategory.category_name}">
                </td>
                <td class="col-name">
                    <span class="issue-category-department-display">${issueCategory.department_name || 'Global (Academic)'}</span>
                    <select class="issue-category-department-select hidden">
                        <option value="" ${!issueCategory.department ? 'selected' : ''}>-- No Department (Global/Academic) --</option>
                        ${allDepartments.map(dept => `<option value="${dept.id}" ${dept.id === issueCategory.department ? 'selected' : ''}>${dept.department_name}</option>`).join('')}
                    </select>
                </td>
                <td class="col-name">
                    <span class="issue-category-is-academic-display">${issueCategory.is_academic ? 'Yes' : 'No'}</span>
                    <select class="issue-category-is-academic-select hidden">
                        <option value="true" ${issueCategory.is_academic === true ? 'selected' : ''}>Yes</option>
                        <option value="false" ${issueCategory.is_academic === false ? 'selected' : ''}>No</option>
                    </select>
                </td>
                <td class="col-name">
                    <span class="issue-category-timeframe-display">${issueCategory.resolution_timeframe} hrs</span>
                    <input type="number" class="issue-category-timeframe-input hidden" value="${issueCategory.resolution_timeframe}">
                </td>
                <td class="col-actions">
                    <button class="action-btn edit-btn" title="Edit Issue Category" onclick="toggleEdit(${issueCategory.id}, this)">Edit</button>
                    <button class="action-btn save-btn hidden" title="Save Changes" onclick="saveEdit(${issueCategory.id}, this)">Save</button>
                    <button class="action-btn cancel-btn hidden" title="Cancel Edit" onclick="cancelEditMode(this)">Cancel</button>
                    <button class="action-btn delete-btn" title="Delete Issue Category" onclick="deleteIssueCategory(${issueCategory.id})">
                        <i class="fa-regular fa-trash-can"></i>
                    </button>
                </td>
            `;
            tableBody.appendChild(tr);
        });
    }

    // Handle adding a new issue category
    async function handleAddIssueCategory(e) {
        e.preventDefault();

        const newName = issueCategoryNameInput.value.trim();
        const departmentId = document.getElementById('selectDepartment').value || null;
        const isAcademic = document.getElementById('isAcademic').value === 'true';
        const timeframe = document.getElementById('timeframe').value;
        if (!newName) return;
        if (!isAcademic && !departmentId) {
            alert('Department is required for non-academic categories.', 'error');
            return;
        }

        // Set loading state on button
        const originalBtnHTML = addIssueCategoryBtn.innerHTML;
        addIssueCategoryBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Adding...';
        addIssueCategoryBtn.disabled = true;

        try {
            const response = await fetch('/api/v1/orgs/categories/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${localStorage.getItem('access_token')}`
                },
                body: JSON.stringify({ category_name: newName, department: departmentId, is_academic: isAcademic, resolution_timeframe: timeframe })
            });

            if (!response.ok) {
                const data = await response.json();
                throw new Error(data.error || 'Failed to add issue category');
            }

            // Reset form and reload list
            addIssueCategoryForm.reset();
            loadIssueCategories();
            alert('Issue category added successfully', 'success');
        } catch (error) {
            console.error('Error adding issue category:', error);
            alert(error.message, 'error');
        } finally {
            addIssueCategoryBtn.innerHTML = originalBtnHTML;
            addIssueCategoryBtn.disabled = false;
        }
    }

    // Global Methods for Inline Actions

    window.toggleEdit = function (id, btnElement) {
        const row = btnElement.closest('tr');
        const displaySpan = row.querySelector('.issue-category-name-display');
        const inputField = row.querySelector('.issue-category-name-input');
        const deptSelect = row.querySelector('.issue-category-department-select');
        const deptDisplaySpan = row.querySelector('.issue-category-department-display');
        const isAcademicSelect = row.querySelector('.issue-category-is-academic-select');
        const isAcademicDisplay = row.querySelector('.issue-category-is-academic-display');
        const timeframeInput = row.querySelector('.issue-category-timeframe-input');
        const timeframeDisplay = row.querySelector('.issue-category-timeframe-display');
        const editBtn = row.querySelector('.edit-btn');
        const saveBtn = row.querySelector('.save-btn');
        const cancelBtn = row.querySelector('.cancel-btn');
        const deleteBtn = row.querySelector('.delete-btn');

        // Toggle visibility
        displaySpan.classList.add('hidden');
        deptDisplaySpan.classList.add('hidden');
        inputField.classList.remove('hidden');
        deptSelect.classList.remove('hidden');
        isAcademicDisplay.classList.add('hidden');
        isAcademicSelect.classList.remove('hidden');
        timeframeDisplay.classList.add('hidden');
        timeframeInput.classList.remove('hidden');
        editBtn.classList.add('hidden');
        saveBtn.classList.remove('hidden');
        cancelBtn.classList.remove('hidden');
        deleteBtn.classList.add('hidden');


        // Focus and select input
        inputField.focus();
        // Cancel edit by pressing escape and save by pressing enter
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
        const displaySpan = row.querySelector('.issue-category-name-display');
        const inputField = row.querySelector('.issue-category-name-input');
        const deptSelect = row.querySelector('.issue-category-department-select');
        const deptDisplaySpan = row.querySelector('.issue-category-department-display');
        const isAcademicSelect = row.querySelector('.issue-category-is-academic-select');
        const isAcademicDisplay = row.querySelector('.issue-category-is-academic-display');
        const timeframeInput = row.querySelector('.issue-category-timeframe-input');
        const timeframeDisplay = row.querySelector('.issue-category-timeframe-display');
        const editBtn = row.querySelector('.edit-btn');
        const saveBtn = row.querySelector('.save-btn');
        const cancelBtn = row.querySelector('.cancel-btn');
        const deleteBtn = row.querySelector('.delete-btn');

        // Reset input value to what it currently is
        inputField.value = displaySpan.textContent;

        // Reset select dropdown to what is currently displayed
        const currentDeptName = deptDisplaySpan.textContent;
        if (currentDeptName === 'Global (Academic)') {
            deptSelect.value = '';
        } else {
            Array.from(deptSelect.options).forEach(opt => {
                if (opt.textContent === currentDeptName) {
                    deptSelect.value = opt.value;
                }
            });
        }

        // Reset isAcademicSelect
        const currentIsAcademic = isAcademicDisplay.textContent;
        isAcademicSelect.value = currentIsAcademic === 'Yes' ? 'true' : 'false';

        // Reset timeframeInput
        timeframeInput.value = timeframeDisplay.textContent.replace(' hrs', '').trim();

        displaySpan.classList.remove('hidden');
        deptDisplaySpan.classList.remove('hidden');
        inputField.classList.add('hidden');
        deptSelect.classList.add('hidden');
        isAcademicDisplay.classList.remove('hidden');
        isAcademicSelect.classList.add('hidden');
        timeframeDisplay.classList.remove('hidden');
        timeframeInput.classList.add('hidden');
        editBtn.classList.remove('hidden');
        saveBtn.classList.add('hidden');
        cancelBtn.classList.add('hidden');
        deleteBtn.classList.remove('hidden');
    }

    window.saveEdit = async function (id, btnElement) {
        const row = btnElement.closest('tr');
        const inputField = row.querySelector('.issue-category-name-input');
        const deptSelect = row.querySelector('.issue-category-department-select');
        const isAcademicSelect = row.querySelector('.issue-category-is-academic-select');
        const timeframeInput = row.querySelector('.issue-category-timeframe-input');
        const newName = inputField.value.trim();
        const newDeptId = deptSelect.value || null;
        const newIsAcademic = isAcademicSelect.value === 'true';
        const newTimeframe = timeframeInput.value;

        if (!newName) {
            alert('Issue category name cannot be empty', 'error');
            return;
        }
        if (!newIsAcademic && !newDeptId) {
            alert('Department is required for non-academic categories', 'error');
            return;
        }

        // Set button loading state
        btnElement.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i>';
        btnElement.disabled = true;
        inputField.disabled = true;
        deptSelect.disabled = true;
        isAcademicSelect.disabled = true;
        timeframeInput.disabled = true;

        try {
            const response = await fetch(`/api/v1/orgs/categories/${id}/`, {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${localStorage.getItem('access_token')}`
                },
                body: JSON.stringify({ category_name: newName, department: newDeptId, is_academic: newIsAcademic, resolution_timeframe: newTimeframe })
            });

            if (!response.ok) {
                const data = await response.json();
                throw new Error(data.error || 'Failed to update issue category');
            }

            // Update UI success state
            const displaySpan = row.querySelector('.issue-category-name-display');
            const deptDisplaySpan = row.querySelector('.issue-category-department-display');
            const isAcademicDisplay = row.querySelector('.issue-category-is-academic-display');
            const timeframeDisplay = row.querySelector('.issue-category-timeframe-display');
            displaySpan.textContent = newName;
            deptDisplaySpan.textContent = deptSelect.value ? deptSelect.options[deptSelect.selectedIndex].text : 'Global (Academic)';
            isAcademicDisplay.textContent = newIsAcademic === true ? 'Yes' : 'No';
            timeframeDisplay.textContent = newTimeframe + ' hrs';
            alert('Issue category updated successfully', 'success');

            // Toggle back to read mode
            cancelEdit(row);
        } catch (error) {
            console.error('Error updating issue category:', error);
            alert(error.message, 'error');
        } finally {
            btnElement.innerHTML = 'Save';
            btnElement.disabled = false;
            inputField.disabled = false;
            deptSelect.disabled = false;
            isAcademicSelect.disabled = false;
            timeframeInput.disabled = false;
        }
    };

    window.deleteIssueCategory = async function (id) {
        if (!confirm('Are you sure you want to delete this issue category? This action cannot be undone.')) {
            return;
        }

        try {
            const response = await fetch(`/api/v1/orgs/categories/${id}/`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('access_token')}`
                }
            });

            if (!response.ok) {
                const data = await response.json();
                throw new Error(data.error || 'Failed to delete issue category');
            }

            alert('Issue category deleted successfully', 'success');
            loadIssueCategories(); // Reload the list
        } catch (error) {
            console.error('Error deleting issue category:', error);
            alert(error.message, 'error');
        }
    };

    // --- Helper UI Functions ---

    function showLoading() {
        tableBody.innerHTML = `
            <tr id="loadingIssueCategoriesRow">
                <td colspan="5" class="text-center">
                    <i class="fa-solid fa-spinner fa-spin"></i> Loading issue categories...
                </td>
            </tr>
        `;
    }

    function showError(message) {
        tableBody.innerHTML = `
            <tr>
                <td colspan="5" class="text-center empty-state text-danger">${message}</td>
            </tr>
        `;
    }

});

document.addEventListener('DOMContentLoaded', () => {
    // DOM Elements
    const addCourseForm = document.getElementById('addCourseForm');
    const courseNameInput = document.getElementById('courseName');
    const tableBody = document.getElementById('coursesTableBody');
    const countElement = document.getElementById('coursesCount');
    const addCourseBtn = document.getElementById('addCourseBtn');
    let departmentsLoaded = false;
    let allDepartments = [];

    // Fetch initial data - Await departments before courses
    async function initialize() {
        await loadDepartments();
        loadCourses();
    }
    initialize();

    if (addCourseForm) {
        addCourseForm.addEventListener('submit', handleAddCourse);
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

    // Fetch all courses from the API
    async function loadCourses() {
        showLoading();
        try {
            const response = await fetch('/api/v1/orgs/courses/', {
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('access_token')}`
                }
            });

            if (!response.ok) throw new Error('Failed to fetch courses');

            const data = await response.json();
            renderCourses(data);
        } catch (error) {
            console.error('Error fetching courses:', error);
            showError('Failed to load courses. Please try again later.');
        } finally {
            hideLoading();
        }
    }

    // Render the courses list
    function renderCourses(courses) {
        // Update count
        const count = courses.length;
        countElement.textContent = `${count} course${count !== 1 ? 's' : ''} in the system`;

        tableBody.innerHTML = '';

        if (courses.length === 0) {
            const tr = document.createElement('tr');
            tr.innerHTML = `<td colspan="3" class="text-center empty-state">No courses found. Add one above.</td>`;
            tableBody.appendChild(tr);
            return;
        }

        courses.forEach(course => {
            const tr = document.createElement('tr');
            tr.setAttribute('data-id', course.id);
            tr.innerHTML = `
                <td class="col-name">
                    <span class="course-name-display">${course.course_name}</span>
                    <input type="text" class="course-name-input hidden" value="${course.course_name}">
                </td>
                <td class="col-name">
                    <span class="course-department-display">${course.department_name}</span>
                    <select class="course-department-select hidden">
                        ${allDepartments.map(dept => `<option value="${dept.id}" ${dept.id === course.department ? 'selected' : ''}>${dept.department_name}</option>`).join('')}
                    </select>
                </td>
                <td class="col-actions">
                    <button class="action-btn edit-btn" title="Edit Course" onclick="toggleEdit(${course.id}, this)">Edit</button>
                    <button class="action-btn save-btn hidden" title="Save Changes" onclick="saveEdit(${course.id}, this)">Save</button>
                    <button class="action-btn cancel-btn hidden" title="Cancel Edit" onclick="cancelEditMode(this)">Cancel</button>
                    <button class="action-btn delete-btn" title="Delete Course" onclick="deleteCourse(${course.id})">
                        <i class="fa-regular fa-trash-can"></i>
                    </button>
                </td>
            `;
            tableBody.appendChild(tr);
        });
    }

    // Handle adding a new course
    async function handleAddCourse(e) {
        e.preventDefault();

        const newName = courseNameInput.value.trim();
        const departmentId = document.getElementById('selectDepartment').value;
        if (!newName || !departmentId) return;

        // Set loading state on button
        const originalBtnHTML = addCourseBtn.innerHTML;
        addCourseBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Adding...';
        addCourseBtn.disabled = true;

        try {
            const response = await fetch('/api/v1/orgs/courses/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${localStorage.getItem('access_token')}`
                },
                body: JSON.stringify({ course_name: newName, department: departmentId })
            });

            if (!response.ok) {
                const data = await response.json();
                throw new Error(data.error || 'Failed to add course');
            }

            // Reset form and reload list
            addCourseForm.reset();
            loadCourses();
            alert('Course added successfully', 'success');
        } catch (error) {
            console.error('Error adding course:', error);
            alert(error.message, 'error');
        } finally {
            addCourseBtn.innerHTML = originalBtnHTML;
            addCourseBtn.disabled = false;
        }
    }

    // Global Methods for Inline Actions

    window.toggleEdit = function (id, btnElement) {
        const row = btnElement.closest('tr');
        const displaySpan = row.querySelector('.course-name-display');
        const inputField = row.querySelector('.course-name-input');
        const deptSelect = row.querySelector('.course-department-select');
        const deptDisplaySpan = row.querySelector('.course-department-display');
        const editBtn = row.querySelector('.edit-btn');
        const saveBtn = row.querySelector('.save-btn');
        const cancelBtn = row.querySelector('.cancel-btn');
        const deleteBtn = row.querySelector('.delete-btn');

        // Toggle visibility
        displaySpan.classList.add('hidden');
        deptDisplaySpan.classList.add('hidden');
        inputField.classList.remove('hidden');
        deptSelect.classList.remove('hidden');
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
        const displaySpan = row.querySelector('.course-name-display');
        const inputField = row.querySelector('.course-name-input');
        const deptSelect = row.querySelector('.course-department-select');
        const deptDisplaySpan = row.querySelector('.course-department-display');
        const editBtn = row.querySelector('.edit-btn');
        const saveBtn = row.querySelector('.save-btn');
        const cancelBtn = row.querySelector('.cancel-btn');
        const deleteBtn = row.querySelector('.delete-btn');

        // Reset input value to what it currently is
        inputField.value = displaySpan.textContent;

        // Reset select dropdown to what is currently displayed
        const currentDeptName = deptDisplaySpan.textContent;
        Array.from(deptSelect.options).forEach(opt => {
            if (opt.textContent === currentDeptName) {
                deptSelect.value = opt.value;
            }
        });

        displaySpan.classList.remove('hidden');
        deptDisplaySpan.classList.remove('hidden');
        inputField.classList.add('hidden');
        deptSelect.classList.add('hidden');
        editBtn.classList.remove('hidden');
        saveBtn.classList.add('hidden');
        cancelBtn.classList.add('hidden');
        deleteBtn.classList.remove('hidden');
    }

    window.saveEdit = async function (id, btnElement) {
        const row = btnElement.closest('tr');
        const inputField = row.querySelector('.course-name-input');
        const deptSelect = row.querySelector('.course-department-select');
        const newName = inputField.value.trim();
        const newDeptId = deptSelect.value;

        if (!newName) {
            alert('Course name cannot be empty', 'error');
            return;
        }

        // Set button loading state
        btnElement.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i>';
        btnElement.disabled = true;
        inputField.disabled = true;
        deptSelect.disabled = true;

        try {
            const response = await fetch(`/api/v1/orgs/courses/${id}/`, {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${localStorage.getItem('access_token')}`
                },
                body: JSON.stringify({ course_name: newName, department: newDeptId })
            });

            if (!response.ok) {
                const data = await response.json();
                throw new Error(data.error || 'Failed to update course');
            }

            // Update UI success state
            const displaySpan = row.querySelector('.course-name-display');
            const deptDisplaySpan = row.querySelector('.course-department-display');
            displaySpan.textContent = newName;
            deptDisplaySpan.textContent = deptSelect.options[deptSelect.selectedIndex].text;
            alert('Course updated successfully', 'success');

            // Toggle back to read mode
            cancelEdit(row);
        } catch (error) {
            console.error('Error updating course:', error);
            alert(error.message, 'error');
        } finally {
            btnElement.innerHTML = 'Save';
            btnElement.disabled = false;
            inputField.disabled = false;
            deptSelect.disabled = false;
        }
    };

    window.deleteCourse = async function (id) {
        if (!confirm('Are you sure you want to delete this course? This action cannot be undone.')) {
            return;
        }

        try {
            const response = await fetch(`/api/v1/orgs/courses/${id}/`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('access_token')}`
                }
            });

            if (!response.ok) {
                const data = await response.json();
                throw new Error(data.error || 'Failed to delete course');
            }

            alert('Course deleted successfully', 'success');
            loadCourses(); // Reload the list
        } catch (error) {
            console.error('Error deleting course:', error);
            alert(error.message, 'error');
        }
    };

    // --- Helper UI Functions ---

    function showLoading() {
        tableBody.innerHTML = `
            <tr id="loadingCoursesRow">
                <td colspan="3" class="text-center">
                    <i class="fa-solid fa-spinner fa-spin"></i> Loading courses...
                </td>
            </tr>
        `;
    }

    function showError(message) {
        tableBody.innerHTML = `
            <tr>
                <td colspan="3" class="text-center empty-state text-danger">${message}</td>
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

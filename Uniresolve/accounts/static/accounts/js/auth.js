// Utility to get CSRF Token from cookies
function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

// Password Visibility Toggle
function togglePassword(inputId, icon) {
    const input = document.getElementById(inputId);
    if (input.type === "password") {
        input.type = "text";
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
    } else {
        input.type = "password";
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
    }
}

// Password Strength Checklist
document.getElementById('password').addEventListener('input', function () {
    const password = this.value;

    // Checklist Logic
    updateChecklist('length-check', password.length >= 8);
    updateChecklist('number-check', /[0-9]/.test(password));
    updateChecklist('upper-check', /[A-Z]/.test(password));
    updateChecklist('lower-check', /[a-z]/.test(password));
    updateChecklist('symbol-check', /[!@#$%^&*(),.?":{}|<>]/.test(password));
});

function updateChecklist(elementId, isValid) {
    const el = document.getElementById(elementId);
    const icon = el.querySelector('i');

    if (isValid) {
        el.classList.remove('invalid');
        el.classList.add('valid');
        icon.classList.remove('fa-xmark');
        icon.classList.add('fa-check');
    } else {
        el.classList.remove('valid');
        el.classList.add('invalid');
        icon.classList.remove('fa-check');
        icon.classList.add('fa-xmark');
    }
}

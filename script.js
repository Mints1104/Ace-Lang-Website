
document.addEventListener('DOMContentLoaded', function() {
    // =========================
    // Contact Navigation Fix
    // =========================
    // Fix contact button navigation to use same-page contact sections
    function fixContactNavigation() {
        // Get all contact links that are incorrectly pointing to index.html#contact
        const contactLinks = document.querySelectorAll('a[href*="index.html#contact"]');
        
        contactLinks.forEach(link => {
            // Always use same-page contact section navigation
            link.href = '#contact';
        });
    }
    
    // Apply the fix immediately
    fixContactNavigation();

    // =========================
    // Breadcrumb Navigation System
    // =========================

    // Generate breadcrumbs based on current page
    function generateBreadcrumbs() {
        const breadcrumbsContainer = document.querySelector('.breadcrumbs-list');
        if (!breadcrumbsContainer) return;

        const currentPath = window.location.pathname;
        const pathSegments = currentPath.split('/').filter(segment => segment);
        
        // Check if we're on the home page (either / or /index.html)
        const isHomePage = currentPath === '/' || currentPath === '/index.html' || pathSegments.length === 0;
        
        // Clear existing breadcrumbs
        breadcrumbsContainer.innerHTML = '';
        
        // If we're on the home page, don't show breadcrumbs at all
        if (isHomePage) {
            return;
        }
        
        // Add home breadcrumb
        const homeItem = document.createElement('li');
        homeItem.className = 'breadcrumbs-item';
        homeItem.innerHTML = `
            <a href="/" class="breadcrumbs-link breadcrumbs-home">
                <i class="fas fa-home"></i>
                <span>Home</span>
            </a>
        `;
        breadcrumbsContainer.appendChild(homeItem);

        // Add breadcrumbs for each path segment
        let currentUrl = '';
        pathSegments.forEach((segment, index) => {
            // Skip index.html as it's the same as home
            if (segment === 'index.html') return;
            
            currentUrl += '/' + segment;

            // Convert segment to readable text
            let segmentText = segment
                .replace(/\.html$/, '') // Remove .html extension
                .replace(/-/g, ' ') // Replace hyphens with spaces
                .replace(/\b\w/g, l => l.toUpperCase()); // Capitalize first letter of each word

            // Special handling for common segments
            if (segment === 'languages') segmentText = 'Languages';
            if (segment === 'locations') segmentText = 'Locations';
            if (segment === 'careers') segmentText = 'Careers';

            // Create breadcrumb item
            const breadcrumbItem = document.createElement('li');
            breadcrumbItem.className = 'breadcrumbs-item';

            if (index === pathSegments.length - 1) {
                // Last item (current page)
                breadcrumbItem.innerHTML = `<span class="breadcrumbs-current">${segmentText}</span>`;
            } else {
                // Navigation item
                const link = document.createElement('a');
                link.href = currentUrl;
                link.className = 'breadcrumbs-link';
                link.textContent = segmentText;
                breadcrumbItem.appendChild(link);
            }

            breadcrumbsContainer.appendChild(breadcrumbItem);
        });
    }

    // Initialize breadcrumbs
    generateBreadcrumbs();

    // Enhanced notification system with better styling
    function showNotification(message, type = 'info') {
        // Remove existing notifications
        const existingNotifications = document.querySelectorAll('.notification');
        existingNotifications.forEach(notification => notification.remove());

        // Create notification element with improved styling
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.setAttribute('role', 'alert');
        notification.setAttribute('tabindex', '-1');
        notification.innerHTML = `
            <div class="notification-content">
                <span class="notification-message">${message}</span>
                <button class="notification-close" aria-label="Close notification">&times;</button>
            </div>
        `;

        // Add styles for notification
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${type === 'error' ? '#f56565' : type === 'success' ? '#48bb78' : '#3182ce'};
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 10000;
            max-width: 400px;
            animation: slideInRight 0.3s ease;
        `;

        document.body.appendChild(notification);
        notification.focus();

        // Close button functionality
        const closeButton = notification.querySelector('.notification-close');
        closeButton.addEventListener('click', () => {
            notification.style.animation = 'slideOutRight 0.3s ease';
            setTimeout(() => notification.remove(), 300);
        });

        // Auto-remove after 5 seconds
        setTimeout(() => {
            if (notification.parentNode) {
                notification.style.animation = 'slideOutRight 0.3s ease';
                setTimeout(() => notification.remove(), 300);
            }
        }, 5000);
    }

    // Add notification animations to CSS
    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideInRight {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        @keyframes slideOutRight {
            from { transform: translateX(0); opacity: 1; }
            to { transform: translateX(100%); opacity: 0; }
        }
    `;
    document.head.appendChild(style);

    // --- File Upload Handling ---
    // Handle all file inputs on the page
    const fileInputs = document.querySelectorAll('input[type="file"]');
    let selectedFilesMap = new Map(); // Map to store files for each input

    // Initialize file handling for each file input
    fileInputs.forEach(fileInput => {
        const inputId = fileInput.id;
        // Find the corresponding file list container
        let fileList = null;
        
        // Look for file list with matching ID pattern or fallback to any file-list in the same form group
        if (inputId === 'documents') {
            fileList = document.getElementById('fileList');
        } else if (inputId === 'cv') {
            fileList = document.getElementById('fileList'); // careers.html uses fileList for CV
        } else if (inputId === 'certificates') {
            fileList = document.getElementById('certFileList');
        } else {
            // Fallback: look for any file-list in the same form group
            fileList = fileInput.parentElement.querySelector('.file-list');
        }
        
        if (fileList) {
            // Initialize this file input's file storage
            selectedFilesMap.set(inputId, []);
            
            // Make file label clickable
            const fileLabel = fileInput.nextElementSibling;
            if (fileLabel && fileLabel.classList.contains('file-label')) {
                fileLabel.addEventListener('click', function(e) {
                    e.preventDefault();
                    fileInput.click();
                });
                fileLabel.style.cursor = 'pointer';
            }
            
            // Add change event listener
            fileInput.addEventListener('change', function(e) {
                handleFileChange(inputId, e.target.files, fileList);
            });
        }
    });

    function formatFileSize(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    }

    function getFileIcon(fileName) {
        const extension = fileName.split('.').pop().toLowerCase();
        if (['pdf'].includes(extension)) return { icon: 'fas fa-file-pdf', class: 'file-icon-pdf' };
        if (['doc', 'docx'].includes(extension)) return { icon: 'fas fa-file-word', class: 'file-icon-doc' };
        if (['jpg', 'jpeg', 'png', 'gif'].includes(extension)) return { icon: 'fas fa-file-image', class: 'file-icon-image' };
        if (['txt'].includes(extension)) return { icon: 'fas fa-file-alt', class: 'file-icon-text' };
        return { icon: 'fas fa-file', class: '' };
    }

    function validateFile(file) {
        const maxSize = 10 * 1024 * 1024; // 10MB
        const allowedTypes = [
            'application/pdf',
            'application/msword',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'text/plain',
            'image/jpeg',
            'image/jpg',
            'image/png'
        ];

        if (file.size > maxSize) {
            showNotification(`File "${file.name}" is too large. Maximum size is 10MB.`, 'error');
            return false;
        }

        if (!allowedTypes.includes(file.type)) {
            showNotification(`File type "${file.type}" is not allowed. Please use PDF, Word, Text, or Image files.`, 'error');
            return false;
        }

        return true;
    }

    function handleFileChange(inputId, files, fileList) {
        const selectedFiles = selectedFilesMap.get(inputId) || [];
        const newFiles = Array.from(files);
        
        newFiles.forEach(file => {
            if (validateFile(file)) {
                // Check if file already exists
                const exists = selectedFiles.some(existingFile => 
                    existingFile.name === file.name && existingFile.size === file.size
                );
                
                if (!exists) {
                    selectedFiles.push(file);
                } else {
                    showNotification(`File "${file.name}" is already selected.`, 'error');
                }
            }
        });
        
        // Limit total files
        if (selectedFiles.length > 5) {
            showNotification('Maximum 5 files allowed. Please remove some files.', 'error');
            selectedFiles.splice(5);
        }
        
        // Update the map
        selectedFilesMap.set(inputId, selectedFiles);
        
        // Update the file list display
        updateFileList(inputId, selectedFiles, fileList);
        
        // Update the file input
        const fileInput = document.getElementById(inputId);
        if (fileInput) {
            const dt = new DataTransfer();
            selectedFiles.forEach(file => dt.items.add(file));
            fileInput.files = dt.files;
        }
    }

    function updateFileList(inputId, files, fileList) {
        if (!fileList) return;
        
        fileList.innerHTML = '';
        
        files.forEach((file, index) => {
            const fileItem = document.createElement('div');
            fileItem.className = 'file-item';
            
            const fileIcon = getFileIcon(file.name);
            
            fileItem.innerHTML = `
                <div class="file-item-info">
                    <i class="${fileIcon.icon} ${fileIcon.class}"></i>
                    <span class="file-item-name">${file.name}</span>
                    <span class="file-item-size">(${formatFileSize(file.size)})</span>
                </div>
                <button type="button" class="file-remove" data-input="${inputId}" data-index="${index}" aria-label="Remove file">
                    <i class="fas fa-times"></i>
                </button>
            `;
            
            fileList.appendChild(fileItem);
        });

        // Add event listeners to remove buttons
        fileList.querySelectorAll('.file-remove').forEach(button => {
            button.addEventListener('click', function() {
                const inputId = this.dataset.input;
                const index = parseInt(this.dataset.index);
                const selectedFiles = selectedFilesMap.get(inputId) || [];
                
                selectedFiles.splice(index, 1);
                selectedFilesMap.set(inputId, selectedFiles);
                
                // Update the display
                updateFileList(inputId, selectedFiles, fileList);
                
                // Update the file input
                const fileInput = document.getElementById(inputId);
                if (fileInput) {
                    const dt = new DataTransfer();
                    selectedFiles.forEach(file => dt.items.add(file));
                    fileInput.files = dt.files;
                }
            });
        });
    }

    // Enhanced form validation with comprehensive rules
    function validateForm(formData) {
        const errors = [];
        const name = formData.get('name')?.trim() || '';
        const email = formData.get('email')?.trim() || '';
        const phone = formData.get('phone')?.trim() || '';
        const message = formData.get('message')?.trim() || '';

        // Name validation
        if (!name) {
            errors.push({ field: 'name', message: 'Name is required' });
        } else if (name.length < 2) {
            errors.push({ field: 'name', message: 'Name must be at least 2 characters long' });
        } else if (name.length > 100) {
            errors.push({ field: 'name', message: 'Name must be less than 100 characters' });
        } else if (!/^[a-zA-Z\s\-'\.]+$/.test(name)) {
            errors.push({ field: 'name', message: 'Name can only contain letters, spaces, hyphens, apostrophes, and periods' });
        }

        // Email validation
        if (!email) {
            errors.push({ field: 'email', message: 'Email is required' });
        } else if (email.length > 254) {
            errors.push({ field: 'email', message: 'Email must be less than 254 characters' });
        } else {
            const emailRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
            if (!emailRegex.test(email)) {
                errors.push({ field: 'email', message: 'Please enter a valid email address' });
            }
        }

        // Phone validation (optional but validate if provided)
        if (phone && phone.length > 0) {
            if (phone.length < 10 || phone.length > 20) {
                errors.push({ field: 'phone', message: 'Phone number must be between 10 and 20 characters' });
            } else if (!/^[\+]?[0-9\s\-\(\)]+$/.test(phone)) {
                errors.push({ field: 'phone', message: 'Phone number can only contain numbers, spaces, hyphens, parentheses, and + symbol' });
            }
        }

        // Message validation
        if (!message) {
            errors.push({ field: 'message', message: 'Message is required' });
        } else if (message.length < 10) {
            errors.push({ field: 'message', message: 'Message must be at least 10 characters long' });
        } else if (message.length > 2000) {
            errors.push({ field: 'message', message: 'Message must be less than 2000 characters' });
        }

        return errors;
    }

    // --- Contact Form Handling ---
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        // Enhanced real-time validation with comprehensive feedback
        const inputs = contactForm.querySelectorAll('input, textarea');
        inputs.forEach(input => {
            // Add input event for real-time validation
            input.addEventListener('input', function() {
                // Mark field as interacted when user starts typing
                this.dataset.interacted = 'true';
                validateField(this, false); // Don't show errors on input, just validate
            });

            // Add blur event for detailed validation feedback
            input.addEventListener('blur', function() {
                // Mark field as interacted when user leaves the field
                this.dataset.interacted = 'true';
                validateField(this, true); // Show errors on blur
            });

            // Add focus event to clear previous states
            input.addEventListener('focus', function() {
                clearFieldState(this);
            });
        });

        // Enhanced field validation function
        function validateField(field, showErrors = true) {
            const fieldName = field.name;
            const value = field.value.trim();
            const fieldGroup = field.closest('.form-group');
            const errorElement = fieldGroup.querySelector('.field-error');
            
            // Check if user has interacted with this field
            const hasInteracted = field.dataset.interacted === 'true';
            
            // Clear previous states
            field.classList.remove('error', 'success');
            fieldGroup.classList.remove('error', 'success');
            
            // Remove existing error
            if (errorElement) {
                errorElement.remove();
            }

            // Validate based on field type
            let isValid = true;
            let errorMessage = '';
            let successMessage = '';

            switch(fieldName) {
                case 'name':
                    if (!value) {
                        isValid = false;
                        errorMessage = 'Name is required';
                    } else if (value.length < 2) {
                        isValid = false;
                        errorMessage = 'Name must be at least 2 characters';
                    } else if (value.length > 100) {
                        isValid = false;
                        errorMessage = 'Name must be less than 100 characters';
                    } else if (!/^[a-zA-Z\s\-'\.]+$/.test(value)) {
                        isValid = false;
                        errorMessage = 'Name can only contain letters, spaces, hyphens, apostrophes, and periods';
                    } else {
                        successMessage = 'Name looks good!';
                    }
                    break;

                case 'email':
                    if (!value) {
                        isValid = false;
                        errorMessage = 'Email is required';
                    } else if (value.length > 254) {
                        isValid = false;
                        errorMessage = 'Email must be less than 254 characters';
                    } else {
                        const emailRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
                        if (!emailRegex.test(value)) {
                            isValid = false;
                            errorMessage = 'Please enter a valid email address';
                        } else {
                            successMessage = 'Email format is valid!';
                        }
                    }
                    break;

                case 'phone':
                    if (value && value.length > 0) {
                        if (value.length < 10 || value.length > 20) {
                            isValid = false;
                            errorMessage = 'Phone number must be between 10 and 20 characters';
                        } else if (!/^[\+]?[0-9\s\-\(\)]+$/.test(value)) {
                            isValid = false;
                            errorMessage = 'Phone number must be between 10 and 20 characters';
                        } else {
                            successMessage = 'Phone number format is valid!';
                        }
                    }
                    break;

                case 'message':
                    if (!value) {
                        isValid = false;
                        errorMessage = 'Message is required';
                    } else if (value.length < 10) {
                        isValid = false;
                        errorMessage = 'Message must be at least 10 characters';
                    } else if (value.length > 2000) {
                        isValid = false;
                        errorMessage = 'Message must be less than 2000 characters';
                    } else {
                        successMessage = 'Message meets requirements!';
                    }
                    break;
            }

            // Apply visual states - only show errors if user has interacted AND we want to show errors
            if (!isValid && showErrors && hasInteracted) {
                field.classList.add('error');
                fieldGroup.classList.add('error');
                
                // Create error message
                const errorDiv = document.createElement('div');
                errorDiv.className = 'field-error';
                errorDiv.textContent = errorMessage;
                errorDiv.id = `${fieldName}-error`;
                fieldGroup.appendChild(errorDiv);
            } else if (isValid && value.length > 0) {
                field.classList.add('success');
                fieldGroup.classList.add('success');
            }
        }

        // Clear field validation state
        function clearFieldState(field) {
            const fieldGroup = field.closest('.form-group');
            const errorElement = fieldGroup.querySelector('.field-error');
            
            // Remove error/success classes when focusing
            field.classList.remove('error', 'success');
            fieldGroup.classList.remove('error', 'success');
            
            if (errorElement) {
                errorElement.remove();
            }
        }

        // Show form status messages
        function showFormStatus(message, type = 'info') {
            const formStatus = document.getElementById('formStatus');
            if (formStatus) {
                formStatus.textContent = message;
                formStatus.className = `form-status ${type}`;
                formStatus.style.display = 'block';
                
                // Auto-hide success messages after 5 seconds
                if (type === 'success') {
                    setTimeout(() => {
                        formStatus.style.display = 'none';
                    }, 5000);
                }
            }
        }

        // Show field-specific errors
        function showFieldErrors(errors) {
            errors.forEach(error => {
                const field = contactForm.querySelector(`[name="${error.field}"]`);
                if (field) {
                    // Mark field as interacted when showing submission errors
                    field.dataset.interacted = 'true';
                    validateField(field, true);
                }
            });
        }

        contactForm.addEventListener('submit', async function(e) {
            e.preventDefault();

            const formData = new FormData(contactForm);
            const errors = validateForm(formData);

            if (errors.length > 0) {
                // Show field-specific errors
                showFieldErrors(errors);
                showFormStatus('Please correct the errors above and try again.', 'error');
                return;
            }

            const submitBtn = contactForm.querySelector('.submit-btn');
            const formStatus = document.getElementById('formStatus');

            // Show loading state with animation
            submitBtn.classList.add('loading');
            submitBtn.disabled = true;
            showFormStatus('Sending your message...', 'info');

            try {
                const response = await fetch(contactForm.action, {
                    method: contactForm.method,
                    body: new URLSearchParams(formData),
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                });

                if (response.ok) {
                    showFormStatus('Thank you for your message! We will get back to you within 24 hours.', 'success');
                    contactForm.reset();
                    
                    // Reset file upload
                    selectedFilesMap.clear();
                    document.querySelectorAll('.file-list').forEach(fileList => {
                        fileList.innerHTML = '';
                    });
                    
                    // Clear all validation states and interaction flags
                    inputs.forEach(input => {
                        input.classList.remove('error', 'success');
                        input.closest('.form-group').classList.remove('error', 'success');
                        delete input.dataset.interacted; // Clear interaction state
                    });
                    
                    const errorElements = contactForm.querySelectorAll('.field-error');
                    errorElements.forEach(el => el.remove());
                    
                    // Show success notification
                    showNotification('Message sent successfully!', 'success');
                } else {
                    showFormStatus('An error occurred while sending your message. Please try again later.', 'error');
                    showNotification('Submission failed. Please try again.', 'error');
                }
            } catch (error) {
                console.error('Error submitting form:', error);
                showFormStatus('Network error. Please check your connection and try again.', 'error');
                showNotification('Connection error. Please try again.', 'error');
            } finally {
                // Reset button state
                submitBtn.classList.remove('loading');
                submitBtn.disabled = false;
            }
        });
    }

    // --- Smooth Scrolling for Anchor Links ---
    const anchorLinks = document.querySelectorAll('a[href^="#"]');
    anchorLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                const headerHeight = document.querySelector('.header').offsetHeight;
                const targetPosition = targetElement.offsetTop - headerHeight - 20;
                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });

    // --- Fixed Header Setup and Scroll Effect ---
    const header = document.querySelector('.header');
    
    // Set correct body padding based on actual header height
    function updateBodyPadding() {
        if (header) {
            const headerHeight = header.offsetHeight;
            
            // Always set the correct padding to match the header height
            // This ensures no white gap appears behind the fixed header
            document.body.style.paddingTop = headerHeight + 'px';
            
            // Ensure header stays fixed
            header.style.position = 'fixed';
            header.style.top = '0';
            header.style.zIndex = '1000';
        }
    }
    
    // Update padding on load and window resize
    updateBodyPadding();
    window.addEventListener('resize', updateBodyPadding);
    
    // Keep the scroll effect for background transparency
    window.addEventListener('scroll', function() {
        const currentScrollY = window.scrollY;
        
        if (currentScrollY > 100) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }
        
        // Ensure header stays fixed during scroll
        if (header) {
            header.style.position = 'fixed';
            header.style.top = '0';
        }
    });

    // --- Enhanced Intersection Observer for Animations ---
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver(function(entries, obs) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
                obs.unobserve(entry.target);
            }
        });
    }, observerOptions);
    
    const animateElements = document.querySelectorAll('.feature-card, .service-item, .stat-item, .language-item');
    animateElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });

    // Note: Contact info (phone and email) now use tel: and mailto: links for better UX
    // Click-to-copy functionality removed in favor of native link behavior

    // --- Service Item Click Handlers ---
    const serviceItems = document.querySelectorAll('.service-item');
    serviceItems.forEach(item => {
        item.addEventListener('click', function(e) {
            // Check if the click was on a link - if so, don't override the link behavior
            if (e.target.tagName === 'A' || e.target.closest('a')) {
                return; // Let the link handle the click
            }
            
            const serviceName = this.querySelector('h3').textContent;
            // Scroll to contact form and pre-fill with service name
            const contactForm = document.getElementById('contactForm');
            const messageField = contactForm.querySelector('#message');
            if (messageField) {
                messageField.value = `I'm interested in your ${serviceName} service. Please provide more information.`;
            }
            
            // Smooth scroll to contact form
            const headerHeight = document.querySelector('.header').offsetHeight;
            const contactSection = document.getElementById('contact');
            const targetPosition = contactSection.offsetTop - headerHeight - 20;
            window.scrollTo({
                top: targetPosition,
                behavior: 'smooth'
            });
        });
    });

    // --- Mobile Burger Menu Functionality ---
    const burgerMenu = document.querySelector('.burger-menu');
    const mobileSidebar = document.querySelector('.mobile-sidebar');
    const sidebarOverlay = document.querySelector('.sidebar-overlay');
    const closeSidebar = document.querySelector('.close-sidebar');
    const burgerIcon = document.querySelector('.burger-icon');

    function openSidebar() {
        mobileSidebar.classList.add('active');
        sidebarOverlay.classList.add('active');
        burgerIcon.classList.add('active');
        document.body.style.overflow = 'hidden';
        const burgerButton = document.querySelector('.burger-menu');
        if (burgerButton) burgerButton.setAttribute('aria-expanded', 'true');
    }

    function closeSidebarMenu() {
        mobileSidebar.classList.remove('active');
        sidebarOverlay.classList.remove('active');
        burgerIcon.classList.remove('active');
        document.body.style.overflow = '';
        const burgerButton = document.querySelector('.burger-menu');
        if (burgerButton) burgerButton.setAttribute('aria-expanded', 'false');
    }

    // Burger menu click handler
    if (burgerMenu) {
        burgerMenu.addEventListener('click', openSidebar);
        burgerMenu.setAttribute('aria-expanded', 'false');
        burgerMenu.setAttribute('aria-controls', 'mobile-sidebar');
    }

    // Close sidebar handlers
    if (closeSidebar) {
        closeSidebar.addEventListener('click', closeSidebarMenu);
    }

    if (sidebarOverlay) {
        sidebarOverlay.addEventListener('click', closeSidebarMenu);
    }

    // Close sidebar when clicking on navigation links
    const sidebarLinks = document.querySelectorAll('.sidebar-nav a');
    sidebarLinks.forEach(link => {
        link.addEventListener('click', function() {
            closeSidebarMenu();
        });
    });

    // Close sidebar on escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && mobileSidebar.classList.contains('active')) {
            closeSidebarMenu();
        }
    });

    // --- Mobile Collapse/Expand Functionality ---
    const collapseServicesBtn = document.getElementById('collapseServices');
    const collapseLanguagesBtn = document.getElementById('collapseLanguages');
    const servicesGrid = document.getElementById('servicesGrid');
    const languageGrid = document.getElementById('languageGrid');

    function toggleCollapse(button, grid, itemSelector, showText, hideText) {
        const isExpanded = grid.classList.contains('expanded');
        
        if (isExpanded) {
            // Collapse - hide items after the first few
            const items = grid.querySelectorAll(itemSelector);
            let visibleCount = 0;
            // Enhanced logic: Better mobile/desktop handling
        let maxVisible;
        if (itemSelector === '.service-item') {
            // Services: Show more on larger screens
            if (window.innerWidth > 1200) maxVisible = 20;      // Large desktop
            else if (window.innerWidth > 768) maxVisible = 16;   // Desktop
            else maxVisible = 6;                                 // Mobile
        } else {
            // Languages: Adaptive based on screen size
            if (window.innerWidth > 1200) maxVisible = 16;      // Large desktop
            else if (window.innerWidth > 768) maxVisible = 12;   // Desktop
            else maxVisible = 4;                                 // Mobile
        }
            
            items.forEach((item) => {
                // Only count items that are not hidden by region filter
                if (!item.classList.contains('hidden')) {
                    visibleCount++;
                    if (visibleCount > maxVisible) {
                        item.classList.add('js-hidden');
                    } else {
                        item.classList.remove('js-hidden');
                    }
                }
            });
            grid.classList.remove('expanded');
            button.querySelector('.collapse-text').textContent = showText;
            button.classList.remove('expanded');
        } else {
            // Expand - show all items from the current region only
            const items = grid.querySelectorAll(itemSelector);
            
            items.forEach((item) => {
                // Only show items that are not hidden by region filter
                if (!item.classList.contains('hidden')) {
                    item.classList.remove('js-hidden');
                }
            });
            grid.classList.add('expanded');
            button.querySelector('.collapse-text').textContent = hideText;
            button.classList.add('expanded');
        }
    }

    if (collapseServicesBtn && servicesGrid) {
        collapseServicesBtn.addEventListener('click', function() {
            toggleCollapse(
                this, 
                servicesGrid, 
                '.service-item', 
                'Show More', 
                'Show Less'
            );
        });
    }

    if (collapseLanguagesBtn && languageGrid) {
        collapseLanguagesBtn.addEventListener('click', function() {
            toggleCollapse(
                this, 
                languageGrid, 
                '.language-item', 
                'Show More', 
                'Show Less'
            );
        });
    }

    // --- Region Filter Functionality ---
    const regionFilter = document.getElementById('regionFilter');
    const languageItems = document.querySelectorAll('.language-item');
    
    // Safety check - ensure languageItems exist
    if (!languageItems || languageItems.length === 0) {
        console.warn('No language items found on the page');
    }

    // Function to sort language items alphabetically
    function sortLanguageItems() {
        const languageGrid = document.getElementById('languageGrid');
        if (!languageGrid) return;

        // Convert NodeList to Array for sorting
        const itemsArray = Array.from(languageItems);
        
        // Sort items alphabetically by language name
        itemsArray.sort((a, b) => {
            const languageA = a.querySelector('h4').textContent.toLowerCase();
            const languageB = b.querySelector('h4').textContent.toLowerCase();
            return languageA.localeCompare(languageB);
        });

        // Re-append sorted items to the grid
        itemsArray.forEach(item => {
            languageGrid.appendChild(item);
        });
    }

    // Initialize the language grid with correct collapse state
    function initializeLanguageGrid() {
        if (!languageGrid || !languageItems || languageItems.length === 0) {
            console.warn('Cannot initialize language grid: missing required elements');
            return;
        }
        
        // Reset to collapsed state
        languageGrid.classList.remove('expanded');
        if (collapseLanguagesBtn) {
            collapseLanguagesBtn.classList.remove('expanded');
            collapseLanguagesBtn.querySelector('.collapse-text').textContent = 'Show More';
        }
        
        // First reset all items to their default state
        languageItems.forEach(item => {
            item.classList.remove('js-hidden');
            item.classList.remove('hidden');
        });
        
        // Get current region selection
        const currentRegion = regionFilter ? regionFilter.value : 'all';
        
        // Apply region filtering first
        languageItems.forEach(item => {
            if (currentRegion === 'all' || item.dataset.region === currentRegion) {
                item.classList.remove('hidden');
            } else {
                item.classList.add('hidden');
            }
        });
        
        // Then apply initial collapse state to visible items based on screen size
        let visibleCount = 0;
        const maxVisible = window.innerWidth > 768 ? 12 : 4;
        
        languageItems.forEach(item => {
            if (!item.classList.contains('hidden')) {
                visibleCount++;
                if (visibleCount > maxVisible) {
                    // Use class-based hiding for consistency with services grid
                    item.classList.add('js-hidden');
                } else {
                    // Ensure visible items don't have the hidden class
                    item.classList.remove('js-hidden');
                }
            }
        });
        
        // Update button text based current state
        if (collapseLanguagesBtn) {
            const itemsArray = Array.from(languageItems);
            const visibleItems = itemsArray.filter(item => !item.classList.contains('hidden'));
            const hiddenItems = itemsArray.filter(item => !item.classList.contains('hidden') && item.classList.contains('js-hidden'));
            
            if (hiddenItems.length > 0) {
                collapseLanguagesBtn.querySelector('.collapse-text').textContent = 'Show More';
                } else {
                collapseLanguagesBtn.querySelector('.collapse-text').textContent = 'Show Less';
            }
        }
    }

    // Initialize services grid collapse state
    function initializeServicesGrid() {
        if (servicesGrid && collapseServicesBtn) {
            // Reset to collapsed state
            servicesGrid.classList.remove('expanded');
            collapseServicesBtn.classList.remove('expanded');
            collapseServicesBtn.querySelector('.collapse-text').textContent = 'Show More';
            
            // Hide items beyond the limit using class-based approach
            const items = servicesGrid.querySelectorAll('.service-item');
            const maxVisible = 6; // Always 6 for services
            
            items.forEach((item, index) => {
                if (index >= maxVisible) {
                    item.classList.add('js-hidden');
                } else {
                    item.classList.remove('js-hidden');
                }
            });
        }
    }

    // Call initialization when page loads
    // Use a small delay to ensure all elements are properly rendered
    setTimeout(() => {
        if (servicesGrid) {
            initializeServicesGrid();
        }
        
        if (languageGrid) {
            // Sort items first, then initialize
            sortLanguageItems();
            // Set initial mobile state for resize detection
            languageGrid.dataset.isMobile = (window.innerWidth <= 768).toString();
            initializeLanguageGrid();
        }
    }, 100);

    // Handle window resize to update language grid with debouncing
    let resizeTimeout;
    window.addEventListener('resize', function() {
        // Clear the previous timeout
        clearTimeout(resizeTimeout);
        
        // Set a new timeout to debounce the resize event
        resizeTimeout = setTimeout(function() {
            if (languageGrid) {
                // Only reinitialize if the screen size category has actually changed
                const currentIsMobile = window.innerWidth <= 768;
                const previousIsMobile = languageGrid.dataset.isMobile === 'true';
                
                if (currentIsMobile !== previousIsMobile) {
                    // Update the stored mobile state
                    languageGrid.dataset.isMobile = currentIsMobile.toString();
                    // Only reinitialize if the mobile/desktop state has changed
                    initializeLanguageGrid();
                }
            }
        }, 250); // 250ms debounce delay
    });

    if (regionFilter) {
        regionFilter.addEventListener('change', function() {
            const selectedRegion = this.value;
            
            // Reset collapse state when region changes
            if (languageGrid && collapseLanguagesBtn) {
                languageGrid.classList.remove('expanded');
                collapseLanguagesBtn.classList.remove('expanded');
                collapseLanguagesBtn.querySelector('.collapse-text').textContent = 'Show More';
            }
            
            // First, reset all items to their default state
            languageItems.forEach(item => {
                // Remove JS hiding class and hidden class
                item.classList.remove('js-hidden');
                item.classList.remove('hidden');
            });
            
            // Then apply region filtering
            languageItems.forEach(item => {
                if (selectedRegion === 'all' || item.dataset.region === selectedRegion) {
                    item.classList.remove('hidden');
                } else {
                    item.classList.add('hidden');
                }
            });
            

            
            // Now apply initial collapse state to visible items based on screen size
            // This ensures we show the correct number of items for the current region
            let displayedCount = 0;
            const maxVisible = window.innerWidth > 768 ? 12 : 4;
            
            languageItems.forEach(item => {
                if (!item.classList.contains('hidden')) {
                    displayedCount++;
                    if (displayedCount > maxVisible) {
                        item.classList.add('js-hidden');
                    } else {
                        item.classList.remove('js-hidden');
                    }
                }
            });
            
            // Update the button text to reflect the current state
            if (collapseLanguagesBtn) {
                const itemsArray = Array.from(languageItems);
                const visibleItems = itemsArray.filter(item => !item.classList.contains('hidden'));
                const hiddenItems = itemsArray.filter(item => !item.classList.contains('hidden') && item.classList.contains('js-hidden'));
                
                if (hiddenItems.length > 0) {
                    collapseLanguagesBtn.querySelector('.collapse-text').textContent = 'Show More';
                } else {
                    collapseLanguagesBtn.querySelector('.collapse-text').textContent = 'Show Less';
                }
            }
        });
    }

    // --- Enhanced Quick Contact Button Focus Management ---
    const quickContactBtn = document.querySelector('.quick-contact-mobile');
    if (quickContactBtn) {
        
        function removeFocus() {
            quickContactBtn.classList.add('no-focus');
            quickContactBtn.blur();
            if (document.activeElement === quickContactBtn) {
                document.activeElement.blur();
            }
            // Remove the class after a short delay to allow transitions
            setTimeout(() => {
                quickContactBtn.classList.remove('no-focus');
            }, 300);
        }

        // Handle focus management for better UX
        quickContactBtn.addEventListener('click', function(e) {
            // Immediately remove focus on click
            setTimeout(removeFocus, 10);
        });

        // Enhanced keyboard navigation
        quickContactBtn.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                // Simulate click and then remove focus
                this.click();
                setTimeout(removeFocus, 10);
            }
        });

        // Remove focus on touch devices
        quickContactBtn.addEventListener('touchstart', function() {
            setTimeout(removeFocus, 10);
        });

        // Remove focus when the button loses active state
        quickContactBtn.addEventListener('mouseup', function() {
            setTimeout(removeFocus, 10);
        });

        // Additional safety net - remove focus when scrolling starts
        window.addEventListener('scroll', function() {
            if (document.activeElement === quickContactBtn) {
                removeFocus();
            }
        });

        // Force remove focus when clicking anywhere else
        document.addEventListener('click', function(e) {
            if (e.target !== quickContactBtn && document.activeElement === quickContactBtn) {
                removeFocus();
            }
        });
    }

    // --- Initialize Services for Desktop ---
    function initializeServicesForDesktop() {
        if (window.innerWidth > 768 && servicesGrid) {
            // On desktop, show all services by default
            const serviceItems = servicesGrid.querySelectorAll('.service-item');
            serviceItems.forEach(item => {
                item.classList.remove('js-hidden');
            });
        }
    }

    // Call initialization function
    initializeServicesForDesktop();

    // Re-initialize on window resize
    window.addEventListener('resize', initializeServicesForDesktop);

}); 
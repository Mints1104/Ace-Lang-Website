
document.addEventListener('DOMContentLoaded', function() {
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

    // Enhanced form validation
    function validateForm(formData) {
        const errors = [];
        const name = formData.get('name').trim();
        const email = formData.get('email').trim();
        const message = formData.get('message').trim();

        if (!name || name.length < 2) {
            errors.push('Name must be at least 2 characters long');
        }

        if (!email) {
            errors.push('Email is required');
        } else {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                errors.push('Please enter a valid email address');
            }
        }

        if (!message || message.length < 10) {
            errors.push('Message must be at least 10 characters long');
        }

        return errors;
    }

    // --- Contact Form Handling ---
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        // Real-time validation
        const inputs = contactForm.querySelectorAll('input, textarea');
        inputs.forEach(input => {
            input.addEventListener('blur', function() {
                const fieldName = this.name;
                const value = this.value.trim();
                let isValid = true;
                let errorMessage = '';

                switch(fieldName) {
                    case 'name':
                        if (!value || value.length < 2) {
                            isValid = false;
                            errorMessage = 'Name must be at least 2 characters';
                        }
                        break;
                    case 'email':
                        if (!value) {
                            isValid = false;
                            errorMessage = 'Email is required';
                        } else {
                            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                            if (!emailRegex.test(value)) {
                                isValid = false;
                                errorMessage = 'Please enter a valid email';
                            }
                        }
                        break;
                    case 'message':
                        if (!value || value.length < 10) {
                            isValid = false;
                            errorMessage = 'Message must be at least 10 characters';
                        }
                        break;
                }

                // Remove existing error styling
                this.classList.remove('error');
                this.parentNode.classList.remove('success');
                const existingError = this.parentNode.querySelector('.field-error');
                if (existingError) existingError.remove();

                if (!isValid) {
                    this.classList.add('error');
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'field-error';
                    errorDiv.textContent = errorMessage;
                    errorDiv.style.cssText = 'color: #f56565; font-size: 0.875rem; margin-top: 0.25rem;';
                    this.parentNode.appendChild(errorDiv);
                } else if (value.length > 0) {
                    // Add success state for valid fields
                    this.parentNode.classList.add('success');
                }
            });
        });

        contactForm.addEventListener('submit', async function(e) {
            e.preventDefault();

            const formData = new FormData(contactForm);
            const errors = validateForm(formData);

            if (errors.length > 0) {
                showNotification(errors.join('. '), 'error');
                return;
            }

            const submitBtn = contactForm.querySelector('.submit-btn');
            const originalText = submitBtn.textContent;
            const originalDisabled = submitBtn.disabled;

            // Show loading state with animation
            submitBtn.textContent = '';
            submitBtn.disabled = true;
            submitBtn.classList.add('loading');

            try {
                const response = await fetch(contactForm.action, {
                    method: contactForm.method,
                    body: new URLSearchParams(formData),
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                });

                if (response.ok) {
                    showNotification('Thank you for your message! We will get back to you soon.', 'success');
                    contactForm.reset();
                    // Remove any error styling and success states
                    inputs.forEach(input => {
                        input.classList.remove('error');
                        input.parentNode.classList.remove('success');
                    });
                    const errorElements = contactForm.querySelectorAll('.field-error');
                    errorElements.forEach(el => el.remove());
                } else {
                    showNotification('An error occurred. Please try again later.', 'error');
                }
            } catch (error) {
                console.error('Error submitting form:', error);
                showNotification('Network error. Please check your connection and try again.', 'error');
            } finally {
                // Reset button state
                submitBtn.textContent = originalText;
                submitBtn.disabled = originalDisabled;
                submitBtn.classList.remove('loading');
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

    // --- Header Scroll Effect ---
    const header = document.querySelector('.header');
    
    window.addEventListener('scroll', function() {
        const currentScrollY = window.scrollY;
        
        if (currentScrollY > 100) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
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
        item.addEventListener('click', function() {
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
    }

    function closeSidebarMenu() {
        mobileSidebar.classList.remove('active');
        sidebarOverlay.classList.remove('active');
        burgerIcon.classList.remove('active');
        document.body.style.overflow = '';
    }

    // Burger menu click handler
    if (burgerMenu) {
        burgerMenu.addEventListener('click', openSidebar);
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
            items.forEach((item, index) => {
                if (index >= (itemSelector === '.service-item' ? 6 : 4)) {
                    // First animate out, then hide
                    item.style.opacity = '0';
                    item.style.transform = 'translateY(20px)';
                    
                    // After animation completes, hide the item
                    setTimeout(() => {
                        item.style.display = 'none';
                        item.style.removeProperty('--item-delay');
                    }, 400); // Match CSS transition duration
                }
            });
            grid.classList.remove('expanded');
            button.querySelector('.collapse-text').textContent = showText;
            button.classList.remove('expanded');
        } else {
            // Expand - show all items with dynamic transition delays
            const items = grid.querySelectorAll(itemSelector);
            items.forEach((item, index) => {
                // Show item first
                item.style.display = 'flex';
                
                // Set dynamic transition delay based on item index
                const delay = (index + 1) * 0.1; // 0.1s delay per item
                item.style.setProperty('--item-delay', `${delay}s`);
                
                // Force reflow, then animate in
                item.offsetHeight; // Force reflow
                item.style.opacity = '1';
                item.style.transform = 'translateY(0)';
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

    console.log('Ace Language Services website loaded successfully!');
}); 
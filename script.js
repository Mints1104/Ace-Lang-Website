
document.addEventListener('DOMContentLoaded', function() {
    function showNotification(message, type = 'info') {
        // Remove existing notifications
        const existingNotifications = document.querySelectorAll('.notification');
        existingNotifications.forEach(notification => notification.remove());

        // Create notification element
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.setAttribute('role', 'alert'); // Accessibility: announce to screen readers
        notification.setAttribute('tabindex', '-1'); // Make focusable
        notification.innerHTML = `
            <div class="notification-content">
                <span class="notification-message">${message}</span>
                <button class="notification-close" aria-label="Close notification">&times;</button>
            </div>
        `;

        // Add to page and focus for accessibility
        document.body.appendChild(notification);
        notification.focus();

        // Close button functionality
        const closeButton = notification.querySelector('.notification-close');
        closeButton.addEventListener('click', () => {
            notification.remove();
        });

        // Auto-remove after 5 seconds
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
        }, 5000);
    }

    // --- Contact Form Handling ---
    const contactForm = document.getElementById('contactForm');
    if (contactForm) {
        contactForm.addEventListener('submit', async function(e) {
            e.preventDefault(); // Stop the default form submission

            const formData = new FormData(contactForm);
            const name = formData.get('name');
            const email = formData.get('email');
            const message = formData.get('message');

            // Basic validation
            if (!name || !email || !message) {
                showNotification('Please fill in all required fields.', 'error');
                return;
            }

            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                showNotification('Please enter a valid email address.', 'error');
                return;
            }

            const submitBtn = contactForm.querySelector('.submit-btn');
            const originalText = submitBtn.textContent;
            submitBtn.textContent = 'Sending...';
            submitBtn.disabled = true;

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
                } else {
                    // Handle errors based on Netlify's response
                    showNotification('An error occurred. Please try again later.', 'error');
                }
            } catch (error) {
                console.error('Error submitting form:', error);
                showNotification('Network error. Please check your connection and try again.', 'error');
            } finally {
                // Always reset the button state
                submitBtn.textContent = originalText;
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

    // --- Header Scroll Effect ---
    const header = document.querySelector('.header');
    window.addEventListener('scroll', function() {
        if (window.scrollY > 100) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }
    });

    // --- Animate Elements on Scroll ---
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    const observer = new IntersectionObserver(function(entries, obs) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
                obs.unobserve(entry.target); // Stop observing once animated
            }
        });
    }, observerOptions);
    const animateElements = document.querySelectorAll('.feature-card, .service-item, .stat-item');
    animateElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });

    // --- Click-to-Copy for Contact Info ---
    const contactInfo = document.querySelectorAll('.contact-item span, .contact-item p');
    contactInfo.forEach(info => {
        if (info.textContent.includes('@') || info.textContent.includes('+44')) {
            info.style.cursor = 'pointer';
            info.title = 'Click to copy';
            info.addEventListener('click', function() {
                navigator.clipboard.writeText(this.textContent).then(() => {
                    showNotification('Contact information copied to clipboard!', 'success');
                }).catch(() => {
                    showNotification('Could not copy to clipboard.', 'error');
                });
            });
        }
    });

       console.log('Ace Language Services website loaded successfully!');
}); 
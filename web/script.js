// Smooth scrolling for navigation
function scrollToDownload() {
    document.getElementById('download').scrollIntoView({
        behavior: 'smooth'
    });
}

// Modal functionality
const modal = document.getElementById('discordModal');
const preorderBtn = document.getElementById('preorderBtn');
const preorderRingBtn = document.getElementById('preorderRingBtn');
const startFreeBtn = document.getElementById('startFreeBtn');
const getPremiumBtn = document.getElementById('getPremiumBtn');
const chooseYearlyBtn = document.getElementById('chooseYearlyBtn');
const closeBtn = document.querySelector('.close');

// Open modal when preorder buttons are clicked
preorderBtn.addEventListener('click', openModal);
preorderRingBtn.addEventListener('click', openModal);

// Open modal when pricing buttons are clicked
startFreeBtn.addEventListener('click', openModal);
getPremiumBtn.addEventListener('click', openModal);
chooseYearlyBtn.addEventListener('click', openModal);

function openModal() {
    modal.style.display = 'block';
    document.body.style.overflow = 'hidden';
}

// Close modal
closeBtn.addEventListener('click', closeModal);

function closeModal() {
    modal.style.display = 'none';
    document.body.style.overflow = 'auto';
}

// Close modal when clicking outside
window.addEventListener('click', function(event) {
    if (event.target === modal) {
        closeModal();
    }
});

// Join Discord function
function joinDiscord() {
    // MindRing project Discord invite link
    const discordInvite = 'https://discord.gg/hZVsEz8Was';
    
    // Track the event (you can integrate with analytics here)
    console.log('User joining Discord community');
    
    // Open Discord in new tab
    window.open(discordInvite, '_blank');
    
    // Close modal
    closeModal();
    
    // Show success message
    showNotification('Welcome to the MindRing community! Check your new tab to join Discord.');
}

// Notification system
function showNotification(message) {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = 'notification';
    notification.innerHTML = `
        <div class="notification-content">
            <span class="notification-icon">🎉</span>
            <span class="notification-message">${message}</span>
            <button class="notification-close" onclick="this.parentElement.parentElement.remove()">×</button>
        </div>
    `;
    
    // Add notification styles
    notification.style.cssText = `
        position: fixed;
        top: 100px;
        right: 20px;
        background: linear-gradient(135deg, #7ba07e 0%, #5b8a72 100%);
        color: white;
        padding: 1rem;
        border-radius: 10px;
        box-shadow: 0 10px 30px rgba(123, 160, 126, 0.3);
        z-index: 3000;
        max-width: 400px;
        animation: slideIn 0.3s ease;
    `;
    
    // Add to page
    document.body.appendChild(notification);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (notification.parentElement) {
            notification.remove();
        }
    }, 5000);
}

// Add CSS animation for notifications
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    .notification-content {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    
    .notification-icon {
        font-size: 1.2rem;
    }
    
    .notification-message {
        flex: 1;
        font-size: 0.9rem;
    }
    
    .notification-close {
        background: none;
        border: none;
        color: white;
        font-size: 1.2rem;
        cursor: pointer;
        padding: 0;
        margin-left: 0.5rem;
    }
    
    .notification-close:hover {
        opacity: 0.7;
    }
`;
document.head.appendChild(style);

// QR Code generation (placeholder - you would integrate with a real QR code library)
function generateQRCode(text, elementId) {
    const element = document.getElementById(elementId);
    if (element) {
        // This is a placeholder - in a real implementation, you'd use a library like qrcode.js
        element.innerHTML = `
            <div style="
                width: 100%;
                height: 100%;
                background: white;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                border: 2px solid #e8d2ab;
                border-radius: 10px;
            ">
                <div style="
                    width: 80%;
                    height: 60%;
                    background: 
                        repeating-linear-gradient(0deg, #2f5d3e 0px, #2f5d3e 2px, transparent 2px, transparent 4px),
                        repeating-linear-gradient(90deg, #2f5d3e 0px, #2f5d3e 2px, transparent 2px, transparent 4px);
                    margin-bottom: 10px;
                "></div>
                <div style="font-size: 0.8rem; color: #5b8a72; text-align: center;">
                    Scan to download<br>${text}
                </div>
            </div>
        `;
    }
}

// Initialize QR codes when page loads
document.addEventListener('DOMContentLoaded', function() {
    generateQRCode('iOS App', 'iosQR');
    generateQRCode('Android App', 'androidQR');
});

// Smooth scrolling for all anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Header scroll effect
window.addEventListener('scroll', function() {
    const header = document.querySelector('.header');
    if (window.scrollY > 100) {
        header.style.background = 'rgba(246, 234, 213, 0.98)';
        header.style.boxShadow = '0 2px 20px rgba(47, 93, 62, 0.1)';
    } else {
        header.style.background = 'rgba(246, 234, 213, 0.95)';
        header.style.boxShadow = 'none';
    }
});

// Animate elements on scroll
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe elements for animation
document.addEventListener('DOMContentLoaded', function() {
    const animateElements = document.querySelectorAll('.feature-card, .pricing-card, .download-card');
    
    animateElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });
});

// Form handling for newsletter signup (if you add one later)
function handleNewsletterSignup(email) {
    console.log('Newsletter signup:', email);
    showNotification('Thank you for subscribing! We\'ll keep you updated on MindRing\'s progress.');
}

// Analytics tracking (placeholder - integrate with your analytics service)
function trackEvent(eventName, properties = {}) {
    console.log('Analytics Event:', eventName, properties);
    
    // Example integration points:
    // - Google Analytics
    // - Mixpanel
    // - Amplitude
    // - Custom analytics
}

// Track important user actions
document.addEventListener('DOMContentLoaded', function() {
    // Track page view
    trackEvent('page_view', { page: 'landing' });
    
    // Track button clicks
    document.querySelectorAll('.btn').forEach(btn => {
        btn.addEventListener('click', function() {
            const action = this.textContent.trim();
            trackEvent('button_click', { action: action });
        });
    });
});

// Mobile menu toggle (for future mobile menu implementation)
function toggleMobileMenu() {
    const navLinks = document.querySelector('.nav-links');
    navLinks.classList.toggle('mobile-open');
}

// Keyboard accessibility
document.addEventListener('keydown', function(e) {
    // Close modal with Escape key
    if (e.key === 'Escape' && modal.style.display === 'block') {
        closeModal();
    }
});

// Focus management for modal
function openModal() {
    modal.style.display = 'block';
    document.body.style.overflow = 'hidden';
    
    // Focus the first focusable element in the modal
    const focusableElements = modal.querySelectorAll('button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])');
    if (focusableElements.length > 0) {
        focusableElements[0].focus();
    }
}

// Trap focus within modal
modal.addEventListener('keydown', function(e) {
    if (e.key === 'Tab') {
        const focusableElements = modal.querySelectorAll('button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])');
        const firstElement = focusableElements[0];
        const lastElement = focusableElements[focusableElements.length - 1];
        
        if (e.shiftKey) {
            if (document.activeElement === firstElement) {
                e.preventDefault();
                lastElement.focus();
            }
        } else {
            if (document.activeElement === lastElement) {
                e.preventDefault();
                firstElement.focus();
            }
        }
    }
});


// Alex Interactive Elements
function initAlexAnimations() {
    const alexElements = document.querySelectorAll('.alex-floating, .alex-hero-mascot, .alex-package');
    
    // Add hover effects
    alexElements.forEach(alex => {
        alex.addEventListener('mouseenter', () => {
            alex.style.transform = 'scale(1.1) translateY(-10px)';
            alex.style.transition = 'transform 0.3s ease';
        });
        
        alex.addEventListener('mouseleave', () => {
            alex.style.transform = 'scale(1) translateY(0px)';
        });
    });
    
    // Add click interaction for Alex mascot
    const alexMascots = document.querySelectorAll('.alex-floating, .alex-hero-mascot');
    alexMascots.forEach(alex => {
        alex.addEventListener('click', () => {
            // Create a fun bounce effect
            alex.style.animation = 'bounce 0.6s ease';
            setTimeout(() => {
                alex.style.animation = 'float 5s ease-in-out infinite';
            }, 600);
            
            // Show a fun message
            showNotification('Alex says: Welcome to MindRing! 🦉', 'success');
        });
    });
}

// Bounce animation keyframes (add to CSS dynamically)
function addBounceAnimation() {
    const style = document.createElement('style');
    style.textContent = `
        @keyframes bounce {
            0%, 20%, 60%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-30px);
            }
            80% {
                transform: translateY(-15px);
            }
        }
    `;
    document.head.appendChild(style);
}

// Initialize Alex animations when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Initialize Alex animations
    initAlexAnimations();
    addBounceAnimation();
});
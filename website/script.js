// Landing page JavaScript

// Smooth scrolling for navigation links
document.addEventListener('DOMContentLoaded', function() {
    // Smooth scroll for anchor links
    const links = document.querySelectorAll('a[href^="#"]');

    links.forEach(link => {
        link.addEventListener('click', function(e) {
            const href = this.getAttribute('href');

            if (href === '#') return;

            e.preventDefault();

            const target = document.querySelector(href);
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Animate stats on scroll
    const observerOptions = {
        threshold: 0.5,
        rootMargin: '0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
            }
        });
    }, observerOptions);

    // Observe all feature cards
    const cards = document.querySelectorAll('.feature-card, .problem-card, .benefit-card');
    cards.forEach(card => observer.observe(card));

    // Add scroll effects
    let lastScrollTop = 0;
    const nav = document.querySelector('.nav');

    window.addEventListener('scroll', function() {
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

        if (scrollTop > lastScrollTop) {
            // Scrolling down
            if (scrollTop > 100) {
                nav.style.boxShadow = '0 4px 6px -1px rgb(0 0 0 / 0.1)';
            }
        } else {
            // Scrolling up
            if (scrollTop <= 100) {
                nav.style.boxShadow = '0 1px 2px 0 rgb(0 0 0 / 0.05)';
            }
        }

        lastScrollTop = scrollTop;
    });

    // Track CTA clicks (analytics placeholder)
    const ctaButtons = document.querySelectorAll('.btn-primary, .btn-primary-large');
    ctaButtons.forEach(button => {
        button.addEventListener('click', function() {
            const buttonText = this.textContent.trim();
            console.log('CTA Click:', buttonText);
            // Add analytics tracking here (e.g., Google Analytics, Plausible)
        });
    });
});

// Add animation class to elements when they come into view
const style = document.createElement('style');
style.textContent = `
    .animate-in {
        animation: fadeInUp 0.6s ease-out;
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
`;
document.head.appendChild(style);

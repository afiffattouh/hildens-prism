// File-free database using localStorage
const PlaybookDB = {
    // Save signup data
    saveSignup: function(data) {
        const signups = this.getAllSignups();
        const signup = {
            ...data,
            timestamp: new Date().toISOString(),
            id: this.generateId(),
            accessToken: this.generateAccessToken()
        };
        signups.push(signup);
        localStorage.setItem('prism_signups', JSON.stringify(signups));
        return signup;
    },

    // Get all signups
    getAllSignups: function() {
        const data = localStorage.getItem('prism_signups');
        return data ? JSON.parse(data) : [];
    },

    // Check if email already registered
    isEmailRegistered: function(email) {
        const signups = this.getAllSignups();
        return signups.find(signup => signup.email.toLowerCase() === email.toLowerCase());
    },

    // Validate access token
    validateAccessToken: function(token) {
        const signups = this.getAllSignups();
        return signups.find(signup => signup.accessToken === token);
    },

    // Generate unique ID
    generateId: function() {
        return Date.now().toString(36) + Math.random().toString(36).substr(2);
    },

    // Generate access token
    generateAccessToken: function() {
        return 'prism_' + Date.now().toString(36) + '_' + Math.random().toString(36).substr(2, 9);
    },

    // Get signup stats
    getStats: function() {
        const signups = this.getAllSignups();
        return {
            total: signups.length,
            byRole: this.groupByRole(signups),
            recent: signups.slice(-10).reverse()
        };
    },

    groupByRole: function(signups) {
        return signups.reduce((acc, signup) => {
            const role = signup.role || 'other';
            acc[role] = (acc[role] || 0) + 1;
            return acc;
        }, {});
    }
};

// Resend Email Service Configuration
const EmailService = {
    // IMPORTANT: Configure your API endpoint URL
    // This should point to your serverless function (Vercel, Netlify, etc.)
    API_ENDPOINT: '/api/send-playbook',  // Update with your deployment URL

    // For local development, set to: 'http://localhost:3000/api/send-playbook'
    // For production, set to: 'https://yourdomain.com/api/send-playbook'

    sendPlaybookAccess: async function(userData, accessToken) {
        // Check if API endpoint is configured
        if (this.API_ENDPOINT === '/api/send-playbook') {
            console.warn('Resend API not configured. Using demo mode.');
            return this.demoMode(userData, accessToken);
        }

        try {
            const response = await fetch(this.API_ENDPOINT, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    name: userData.name,
                    email: userData.email,
                    company: userData.company,
                    role: userData.role || 'Not specified',
                    accessToken: accessToken
                })
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.error || 'Failed to send email');
            }

            console.log('Email sent successfully:', data);
            return {
                success: true,
                email: userData.email,
                messageId: data.messageId
            };

        } catch (error) {
            console.error('Email send failed:', error);
            throw new Error(error.message || 'Failed to send email. Please try again.');
        }
    },

    // Demo mode when API is not configured
    demoMode: function(userData, accessToken) {
        const accessLink = `${window.location.origin}${window.location.pathname}?access=${accessToken}`;

        console.log('=== DEMO MODE: Email would be sent via Resend ===');
        console.log('To:', userData.email);
        console.log('Name:', userData.name);
        console.log('Company:', userData.company);
        console.log('Role:', userData.role || 'Not specified');
        console.log('Access Link:', accessLink);
        console.log('================================================');

        // Auto-open playbook in demo mode after 2 seconds
        setTimeout(() => {
            alert(`DEMO MODE: Resend API not configured.\n\nIn production, an email would be sent to: ${userData.email}\n\nAccess link: ${accessLink}\n\nOpening playbook now...`);
            window.location.href = accessLink;
        }, 2000);

        return Promise.resolve({ success: true, email: userData.email, demo: true });
    }
};

// Load playbook content
async function loadPlaybookContent() {
    // Try to fetch the markdown file (works with local server)
    try {
        const response = await fetch('../docs/strategic-guide-legacy-transformation v2.md');
        if (response.ok) {
            const markdown = await response.text();
            const html = convertMarkdownToHTML(markdown);
            document.getElementById('playbook-text').innerHTML = html;
            return;
        }
    } catch (error) {
        console.log('Fetch failed (expected when opening file:// directly), using embedded content');
    }

    // Fallback: Show embedded summary
    document.getElementById('playbook-text').innerHTML = `
        <h1>The Strategic Guide to Legacy System Transformation</h1>
        <p class="playbook-subtitle">A Technology Strategist's Playbook</p>

        <div style="background: #fef3c7; border-left: 4px solid #f59e0b; padding: 1.5rem; margin: 2rem 0; border-radius: 0.5rem;">
            <p style="margin: 0; color: #92400e;"><strong>📁 Note:</strong> To view the full playbook content, please open this page via a local web server or view the markdown file directly at: <code>docs/strategic-guide-legacy-transformation v2.md</code></p>
        </div>

        <h2>Executive Summary</h2>
        <p>Legacy systems represent one of the most significant paradoxes in enterprise technology: they are simultaneously your most valuable assets (containing decades of refined business logic) and your greatest liabilities (constraining innovation and concentrating operational risk).</p>

        <p>This guide provides a strategic framework for transforming legacy systems from liabilities into competitive advantages through structured knowledge management and AI-enabled development practices.</p>

        <h2>What You'll Find in the Full Guide</h2>

        <h3>1. Understanding the Legacy System Challenge</h3>
        <ul>
            <li>True cost calculation: Hidden costs are 3-5x visible maintenance expenses</li>
            <li>Knowledge concentration risk and the retirement cliff</li>
            <li>Why traditional approaches fail (documentation, big bang, offshore)</li>
        </ul>

        <h3>2. The Knowledge Asset Framework</h3>
        <ul>
            <li>Reframing legacy systems as knowledge repositories</li>
            <li>Quantifying knowledge asset value (ROI: 9,900%-19,900%)</li>
            <li>The knowledge preservation imperative</li>
        </ul>

        <h3>3. Strategic Decision Models</h3>
        <ul>
            <li>Modernization decision tree for system prioritization</li>
            <li>Build vs. Buy vs. Modernize matrix</li>
            <li>ROI calculation framework with industry benchmarks</li>
        </ul>

        <h3>4. Building the Business Case</h3>
        <ul>
            <li>Stakeholder alignment (CFO, CEO, Business Leaders, Board)</li>
            <li>7-act narrative structure for presentations</li>
            <li>Addressing common objections with data-backed responses</li>
        </ul>

        <h3>5-10. Implementation, Risk, Value, Positioning, Change & Future-Proofing</h3>
        <p>Comprehensive frameworks covering 90-day pilots, enterprise rollout, metrics, competitive advantages, and 5-year transformation roadmap.</p>

        <h2>Key Metrics & Benchmarks</h2>
        <div style="background: #f8fafc; padding: 1.5rem; border-radius: 0.5rem; margin: 1.5rem 0;">
            <h4 style="margin-top: 0;">Financial Impact</h4>
            <ul>
                <li><strong>Typical ROI:</strong> 285-420% over 5 years</li>
                <li><strong>Payback Period:</strong> 10-12 months</li>
                <li><strong>Annual Savings:</strong> 50-80% of initial investment</li>
            </ul>

            <h4>Productivity Gains</h4>
            <ul>
                <li><strong>Onboarding Time:</strong> 67% reduction (12 weeks → 3-4 weeks)</li>
                <li><strong>Code Review Cycles:</strong> 60% reduction (3.2 → 1.3 per PR)</li>
                <li><strong>Development Velocity:</strong> 1.5-2x baseline</li>
            </ul>
        </div>

        <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 2rem; border-radius: 0.5rem; margin: 2rem 0; text-align: center;">
            <h3 style="color: white; margin-top: 0;">Ready to Get Started?</h3>
            <p style="margin-top: 1.5rem; margin-bottom: 0;">
                <a href="https://github.com/afiffattouh/hildens-prism" target="_blank"
                   style="background: white; color: #667eea; padding: 0.75rem 1.5rem; border-radius: 0.5rem; text-decoration: none; font-weight: 600; display: inline-block;">
                    Get Started with PRISM Framework
                </a>
            </p>
        </div>
    `;
}

// Simple markdown to HTML converter
function convertMarkdownToHTML(markdown) {
    let html = markdown;

    // Headers
    html = html.replace(/^### (.*$)/gim, '<h3>$1</h3>');
    html = html.replace(/^## (.*$)/gim, '<h2>$1</h2>');
    html = html.replace(/^# (.*$)/gim, '<h1>$1</h1>');

    // Bold
    html = html.replace(/\*\*(.*?)\*\*/gim, '<strong>$1</strong>');

    // Italic
    html = html.replace(/\*(.*?)\*/gim, '<em>$1</em>');

    // Code blocks
    html = html.replace(/```([\s\S]*?)```/gim, '<pre><code>$1</code></pre>');

    // Inline code
    html = html.replace(/`([^`]+)`/gim, '<code>$1</code>');

    // Links
    html = html.replace(/\[([^\]]+)\]\(([^\)]+)\)/gim, '<a href="$2" target="_blank">$1</a>');

    // Lists
    html = html.replace(/^\- (.*$)/gim, '<li>$1</li>');
    html = html.replace(/(<li>.*<\/li>)/gim, '<ul>$1</ul>');

    // Paragraphs
    html = html.replace(/\n\n/g, '</p><p>');
    html = '<p>' + html + '</p>';

    // Clean up
    html = html.replace(/<p><\/p>/g, '');
    html = html.replace(/<p>(<h[1-6]>)/g, '$1');
    html = html.replace(/(<\/h[1-6]>)<\/p>/g, '$1');
    html = html.replace(/<p>(<ul>)/g, '$1');
    html = html.replace(/(<\/ul>)<\/p>/g, '$1');
    html = html.replace(/<p>(<pre>)/g, '$1');
    html = html.replace(/(<\/pre>)<\/p>/g, '$1');

    return html;
}

// Handle form submission
document.addEventListener('DOMContentLoaded', function() {
    // Check if accessing via access token
    const urlParams = new URLSearchParams(window.location.search);
    const accessToken = urlParams.get('access');

    if (accessToken) {
        const userData = PlaybookDB.validateAccessToken(accessToken);
        if (userData) {
            showPlaybookContent(userData.name);
            return;
        } else {
            alert('Invalid or expired access link. Please request a new one.');
        }
    }

    const form = document.getElementById('playbook-signup-form');

    if (form) {
        form.addEventListener('submit', async function(e) {
            e.preventDefault();

            const submitBtn = document.getElementById('submit-btn');
            const originalText = submitBtn.textContent;

            // Disable button and show loading state
            submitBtn.disabled = true;
            submitBtn.textContent = 'Sending...';

            const formData = {
                name: document.getElementById('name').value,
                email: document.getElementById('email').value,
                company: document.getElementById('company').value,
                role: document.getElementById('role').value
            };

            try {
                // Check if email already registered
                const existingUser = PlaybookDB.isEmailRegistered(formData.email);
                let signup;

                if (existingUser) {
                    signup = existingUser;
                    console.log('User already registered, resending access link');
                } else {
                    // Save to database
                    signup = PlaybookDB.saveSignup(formData);
                    console.log('New signup saved:', PlaybookDB.getStats());
                }

                // Send email with access link
                await EmailService.sendPlaybookAccess(formData, signup.accessToken);

                // Show success message
                showEmailConfirmation(formData.email);

            } catch (error) {
                alert('Failed to send email: ' + error.message);
                submitBtn.disabled = false;
                submitBtn.textContent = originalText;
            }
        });
    }
});

// Show email confirmation
function showEmailConfirmation(email) {
    document.getElementById('signup-form-container').style.display = 'none';
    const confirmationDiv = document.getElementById('email-sent-confirmation');
    confirmationDiv.style.display = 'block';
    document.getElementById('sent-email').textContent = email;
    confirmationDiv.scrollIntoView({ behavior: 'smooth' });
}

// Show playbook content
function showPlaybookContent(name) {
    // Hide form and confirmation
    document.getElementById('signup-form-container').style.display = 'none';
    document.getElementById('email-sent-confirmation').style.display = 'none';

    // Show content
    const contentDiv = document.getElementById('playbook-content');
    contentDiv.style.display = 'block';

    // Set user name
    document.getElementById('user-name').textContent = name;

    // Load playbook
    loadPlaybookContent();

    // Scroll to content
    contentDiv.scrollIntoView({ behavior: 'smooth' });
}

// Download playbook (placeholder function)
function downloadPlaybook() {
    alert('PDF download functionality would be implemented here. For now, you can print this page (Cmd/Ctrl + P) and save as PDF.');
}

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { PlaybookDB, EmailService };
}

// Serverless function for sending playbook access emails via Resend
// Deploy this to Vercel, Netlify, or any serverless platform

const RESEND_API_KEY = process.env.RESEND_API_KEY; // Set in your hosting platform
const FROM_EMAIL = process.env.FROM_EMAIL || 'noreply@yourdomain.com';

export default async function handler(req, res) {
    // Enable CORS
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    // Handle preflight
    if (req.method === 'OPTIONS') {
        return res.status(200).end();
    }

    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method not allowed' });
    }

    const { name, email, company, role, accessToken } = req.body;

    // Validate input
    if (!name || !email || !accessToken) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    // Construct access link
    const baseUrl = req.headers.origin || 'https://yourdomain.com';
    const accessLink = `${baseUrl}/website/playbook.html?access=${accessToken}`;

    // Email HTML template
    const emailHtml = `
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
            line-height: 1.6;
            color: #1e293b;
            margin: 0;
            padding: 0;
            background-color: #f8fafc;
        }
        .container {
            max-width: 600px;
            margin: 40px auto;
            background: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }
        .header h1 {
            margin: 0 0 10px;
            font-size: 28px;
        }
        .header p {
            margin: 0;
            opacity: 0.9;
            font-size: 16px;
        }
        .content {
            padding: 40px 30px;
        }
        .greeting {
            font-size: 18px;
            margin-bottom: 20px;
        }
        .info-box {
            background: #f8fafc;
            border-left: 4px solid #2563eb;
            padding: 15px 20px;
            margin: 20px 0;
        }
        .info-box h3 {
            margin: 0 0 10px;
            color: #2563eb;
            font-size: 16px;
        }
        .info-box ul {
            margin: 0;
            padding-left: 20px;
        }
        .info-box li {
            margin: 5px 0;
        }
        .cta-button {
            display: inline-block;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            padding: 16px 32px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 16px;
            margin: 20px 0;
            text-align: center;
        }
        .cta-button:hover {
            opacity: 0.9;
        }
        .link-box {
            background: #fef3c7;
            border: 1px solid #fbbf24;
            border-radius: 6px;
            padding: 15px;
            margin: 20px 0;
            word-break: break-all;
        }
        .link-box p {
            margin: 0 0 10px;
            font-size: 14px;
            color: #92400e;
        }
        .link-box a {
            color: #2563eb;
            text-decoration: none;
        }
        .footer {
            background: #f8fafc;
            padding: 30px;
            text-align: center;
            color: #64748b;
            font-size: 14px;
            border-top: 1px solid #e2e8f0;
        }
        .footer p {
            margin: 5px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎯 Your PRISM Playbook Access</h1>
            <p>Strategic Guide to Legacy System Transformation</p>
        </div>

        <div class="content">
            <p class="greeting">Hello <strong>${name}</strong>,</p>

            <p>Thank you for your interest in the <strong>PRISM Framework Strategic Playbook</strong>!</p>

            <div class="info-box">
                <h3>Your Details:</h3>
                <ul>
                    <li><strong>Name:</strong> ${name}</li>
                    <li><strong>Company:</strong> ${company}</li>
                    <li><strong>Role:</strong> ${role || 'Not specified'}</li>
                </ul>
            </div>

            <p>Click the button below to access your personalized copy of the Strategic Guide:</p>

            <center>
                <a href="${accessLink}" class="cta-button">
                    Access Your Playbook →
                </a>
            </center>

            <div class="link-box">
                <p><strong>Or copy this link:</strong></p>
                <a href="${accessLink}">${accessLink}</a>
            </div>

            <p style="margin-top: 30px;">This comprehensive 140+ page guide includes:</p>
            <ul>
                <li>✅ Knowledge Asset Valuation Framework</li>
                <li>✅ Strategic Decision Models & ROI Calculations</li>
                <li>✅ 90-Day Pilot Implementation Guide</li>
                <li>✅ Risk Management Strategies</li>
                <li>✅ Change Management Best Practices</li>
                <li>✅ Competitive Positioning Frameworks</li>
            </ul>

            <p style="margin-top: 30px; color: #64748b; font-size: 14px;">
                This link is unique to you and provides immediate access to the full guide.
                If you have any questions, feel free to reply to this email.
            </p>
        </div>

        <div class="footer">
            <p><strong>PRISM Framework v2.2.0</strong></p>
            <p>Built on Anthropic's Claude Agent SDK Principles</p>
            <p style="margin-top: 15px;">
                <a href="https://github.com/afiffattouh/hildens-prism" style="color: #2563eb;">GitHub</a> •
                <a href="${baseUrl}/website/index.html" style="color: #2563eb;">Home</a>
            </p>
        </div>
    </div>
</body>
</html>
    `;

    // Send email via Resend API
    try {
        const response = await fetch('https://api.resend.com/emails', {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${RESEND_API_KEY}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                from: FROM_EMAIL,
                to: email,
                subject: 'Your PRISM Framework Strategic Playbook Access',
                html: emailHtml
            })
        });

        const data = await response.json();

        if (!response.ok) {
            console.error('Resend API error:', data);
            return res.status(response.status).json({
                error: data.message || 'Failed to send email'
            });
        }

        return res.status(200).json({
            success: true,
            messageId: data.id,
            email: email
        });

    } catch (error) {
        console.error('Error sending email:', error);
        return res.status(500).json({
            error: 'Internal server error',
            details: error.message
        });
    }
}

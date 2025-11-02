# Resend API Setup Guide for PRISM Playbook

This guide explains how to configure Resend API for sending playbook access emails.

## Overview

The playbook system uses **Resend** (https://resend.com) to send beautiful HTML emails with unique access links.

**Flow:**
1. User fills out signup form
2. Backend serverless function calls Resend API
3. Resend sends professional HTML email
4. User clicks link → accesses playbook

## Why Resend?

- ✅ **Free Tier**: 100 emails/day, 3,000/month
- ✅ **Beautiful Templates**: HTML email support
- ✅ **Great Deliverability**: Optimized for inbox delivery
- ✅ **Simple API**: Easy to integrate
- ✅ **Domain Verification**: Use your own domain

---

## Step 1: Sign Up for Resend

1. Go to [https://resend.com](https://resend.com)
2. Click "Start Building" or "Sign Up"
3. Create your account (free tier available)
4. Verify your email address

---

## Step 2: Get Your API Key

1. Log in to Resend dashboard
2. Go to **API Keys** section
3. Click **Create API Key**
4. Name it: `PRISM Playbook`
5. Copy the API key (starts with `re_`)
   - Example: `re_123abc456def789`
6. **Save it securely** - you can't see it again!

---

## Step 3: Verify Your Domain (Optional but Recommended)

For production, verify your domain to send from `noreply@yourdomain.com`:

1. In Resend dashboard, go to **Domains**
2. Click **Add Domain**
3. Enter your domain (e.g., `yourdomain.com`)
4. Add the DNS records to your domain provider:
   - SPF record
   - DKIM records
5. Wait for verification (usually 5-15 minutes)

**For testing**, you can use Resend's test domain: `onboarding@resend.dev`

---

## Step 4: Deploy the Serverless Function

You have several deployment options:

### Option A: Vercel (Recommended - Easiest)

1. **Install Vercel CLI**:
   ```bash
   npm i -g vercel
   ```

2. **Create vercel.json** in `website/` folder:
   ```json
   {
     "functions": {
       "api/**/*.js": {
         "runtime": "nodejs18.x"
       }
     },
     "env": {
       "RESEND_API_KEY": "@resend_api_key",
       "FROM_EMAIL": "noreply@yourdomain.com"
     }
   }
   ```

3. **Deploy**:
   ```bash
   cd website
   vercel
   ```

4. **Add Environment Variables** in Vercel dashboard:
   - Go to your project settings
   - Environment Variables section
   - Add: `RESEND_API_KEY` = `re_your_api_key`
   - Add: `FROM_EMAIL` = `noreply@yourdomain.com`

5. **Get your API endpoint**:
   - Vercel will give you a URL like: `https://your-project.vercel.app`
   - Your API endpoint is: `https://your-project.vercel.app/api/send-playbook`

### Option B: Netlify

1. **Create netlify.toml** in `website/` folder:
   ```toml
   [build]
     functions = "api"

   [[redirects]]
     from = "/api/*"
     to = "/.netlify/functions/:splat"
     status = 200
   ```

2. **Rename function**:
   ```bash
   mv website/api/send-playbook.js website/api/send-playbook-netlify.js
   ```

3. **Deploy**:
   - Connect your Git repo to Netlify
   - Or use Netlify CLI: `netlify deploy`

4. **Add Environment Variables**:
   - Go to Site settings → Environment variables
   - Add: `RESEND_API_KEY`
   - Add: `FROM_EMAIL`

### Option C: Local Development Server

For testing locally before deployment:

1. **Create test server** (`website/server.js`):
   ```javascript
   const express = require('express');
   const cors = require('cors');
   require('dotenv').config();

   const app = express();
   app.use(cors());
   app.use(express.json());
   app.use(express.static('.'));

   // Import the serverless function
   const handler = require('./api/send-playbook.js');

   app.post('/api/send-playbook', async (req, res) => {
       await handler.default(req, res);
   });

   app.listen(3000, () => {
       console.log('Server running on http://localhost:3000');
   });
   ```

2. **Create .env file**:
   ```
   RESEND_API_KEY=re_your_api_key_here
   FROM_EMAIL=noreply@yourdomain.com
   ```

3. **Install dependencies**:
   ```bash
   npm install express cors dotenv
   ```

4. **Run server**:
   ```bash
   node server.js
   ```

5. **Update playbook.js** API_ENDPOINT:
   ```javascript
   API_ENDPOINT: 'http://localhost:3000/api/send-playbook'
   ```

---

## Step 5: Configure Frontend

Update `website/playbook.js` line 68:

```javascript
API_ENDPOINT: 'https://your-project.vercel.app/api/send-playbook'
```

Replace with your actual deployment URL.

---

## Testing

1. **Open playbook page**: `website/playbook.html`
2. **Fill out form** with a real email you can check
3. **Click "Send Access Link"**
4. **Check your email** (inbox or spam folder)
5. **Click the link** in the email
6. **Playbook should load** ✅

---

## Email Template Customization

The email template is defined in `website/api/send-playbook.js`.

To customize:
1. Find the `emailHtml` variable (around line 30)
2. Modify HTML/CSS as needed
3. Redeploy your function

**Variables available:**
- `${name}` - User's name
- `${email}` - User's email
- `${company}` - Company name
- `${role}` - User's role
- `${accessLink}` - Unique playbook URL
- `${baseUrl}` - Your website base URL

---

## Production Checklist

Before going live:

- [ ] Resend API key configured
- [ ] Domain verified (or using Resend test domain)
- [ ] Serverless function deployed
- [ ] Environment variables set
- [ ] API endpoint URL updated in playbook.js
- [ ] Test email sent and received
- [ ] Email lands in inbox (not spam)
- [ ] Access link works correctly
- [ ] Mobile email display tested
- [ ] Error handling tested

---

## Troubleshooting

### Emails Not Sending

**Check Console Logs**:
1. Open browser DevTools → Console
2. Look for error messages
3. Check API response

**Verify API Key**:
1. Ensure API key is correct (starts with `re_`)
2. Check it's set in environment variables
3. Redeploy after changing variables

**Check Resend Dashboard**:
1. Go to resend.com → Logs
2. See email delivery status
3. Check for errors

### Emails Going to Spam

**Solutions:**
1. Verify your domain in Resend
2. Add SPF and DKIM records
3. Warm up your domain (send gradually increasing volume)
4. Avoid spam trigger words in subject/body
5. Include unsubscribe link (optional)

### CORS Errors

If you see CORS errors:

1. Check API function has CORS headers:
   ```javascript
   res.setHeader('Access-Control-Allow-Origin', '*');
   ```

2. If using custom domain, update allowed origin:
   ```javascript
   res.setHeader('Access-Control-Allow-Origin', 'https://yourdomain.com');
   ```

### API Endpoint Not Found (404)

1. Verify deployment URL is correct
2. Check function is deployed: visit `https://your-url/api/send-playbook` directly
3. Ensure environment variables are set
4. Redeploy the function

---

## Cost & Limits

### Resend Free Tier
- **100 emails per day**
- **3,000 emails per month**
- Perfect for getting started

### Paid Plans
- **$20/month**: 50,000 emails/month
- **$80/month**: 100,000 emails/month
- Custom pricing for higher volumes

---

## Demo Mode

If API endpoint is not configured, the system runs in demo mode:

1. Console logs email details
2. Alert shows access link
3. Auto-redirects to playbook after 2 seconds

Perfect for testing without deploying!

---

## Advanced: Custom Domain Email

To send from `playbook@yourdomain.com`:

1. **Verify domain** in Resend
2. **Add DNS records** (SPF, DKIM)
3. **Update FROM_EMAIL**:
   ```javascript
   FROM_EMAIL: 'playbook@yourdomain.com'
   ```
4. **Redeploy function**

---

## Security Best Practices

1. **Never expose API key** in frontend code
2. **Use environment variables** for sensitive data
3. **Validate email addresses** server-side
4. **Implement rate limiting** to prevent abuse
5. **Add reCAPTCHA** if spam becomes an issue
6. **Use HTTPS** for all API calls

---

## Support & Resources

- **Resend Docs**: [https://resend.com/docs](https://resend.com/docs)
- **Resend Status**: [https://status.resend.com](https://status.resend.com)
- **Vercel Docs**: [https://vercel.com/docs](https://vercel.com/docs)
- **Netlify Docs**: [https://docs.netlify.com](https://docs.netlify.com)

---

## Quick Start Summary

```bash
# 1. Sign up for Resend → Get API key
# 2. Deploy to Vercel
cd website
vercel

# 3. Add environment variables in Vercel dashboard
RESEND_API_KEY=re_your_key
FROM_EMAIL=noreply@yourdomain.com

# 4. Update playbook.js with your Vercel URL
API_ENDPOINT: 'https://your-project.vercel.app/api/send-playbook'

# 5. Test!
```

✅ You're ready to send beautiful playbook access emails!

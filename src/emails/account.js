const sgmail = require('@sendgrid/mail')
sgmail.setApiKey(process.env.SENDGRID_API_KEY)

const sendWelcomeEmail = (email, name) => {
    sgmail.send({
        to: email,
        from: 'chakshu.saraswat@gmail.com',
        subject: 'Thanks for joining in',
        text: `Welcome to the app, ${name}. Let me know how you get along with the app`
    })
}

const sendCancellationEmail = (email, name) => {
    sgmail.send({
        to: email,
        from: 'chakshu.saraswat@gmail.com',
        subject: 'Sorry to see you go',
        text: `GoodBye, ${name}. Hope to see you soon`
    })
}

module.exports = {
    sendWelcomeEmail,
    sendCancellationEmail
}
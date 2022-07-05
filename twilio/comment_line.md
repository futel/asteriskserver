# Twilio comment line

Set up a comment line with Twilio.

# Usage

Users call incoming number, are prompted, leave comments.

Admin retrieves recordings via Twilio interface. Admin requires full Twilio admin permissions, there is probably a better way.

Recordings are accessed at Monitor(left nav): Recordings.

# Setup

## Create Asset (classic)

The Asset is the sound file that will be played as the voice prompt.
Note that the (classic) title probably means that this is deprecated.
Upload sound file.

## Create TwiML Bin

### friendly name
<name>

### twiml

Replace ASSET with the URL of the prompt asset.

    <?xml version="1.0" encoding="UTF-8"?>
    <Response>
        <Play>ASSET</Play>
      <Record />
    </Response>

## Create phone number

### Voice & Fax accept incoming
voice calls
### Voice & Fax configure with
TwiML Bin BIN
### Messaging
(just make sure there's no default autoresponder)

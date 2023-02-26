# Set up BulkVS outbound calling

This should only need to be done once.

## Enable outbound calling

account -> service status

## Set up billing

account -> payments

## Create SIP Registration trunk group

<prefix> is account-specific
<name> is <prefix>_foo, <prefix>_bar, <prefix>_virtualbox, ...

    Interconnection -> Trunk Group - Manage -> SIP Registration Trunk Group -> Create
    Trunk Group Name: <name>
    Password: <password>
    Max Calls In: 1
    Max Calls Out: 25
    Verstat Header: on
    Identity Header: off
    Digit Delivery: E164

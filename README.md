# Bitcoin Of Things mobile demo
  A mobile application that connects to the Bitcoin Of Things IOT service


## Connecting to BitcoinOfThings
  1) Open the mobile app, make sure topic is set to 'demo', then click Subscribe
  2) On https://bitcoinofthings.com/send web page make sure topic is set to 'demo'. Enter a message and click Submit.
  
The message sent from BitcoinOfThings should appear on your mobile device.

Your message was recorded on the blockchain and used to contol your device.

## Technical settins
  The demonstration connection settings are in config/private.json
```
{
    "broker": "mqtt.bitcoinofthings.com",
    "username": "demo",
    "key": "demo"
}
```

## Attribution  
  The code is copied from https://github.com/BitKnitting/flutter_adafruit_mqtt


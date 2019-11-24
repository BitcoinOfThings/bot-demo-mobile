[![Codemagic build status](https://api.codemagic.io/apps/5ddad9aaeda3b30d6aa2a615/5ddad9aaeda3b30d6aa2a614/status_badge.svg)](https://codemagic.io/apps/5ddad9aaeda3b30d6aa2a615/5ddad9aaeda3b30d6aa2a614/latest_build)

# [Bitcoin Of Things](https://bitcoinofthings.com) mobile demo
  This is a demo mobile application written in Flutter that connects your phone to the [Bitcoin Of Things IOT service](https://bitcoinofthings.com).


## Its easy to try the BitcoinOfThings IOT service
  1) Open the mobile app, make sure topic is set to 'demo', then click Subscribe
  2) On another device or desktop machine, open the web page https://bitcoinofthings.com/send, make sure the topic is set to 'demo'. Enter a message and click Submit.
  
After a short moment, the message you sent from BitcoinOfThings site should appear on your mobile device.

Your message was recorded on the blockchain and used to contol your device.

See the web site for more sample applications and ideas for controlling your devices at home and on the go, all recorded on Bitcoin and the [BitcoinOfThings](https://bitcoinofthings.com).

## Technical Info
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


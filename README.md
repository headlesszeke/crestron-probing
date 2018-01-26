# Crestron Device Probing
Yet another script for sending out a device discovery probe and parsing responses for useful info. This time it is Crestron high-end AV equipment like you would see in a large office, hotel, sports stadium, rich person's house, etc. Sending a particular packet to UDP port 41794 on broadcast or unicast will cause a Crestron device to respond with its model, firmware version, etc.
### Example output:
```
$ ./scan.rb
sending discover request
waiting 5 seconds for responses...

----192.168.1.224----
Hostname: MC3-MAIN
Model: MC3
Firmware: 1.008.0040
Build date: Nov 07 2013
---------------------
done
```

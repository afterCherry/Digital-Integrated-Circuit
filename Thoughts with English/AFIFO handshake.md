# full handshake
level synchronizers
wait: Two circuits wait for each other before asserting or dropping their respective signal.
1. Circuit A: assert request signal
2. Circuit B: detect the request signal is valid, then assert acknowledgement signal
3. Circuit A: detect acknowledgement signal is valid, drop the request signal
4. Circuit B: detect the request signal is invalid, drop the acknowledgement signal
![Image text](https://github.com/afterCherry/Digital-Integrated-Circuit/blob/main/Images/Multiple%20Clocks/full_handshake.png)

# partial handshake
- mix level and pulse signal<br>
not wait: Two circuits not wait for other before dropping their respective signal.<br>
Circuit A: use pulse synchronizer for acknowledgement signal<br>
Circuit B: use level synchronizer for request signal<br>
![Image text](https://github.com/afterCherry/Digital-Integrated-Circuit/blob/main/Images/Multiple%20Clocks/partial_handshake%20level%20and%20pulse.png)

- only pulse signal
pulse synchronizers<br>
edge synchronizers- if either circuit that has a clock that is twice as fast as the other<br>
![Image text](https://github.com/afterCherry/Digital-Integrated-Circuit/blob/main/Images/Multiple%20Clocks/partial_handshake%20pulse.png)

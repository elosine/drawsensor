(
s.boot;
~ino = ArduinoSMS("/dev/tty.usbserial-AE015LG5", 9600);
~kbs = {Bus.control(s)}!50;
)
(
~ino.action = {
	arg msg;
	var msgs, datasplit, data;
	msgs = msg.asString.split($;);
	data = Array.newClear(msgs.size);
	msgs.do{
		arg it, ix;
		datasplit = it.split($:);


		if(datasplit[0] == "CS2", {
			~kbs[0].set( datasplit[1].asFloat.linlin(20.0, 90.0, 1.0, 0.0) );
		});


		if(datasplit[0] == "tr2", {
			~kbs[1].set(datasplit[1].asInteger);
		});


	};
};


SynthDef(\acl, {
	arg gate = 0;
	var env, sig, freq;
	env = EnvGen.ar(Env.asr(releaseTime:0.2), gate);
	freq = \pitch.kr(60, 0.05).linlin(0.0, 1.0, 48.0, 72.0).round.poll.midicps;
	sig = SinOsc.ar( freq);
	Out.ar(0, sig*env );
}).add;
)

a = Synth(\acl);
a.free;

~kbs[0].get;
a.map(\pitch, ~kbs[0]);
a.map(\gate, ~kbs[1]);










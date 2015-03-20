SerialPort.listDevices;


(
s.boot;
~ino = ArduinoSMS("/dev/tty.usbserial-AE015KH2", 9600);
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
			datasplit.postln;
			~kbs[0].set( datasplit[1].asFloat.linlin(20.0, 90.0, 1.0, 0.0) );
		});


		if(datasplit[0] == "tr2", {
			~kbs[1].set(datasplit[1].asInteger);
		});


	};
};



SynthDef( \subsynth, {
	arg pitchlo=48, pitchhi=72, atk=0.001, rel=0.1,
	osc1amp=0.33, osc2amp=0.33, osc3amp=0.33,
	osc1tune=0, osc2tune=0, osc3tune=0,
	rate=1, ffreqlo=50, ffreqhi=15000, gate=1;
	var synth, env, amp, osc1, osc2, osc3, pitch;
	amp = MouseY.kr(1.0, 0.0, lag:0);
	pitch = \ipitch.kr(60, 0.05).linlin(0.0, 1.0, 48.0, 72.0).round;
	env = EnvGen.ar( Env.asr(atk, releaseTime:rel), gate );
	osc1 = SinOsc.ar( (pitch + osc1tune).midicps );
	osc2 = Saw.ar( (pitch + osc2tune).midicps );
	osc3 = Pulse.ar( (pitch + osc3tune).midicps );
	synth = Mix.ar( [osc1*osc1amp, osc2*osc2amp, osc3*osc3amp] );
	synth = RLPF.ar(synth, SinOsc.kr(rate).range(ffreqlo, ffreqhi) );
	Out.ar(0, synth*env*amp);
} ).add;
)

a = Synth(\subsynth);
a.free;

a.set(\gate

a.map(\ipitch, ~kbs[0]);
a.map(\gate, ~kbs[1]);



	b = Buffer.read(s,"/Users/jyang/Desktop/JAM4/samples/94155__kvl-vanman__won-a-coffee-radio-edit-1.wav" );


	SynthDef(\samp, {
		arg buf, trig = 1;
		var synth;
		synth = PlayBuf.ar( 1, buf, trigger:trig );
		Out.ar(0, synth);
	}).add;

	c = Synth(\samp, [\buf, b] );

	c.map(\trig, ~kbs[1]);















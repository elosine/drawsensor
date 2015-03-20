s.boot;

SynthDef( \subsynth, {
	arg pitchlo=48, pitchhi=72, atk=0.001, rel=0.1,
	osc1amp=0.33, osc2amp=0.33, osc3amp=0.33,
	osc1tune=0, osc2tune=0, osc3tune=0,
	rate=1, ffreqlo=50, ffreqhi=15000, gate;
	var synth, env, amp, osc1, osc2, osc3, mpitch;
	amp = MouseY.kr(1.0, 0.0, lag:0);
	mpitch = \pitch.kr(60, 0.05).linlin(0.0, 1.0, 48.0, 72.0).round;
	env = EnvGen.ar( Env.asr(atk, releaseTime:rel), gate );
	osc1 = SinOsc.ar( (pitch + osc1tune).midicps );
	osc2 = Saw.ar( (pitch + osc2tune).midicps );
	osc3 = Pulse.ar( (pitch + osc3tune).midicps );
	synth = Mix.ar( [osc1*osc1amp, osc2*osc2amp, osc3*osc3amp] );
	synth = RLPF.ar(synth, SinOsc.kr(rate).range(ffreqlo, ffreqhi) );
	Out.ar(0, synth*env*amp);
} ).add;

a = Synth(\mt);
a.free;

(
a.set(
	\rate, 0.0, \ffreqlo, 20000, \ffreqhi, 20000,
	\osc2amp, 0.2, \osc3amp, 0.4, \osc1amp, 0.4,
	\osc3tune, -24, \osc1tune, 12, \osc2tune, 11.5
);
)

a.set(
	\rate, 11.3, \ffreqlo, 200, \ffreqhi, 7000,
	\osc2amp, 0.3, \osc3amp, 0.5, \osc1amp, 0.2,
	\osc3tune, -24, \osc1tune, -1
);

a.set(
	\rate, 20.3, \ffreqlo, 100, \ffreqhi, 10000,
	\osc2amp, 0.4, \osc3amp, 0.4, \osc1amp, 0.2,
	\osc3tune, -24, \osc1tune, -1
);

OSCdef(\empire, {a.set(\rate, 13.3, \ffreqlo, 200, \ffreqhi, 7000,\osc2amp, 0.3, \osc3amp, 0.5, \osc1amp, 0.2,\osc3tune, -24, \osc1tune, -1)}, "/empire");
OSCdef(\stay, {a.set(\rate, 0.0, \ffreqlo, 20000, \ffreqhi, 20000,\osc2amp, 0.0, \osc3amp, 0.3, \osc1amp, 0.7, \osc3tune, -24, \osc1tune, 12)}, "/stay");
OSCdef(\fif, {a.set(\rate, 20.3, \ffreqlo, 100, \ffreqhi, 10000,\osc2amp, 0.4, \osc3amp, 0.4, \osc1amp, 0.2,\osc3tune, -24, \osc1tune, -1)}, "/fif");


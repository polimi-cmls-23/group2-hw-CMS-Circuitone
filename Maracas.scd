s.reboot;

(
~envelopeDown = Env.new([0,1,0], [0.03,0.2], [0,-4]);
~envelopeUp = Env.new([0,1,0], [0.01,0.4], [4,-4]);
// ~envelopeDown.plot;
// ~envelopeUp.plot;

SynthDef(\maracas,
	{
		arg density = 10000, pan = 0, reverb = 0.1, goingDown = 1, t_trig = 0, softness = 1, gain = 1;
		var sig, freq, attenuation;

		freq = LinLin.kr(reverb, 0, 0.6, 20000, 3000);
		attenuation = LinLin.kr(reverb, 0, 0.6, 1, 0.6);
		gain = gain * attenuation;
		sig = [Dust2.ar(density, 0.2), Dust2.ar(density, 0.2)];
		sig = SelectX.ar(
			goingDown,
			[
				sig * EnvGen.kr(~envelopeUp, t_trig, timeScale: softness),
				sig * EnvGen.kr(~envelopeDown, t_trig, timeScale: softness)
			]
		);
		sig = FreeVerb2.ar( // FreeVerb2 - true stereo UGen
            sig[0], // Left channel
            sig[1], // Right Channel
            reverb, 0.1, 1
        );
		sig = Pan2.ar(Mix.ar(sig) * gain, pan);
		sig = LPF.ar(sig, freq);
		Out.ar(0, sig);
	}
).add;
)

NetAddr("127.0.0.1", 57120); // Same of the one in processing

(
~maracas = Synth(\maracas);
OSCdef('OSCreceiver', // unfold the message
	{
		arg msg;
		var pan, density, reverb, trigger, isDown = 0, softness, gain;

		pan = msg[1];
		density = msg[2];
		reverb = msg[3];
		trigger = msg[4];
		isDown = msg[5];
		softness = msg[6];
		gain = msg[7];

		pan = LinLin.kr(pan, 0, 1, -1, 1);
		reverb = LinLin.kr(reverb, 0, 1, 0, 0.6);
		softness = LinLin.kr(softness, 2, 255, 0.3, 3);

		if(trigger == '1',
			{
				if((isDown == '1'),
					{
						~maracas.set(
							\pan, pan,
							\density, density,
							\reverb, reverb,
							\goingDown, isDown.asInteger,
							\t_trig, 1,
							\softness, softness,
							\gain, gain
						);
				});
				if((isDown == '0'),
					{
						~maracas.set(
							\pan, pan,
							\density, density,
							\reverb, reverb,
							\goingDown, isDown.asInteger,
							\t_trig, 1,
							\softness, softness,
							\gain, gain
						);
				});
		});
	},
	"/mar"
);

)
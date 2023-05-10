// { Dust2.ar(MouseX.kr(1,10000,1), 0.4) }.scope(1, zoom:4);

s.boot;

(
~envelopeDown = Env.new([0,1,0], [0.03,0.2], [0,-4]);
~envelopeUp = Env.new([0,1,0], [0.01,0.4], [4,-4]);
// ~envelopeDown.plot;
// ~envelopeUp.plot;

SynthDef(\maracas,
	{
		arg density = 10000, reverb = 0.1, goingDown = 1, t_trig = 0;
		var sig;

		sig = [Dust2.ar(density, 0.2), Dust2.ar(density, 0.2)];
		sig = SelectX.ar(
			goingDown,
			[
				sig * EnvGen.kr(~envelopeUp, t_trig),
				sig * EnvGen.kr(~envelopeDown, t_trig)
			]
		);
		sig = FreeVerb2.ar( // FreeVerb2 - true stereo UGen
            sig[0], // Left channel
            sig[1], // Right Channel
            reverb, 0.1, 1
        );
		Out.ar(0, sig);
	}
).add;

/*
~testDown = Synth(\maracas, [\density, 5000, \reverb, 0.2, \goingDown, 1]);
~testUp = Synth(\maracas, [\density, 5000, \reverb, 0.2, \goingDown, 0]);
~testDown.set(\t_trig, 1);
~testUp.set(\t_trig, 1);
*/

NetAddr("127.0.0.1", 57120); // Same of the one in processing

~maracas = Synth(\maracas);

OSCdef('OSCreceiver', // unfold the message
	{
		arg msg;
		var density, reverb, trigger, isDown = 0;

		density = msg[1];
		reverb = msg[2];
		trigger = msg[3];
		isDown = msg[4];

		reverb = reverb / 2;
		density = (density * 7000) + 3000;

		if(trigger == '1',
			{
				if((isDown == '1'),
					{
						~maracas.set(
							\density, density,
							\reverb, reverb,
							\goingDown, isDown.asInteger,
							\t_trig, 1);
				});
				if((isDown == '0'),
					{
						~maracas.set(\density, density,
							\reverb, reverb,
							\goingDown, isDown.asInteger,
							\t_trig, 1);
				});
		});
	},
	"/mar"
);

)
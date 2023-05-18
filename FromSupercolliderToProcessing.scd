
// Define the SynthDef
SynthDef(\sine, {
    |out = 0, freq = 440, amp = 0.3|
    var sig = SinOsc.ar(freq);
    Out.ar(out, sig * amp);
}).add;

// Create an instance of the Synth
s = Synth(\sine);

// Create a Scope object for visualization
s.scope;


// Send audio as OSC messages
var audioData = s.bufFrames.collect { |frameNum|
    s.bufRead(frameNum);
};

audioData.do { |frame|
    OSCdef.sendMsg("/audio", frame);
};



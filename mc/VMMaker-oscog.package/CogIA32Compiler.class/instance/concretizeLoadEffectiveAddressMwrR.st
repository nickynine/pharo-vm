generate machine code
concretizeLoadEffectiveAddressMwrR
	"Will get inlined into concretizeAt: switch."
	<inline: true>
	| srcReg offset destReg |
	offset := operands at: 0.
	srcReg := self concreteRegister: (operands at: 1).
	destReg := self concreteRegister: (operands at: 2).
	srcReg ~= ESP ifTrue:
		[(self isQuick: offset) ifTrue:
			[machineCode
				at: 0 put: 16r8D;
				at: 1 put: (self mod: ModRegRegDisp8 RM: srcReg RO: destReg);
				at: 2 put: (offset bitAnd: 16rFF).
			 ^machineCodeSize := 3].
		machineCode
			at: 0 put: 16r8D;
			at: 1 put: (self mod: ModRegRegDisp32 RM: srcReg RO: destReg);
			at: 2 put: (offset bitAnd: 16rFF);
			at: 3 put: (offset >> 8 bitAnd: 16rFF);
			at: 4 put: (offset >> 16 bitAnd: 16rFF);
			at: 5 put: (offset >> 24 bitAnd: 16rFF).
		^machineCodeSize := 6].
	"ESP:"
	(self isQuick: offset) ifTrue:
		[machineCode
			at: 0 put: 16r8D;
			at: 1 put: (self mod: ModRegRegDisp8 RM: srcReg RO: destReg);
			at: 2 put: (self s: SIB1 i: 4 b: srcReg);
			at: 3 put: (offset bitAnd: 16rFF).
		 ^machineCodeSize := 4].
	machineCode
		at: 0 put: 16r8D;
		at: 1 put: (self mod: ModRegRegDisp32 RM: srcReg RO: destReg);
		at: 2 put: (self s: SIB1 i: 4 b: srcReg);
		at: 3 put: (offset bitAnd: 16rFF);
		at: 4 put: (offset >> 8 bitAnd: 16rFF);
		at: 5 put: (offset >> 16 bitAnd: 16rFF);
		at: 6 put: (offset >> 24 bitAnd: 16rFF).
	^machineCodeSize := 7
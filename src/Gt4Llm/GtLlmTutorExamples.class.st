Class {
	#name : #GtLlmTutorExamples,
	#superclass : #Object,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmTutorExamples >> basicTutor [
	<gtExample>
	| tutor |
	tutor :=  GtLlmTutor new.
	
	self assert: tutor actions size equals: 1.
	self assert: tutor instruction formats size equals: 2.
	
	^ tutor
]

{ #category : #'as yet unclassified' }
GtLlmTutorExamples >> tutorChat [
	<gtExample>
	| tutor chat |
	tutor := self tutorWithActionAndFormatAdded.
	chat := tutor createChat.

	self assert: (chat provider isKindOf: GtLlmNullProvider).
	self assert: chat provider chat equals: chat.
	
	^ chat
]

{ #category : #'as yet unclassified' }
GtLlmTutorExamples >> tutorChatWithMessage [
	<gtExample>
	| chat |
	chat := self tutorChat.

	chat sendAction: (GtLlmActionCall action: 'example' arguments: {}).

	self assert: chat status isDone.
	self assert: chat messages size equals: 1.
	self assert: chat messages last action equals: 'example'.

	^ chat
]

{ #category : #'as yet unclassified' }
GtLlmTutorExamples >> tutorWithActionAdded [
	<gtExample>
	| tutor exampleAction |
	tutor := self tutorWithNullProviderStencil.
	exampleAction := GtLlmTutorAction new name: 'example'.

	tutor addAction: exampleAction.

	self assert: tutor actions size equals: 2.
	self assert: (tutor actionNamed: 'example') equals: exampleAction.
	
	^ tutor
]

{ #category : #'as yet unclassified' }
GtLlmTutorExamples >> tutorWithActionAndFormatAdded [
	<gtExample>
	| tutor exampleFormat |
	tutor := self tutorWithActionAdded.
	exampleFormat := GtLlmTutorFormatDescription new
			name: 'example';
			format: 'Text'.
	tutor addFormat: exampleFormat.

	self assert: tutor instruction formats size equals: 3.
	self assert: (tutor formatNamed: 'example') equals: exampleFormat.

	^ tutor
]

{ #category : #'as yet unclassified' }
GtLlmTutorExamples >> tutorWithNullProviderStencil [
	<gtExample>
	| tutor |
	tutor := self basicTutor.

	tutor
		providerStencil: [ :instruction | 
			GtLlmNullProvider new
				instructions: instruction asInstructionPiece instructionString;
				format: instruction asJsonSchema ].

	^ tutor
]

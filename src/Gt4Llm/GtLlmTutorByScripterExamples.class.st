Class {
	#name : #GtLlmTutorByScripterExamples,
	#superclass : #Object,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmTutorByScripterExamples >> basicTutor [
	<gtExample>
	| tutor |
	tutor :=  GtLlmTutor new.
	
	self assert: tutor actions size equals: 1.
	self assert: tutor instruction formats size equals: 2.
	
	^ tutor
]

{ #category : #'as yet unclassified' }
GtLlmTutorByScripterExamples >> chatElement [
	<gtExample>
	^ self tutorChat asElement
]

{ #category : #'as yet unclassified' }
GtLlmTutorByScripterExamples >> chatElementWithMessageSent [
	<gtExample>
	| scripter |
	scripter := self chatElementWithMessageTyped.

	scripter
		clickStep: [ :s | 
			s
				label: 'Click on Send';
				id: #send ].

	self
		assert: scripter element chatViewModel assistantChat messages size
		equals: 2.
	self
		assert: scripter element chatViewModel assistantChat messages first content
		equals: '{"Action":"Chat: Hi!"}'.
	self
		assert: (scripter element chatViewModel assistantChat messages at: 2) content
		equals: 'Hello! I am your AI assistant, what can I do for you?'.

	^ scripter
]

{ #category : #'as yet unclassified' }
GtLlmTutorByScripterExamples >> chatElementWithMessageTyped [
	<gtExample>
	| scripter |
	scripter := self scripterOnTutorChat.

	scripter
		clickStep: [ :s | 
			s
				label: 'Click on Editor';
				id: #contents ].

	scripter
		typeStep: [ :s | 
			s
				label: 'Type message';
				text: 'Hi!' ].


	^ scripter
]

{ #category : #'as yet unclassified' }
GtLlmTutorByScripterExamples >> scripterOnTutorChat [
	<gtExample>
	^ BlScripter new element: self tutorChat asElement
]

{ #category : #'as yet unclassified' }
GtLlmTutorByScripterExamples >> tutorChat [
	<gtExample>
	| tutor chat |
	tutor := self tutorWithStaticProviderStencil.
	chat := tutor createChat.

	self assert: (chat provider isKindOf: GtLlmStaticProvider).
	self assert: chat provider chat equals: chat.
	
	^ chat
]

{ #category : #'as yet unclassified' }
GtLlmTutorByScripterExamples >> tutorWithStaticProviderStencil [
	<gtExample>
	| tutor |
	tutor := self basicTutor.

	tutor
		providerStencil: [ :instruction | 
			GtLlmStaticProvider new
				instructions: instruction asInstructionPiece instructionString;
				format: instruction asJsonSchema;
				messages: {'Hello! I am your AI assistant, what can I do for you?'} ].

	^ tutor
]

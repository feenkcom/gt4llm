Class {
	#name : #GtLlmAssistantExamples,
	#superclass : #Object,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmAssistantExamples >> assistantChat [
	<gtExample>
	| tutor chat |
	tutor := self assistantWithActionAndFormatAdded.
	chat := tutor createChat.

	self assert: (chat provider isKindOf: GtLlmNullProvider).
	self assert: chat provider chat equals: chat.
	
	^ chat
]

{ #category : #'as yet unclassified' }
GtLlmAssistantExamples >> assistantChatWithMessage [
	<gtExample>
	| chat |
	chat := self assistantChat.

	chat sendAction: (GtLlmActionCall action: 'example' arguments: {}).

	self assert: chat status isDone.
	self assert: chat messages size equals: 1.
	self assert: chat messages last action equals: 'example'.

	^ chat
]

{ #category : #'as yet unclassified' }
GtLlmAssistantExamples >> assistantWithActionAdded [
	<gtExample>
	| tutor exampleAction |
	tutor := self assistantWithNullProviderStencil.
	exampleAction := GtLlmAssistantAction new name: 'example'.

	tutor addAction: exampleAction.

	self assert: tutor actions size equals: 2.
	self assert: (tutor actionNamed: 'example') equals: exampleAction.
	
	^ tutor
]

{ #category : #'as yet unclassified' }
GtLlmAssistantExamples >> assistantWithActionAndFormatAdded [
	<gtExample>
	| tutor exampleFormat |
	tutor := self assistantWithActionAdded.
	exampleFormat := GtLlmAssistantFormatDescription new
			name: 'example';
			format: 'Text'.
	tutor addFormat: exampleFormat.

	self assert: tutor instruction formats size equals: 3.
	self assert: (tutor formatNamed: 'example') equals: exampleFormat.

	^ tutor
]

{ #category : #'as yet unclassified' }
GtLlmAssistantExamples >> assistantWithNullProviderStencil [
	<gtExample>
	| tutor |
	tutor := self basicAssistant.

	tutor
		providerStencil: [ :instruction | 
			GtLlmNullProvider new
				instructions: instruction asInstructionPiece instructionString;
				format: instruction asJsonSchema ].

	^ tutor
]

{ #category : #'as yet unclassified' }
GtLlmAssistantExamples >> basicAssistant [
	<gtExample>
	| tutor |
	tutor :=  GtLlmAssistant new.
	
	self assert: tutor actions size equals: 1.
	self assert: tutor instruction formats size equals: 2.
	
	^ tutor
]

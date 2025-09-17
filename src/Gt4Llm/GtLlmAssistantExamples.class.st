Class {
	#name : #GtLlmAssistantExamples,
	#superclass : #Object,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmAssistantExamples >> assistantChat [
	<gtExample>
	| assistant chat |
	assistant := self assistantWithActionAndFormatAdded.
	chat := assistant createChatWithProvider: GtLlmNullProvider new.

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
	tutor := self basicAssistant.
	exampleAction := GtLlmAssistantAction new name: 'example'.

	tutor addAction: exampleAction.

	self assert: tutor actions size equals: 2.
	self assert: (tutor actionNamed: 'example') equals: exampleAction.
	
	^ tutor
]

{ #category : #'as yet unclassified' }
GtLlmAssistantExamples >> assistantWithActionAddedTwice [
	<gtExample>
	| tutor exampleAction errored |
	tutor := self assistantWithActionAdded.
	exampleAction := GtLlmAssistantAction new name: 'example'.
	errored := false.

	[ tutor addAction: exampleAction ] on: Error do: [ errored := true ].

	self assert: errored description: [ 'Actions should only be add-able once' ].

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

	self assert: tutor instruction formats size equals: 4.
	self assert: (tutor formatNamed: 'example') equals: exampleFormat.

	^ tutor
]

{ #category : #'as yet unclassified' }
GtLlmAssistantExamples >> assistantWithFormatAddedTwice [
	<gtExample>
	| tutor exampleFormat errored |
	tutor := self assistantWithActionAndFormatAdded.
	exampleFormat := GtLlmAssistantFormatDescription new
			name: 'example';
			format: 'Text'.
	errored := false.

	[ tutor addFormat: exampleFormat ] on: Error do: [ errored := true ].

	self assert: errored description: [ 'Formats should only be add-able once' ].

	^ tutor
]

{ #category : #'as yet unclassified' }
GtLlmAssistantExamples >> basicAssistant [
	<gtExample>
	| assistant |
	assistant :=  GtLlmAssistant new.
	
	self assert: assistant actions size equals: 1.
	self assert: assistant instruction formats size equals: 3.
	self assert: assistant collectTools isEmpty.
	^ assistant
]

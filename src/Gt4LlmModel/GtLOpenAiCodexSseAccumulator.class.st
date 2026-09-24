Class {
	#name : #GtLOpenAiCodexSseAccumulator,
	#superclass : #Object,
	#instVars : [
		'buffer',
		'terminalResponse',
		'events'
	],
	#category : #'Gt4LlmModel-Codex'
}

{ #category : #consuming }
GtLOpenAiCodexSseAccumulator >> consume: aString [
	| separator frame data dataStart |
	buffer isEmpty
		ifTrue: [ (aString notEmpty and: [ aString first = ${ ]) ifTrue:
			[ terminalResponse := NeoJSONReader fromString: aString.
			^ self ] ].
	buffer := buffer , aString copyReplaceAll: String cr with: ''.
	[ separator := buffer findString: String lf , String lf startingAt: 1.
	separator > 0 ] whileTrue: [
		frame := buffer copyFrom: 1 to: separator - 1.
		buffer := buffer allButFirst: separator + 1.
		dataStart := frame findString: 'data:' startingAt: 1.
		dataStart = 0
			ifTrue: [ data := '' ]
			ifFalse: [
				data := frame allButFirst: dataStart + 4.
				(data notEmpty and: [ data first = 32 ]) ifTrue:
					[ data := data allButFirst ] ].
		data isEmpty ifFalse: [ self consumeData: data ] ].
	^ self
]

{ #category : #streaming }
GtLOpenAiCodexSseAccumulator >> consumeData: aString [
	| event type response |
	aString = '[DONE]' ifTrue: [ ^ self ].
	event := NeoJSONReader fromString: aString.
	events add: event.
	type := event at: 'type' ifAbsent: [ '' ].
	(type = 'response.completed' or: [ type = 'response.incomplete' ]) ifTrue: [
		response := event at: 'response' ifAbsent: [ self error: 'Codex terminal SSE event has no response' ].
		terminalResponse := response ].
	type = 'response.failed' ifTrue: [ self error: 'Codex returned a failed response' ].
	^ self
]

{ #category : #accessing }
GtLOpenAiCodexSseAccumulator >> events [
	^ events asArray
]

{ #category : #private }
GtLOpenAiCodexSseAccumulator >> functionCallItemsFromEvents [
	| items |
	items := events
		select: [ :event | (event at: 'type' ifAbsent: [ '' ]) = 'response.output_item.done' ]
		thenCollect: [ :event | event at: 'item' ifAbsent: [ nil ] ].
	^ items select: [ :item |
		item notNil and: [ (item at: 'type' ifAbsent: [ '' ]) = 'function_call' ] ]
]

{ #category : #initialization }
GtLOpenAiCodexSseAccumulator >> initialize [
	super initialize.
	buffer := ''.
	events := OrderedCollection new
]

{ #category : #private }
GtLOpenAiCodexSseAccumulator >> outputTextFromEvents [
	| doneTexts deltaTexts |
	doneTexts := events
		select: [ :event | (event at: 'type' ifAbsent: [ '' ]) = 'response.output_text.done' ]
		thenCollect: [ :event | event at: 'text' ifAbsent: [ '' ] ].
	doneTexts ifNotEmpty: [
		^ String streamContents: [ :stream |
			doneTexts do: [ :text | stream nextPutAll: text ] ] ].
	deltaTexts := events
		select: [ :event | (event at: 'type' ifAbsent: [ '' ]) = 'response.output_text.delta' ]
		thenCollect: [ :event | event at: 'delta' ifAbsent: [ '' ] ].
	^ String streamContents: [ :stream |
		deltaTexts do: [ :text | stream nextPutAll: text ] ]
]

{ #category : #accessing }
GtLOpenAiCodexSseAccumulator >> result [
	| output text content message functionCalls reconstructed |
	terminalResponse ifNil: [ self error: 'Codex stream ended without a terminal response event' ].
	output := terminalResponse at: 'output' ifAbsent: [ #() ].
	output isEmpty ifTrue: [
		reconstructed := OrderedCollection new.
		functionCalls := self functionCallItemsFromEvents.
		reconstructed addAll: functionCalls.
		text := self outputTextFromEvents.
		text isEmpty ifFalse: [
			content := {'type' -> 'output_text'. 'text' -> text} asDictionary.
			message := {'type' -> 'message'. 'role' -> 'assistant'. 'content' -> {content}} asDictionary.
			reconstructed add: message ].
		reconstructed isEmpty ifFalse: [
			terminalResponse at: 'output' put: reconstructed asArray ] ].
	^ terminalResponse
]

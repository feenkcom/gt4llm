Class {
	#name : #GtLFunctionCallOutputEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLFunctionCallOutputEntity >> callId [

	^ self rawData at: 'call_id'
]

{ #category : #private }
GtLFunctionCallOutputEntity >> inputEntityFrom: aJsonObject [

	(aJsonObject includesKey: 'role') ifTrue:
		[ ^ GtLOpenAiMessagesEntity new rawData: aJsonObject ].
	((aJsonObject includesKey: 'type') and:
	[ (aJsonObject at: 'type') = 'function_call' ]) ifTrue:
		[ ^ GtLFunctionCallEntity rawData: aJsonObject ].

	self error: 'Unrecognised entity: ', aJsonObject asString.
]

{ #category : #accessing }
GtLFunctionCallOutputEntity >> output [
	^ (self rawData at: 'output') collect: [ :each | self inputEntityFrom: each ]
]

{ #category : #accessing }
GtLFunctionCallOutputEntity >> type [

	^ self rawData at: 'type'
]

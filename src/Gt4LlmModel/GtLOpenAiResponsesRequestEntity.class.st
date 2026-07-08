Class {
	#name : #GtLOpenAiResponsesRequestEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #ui }
GtLOpenAiResponsesRequestEntity >> gtInputFor: aView [
	<gtView>
	
	^ aView list
		title: 'Input';
		priority: 10;
		items: [ self input ]
]

{ #category : #accessing }
GtLOpenAiResponsesRequestEntity >> input [
	^ (self rawData at: 'input') collect: [ :each | self inputEntityFrom: each ]
]

{ #category : #private }
GtLOpenAiResponsesRequestEntity >> inputEntityFrom: aJsonObject [

	(aJsonObject includesKey: 'role') ifTrue:
		[ ^ GtLOpenAiMessagesEntity new rawData: aJsonObject ].
	((aJsonObject includesKey: 'type') and:
	[ (aJsonObject at: 'type') = 'function_call' ]) ifTrue:
		[ ^ GtLFunctionCallEntity rawData: aJsonObject ].
	((aJsonObject includesKey: 'type') and:
	[ (aJsonObject at: 'type') = 'function_call_output' ]) ifTrue:
		[ ^ GtLFunctionCallOutputEntity rawData: aJsonObject ].

	self error: 'Unrecognised entity: ', aJsonObject asString.
]

{ #category : #accessing }
GtLOpenAiResponsesRequestEntity >> instructions [
	^ self rawData at: 'instructions'
]

{ #category : #accessing }
GtLOpenAiResponsesRequestEntity >> model [
	^ self rawData at: 'model'
]

{ #category : #accessing }
GtLOpenAiResponsesRequestEntity >> stream [
	^ self rawData at: 'stream'
]

{ #category : #accessing }
GtLOpenAiResponsesRequestEntity >> tools [
	^ (self rawData at: 'tools') collect: [ :each | GtLOpenAiToolEntity new rawData: each ]
]

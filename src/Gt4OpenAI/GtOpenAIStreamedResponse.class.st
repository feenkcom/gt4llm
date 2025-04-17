Class {
	#name : #GtOpenAIStreamedResponse,
	#superclass : #GtLlmEntity,
	#instVars : [
		'stream',
		'notificationMessage',
		'provider'
	],
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAIStreamedResponse class >> from: aStream [
	^ self new stream: (GtOpenAISseStream new stream: aStream)
]

{ #category : #'as yet unclassified' }
GtOpenAIStreamedResponse >> hasToolCalls [
	^ self stream hasEventOfType: 'response.output_item.added'
]

{ #category : #'as yet unclassified' }
GtOpenAIStreamedResponse >> notifyOnOutput: aMessage [
	notificationMessage := aMessage
]

{ #category : #'as yet unclassified' }
GtOpenAIStreamedResponse >> onOutput: anAnnouncement [
	provider
		ifNotNil: [ (anAnnouncement event eventType = 'response.output_item.done'
				and: [ (anAnnouncement event data at: 'item') includesKey: 'call_id' ])
				ifTrue: [ provider
						handleToolCall: (GtLlmFunctionToolCall new
								rawData: (anAnnouncement event data at: 'item');
								id: (anAnnouncement event data at: 'item' at: 'call_id');
								name: (anAnnouncement event data at: 'item' at: 'name');
								arguments: (STONJSON fromString: (anAnnouncement event data at: 'item' at: 'arguments'))) ] ].

	notificationMessage ifNil: [ ^ self ].

	notificationMessage content: self output
]

{ #category : #'as yet unclassified' }
GtOpenAIStreamedResponse >> output [
	^ ''
		join: ((self stream eventsOfType: 'response.output_text.delta')
				collect: [ :anEvent | anEvent data at: 'delta' ])
]

{ #category : #accessing }
GtOpenAIStreamedResponse >> provider [
	^ provider
]

{ #category : #accessing }
GtOpenAIStreamedResponse >> provider: anObject [
	provider := anObject
]

{ #category : #accessing }
GtOpenAIStreamedResponse >> stream [
	^ stream
]

{ #category : #accessing }
GtOpenAIStreamedResponse >> stream: anObject [
	stream := anObject.
	
	self subscribeToStream
]

{ #category : #'as yet unclassified' }
GtOpenAIStreamedResponse >> subscribeToStream [
	self stream
		when: GtOpenAISseEventAdded
		send: #onOutput:
		to: self
]

{ #category : #'as yet unclassified' }
GtOpenAIStreamedResponse >> toolCalls [
	^ (self stream eventsOfType: 'response.output_item.done')
		collect: [ :anEvent | 
			GtLlmFunctionToolCall new
				rawData: (anEvent data at: 'item');
				id: (anEvent data at: 'item' at: 'call_id');
				name: (anEvent data at: 'item' at: 'name');
				arguments: (STONJSON fromString: (anEvent data at: 'item' at: 'arguments')) ]
]
